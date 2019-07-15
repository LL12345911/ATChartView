//
//  ATBarChartVIew.m
//  ATChartView
//
//  Created by Mars on 2019/7/13.
//  Copyright © 2019 Mars. All rights reserved.
//

#import "ATBarChartVIew.h"
#import <QuartzCore/QuartzCore.h>

@interface ATBarChartVIew ()

@property (nonatomic,strong) UIScrollView *scrollview;

//Y轴线
@property (nonatomic,strong) CALayer *yAisxLayer;
//X轴线
@property (nonatomic,strong) CALayer *xAisxLayer;
//原点
@property (nonatomic,strong) CATextLayer *originLayer;

@property (nonatomic,strong) NSMutableArray *barArr;

@property (nonatomic,assign) double barWidth;//30
@property (nonatomic,assign) double gropPading;//30
//@property (nonatomic,assign) double *barWidth;//30
@property (nonatomic,assign) NSInteger yMax;//

@property (nonatomic,assign) double yBottom;//
@property (nonatomic,assign) double ytop;//
@property (nonatomic,assign) double yheight;//Y轴的高度
@property (nonatomic,assign) double contentWidth;//内容的宽度
@property (nonatomic,assign) double yAisxLeft;//Y轴距视图左边的距离

@property (nonatomic,assign) CGSize yAisxSize;//Y轴左边文字的CGSize


@property (nonatomic,strong) NSMutableArray *yAisxPointArr;//Y轴坐标点
@property (nonatomic,strong) NSMutableArray *yAisxLineArr;//Y轴分割线

@property (nonatomic,strong) NSMutableArray *xAisxPointArr;//X轴坐标点
@property (nonatomic,strong) NSMutableArray *xAisxValueArr;//X轴坐标点



@end

@implementation ATBarChartVIew

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _barArr = [NSMutableArray arrayWithCapacity:1];
        _yAisxPointArr = [NSMutableArray arrayWithCapacity:1];
        _yAisxLineArr = [NSMutableArray arrayWithCapacity:1];
        _xAisxPointArr = [NSMutableArray arrayWithCapacity:1];
        _xAisxValueArr = [NSMutableArray arrayWithCapacity:1];
        
//        _colorArr = @[RGBCOLOR(0x388EC5), RGBCOLOR(0x00C4A4), RGBCOLOR(0x800007), RGBCOLOR(0xF95B5A), RGBCOLOR(0xFFBE50)];
        _barWidth = 30;
        _gropPading = 20;
        _yBottom = 20;
        _ytop = 15;
        _yheight = self.frame.size.height - _ytop - _yBottom;
        _yAisxLeft = 30;
    }
    return self;
}


-(CGSize)calculateString:(NSString *)str Font:(NSInteger)font width:(CGFloat)width{
    CGSize size = [str boundingRectWithSize:CGSizeMake(width, 100000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:font]} context:nil].size;
    return size;
}

- (void)layoutSubviews{
    _yheight = self.frame.size.height - _ytop - _yBottom;
    
    NSInteger yMax = 0;
    double xAixs = _gropPading - _barWidth;
    
    NSString *xAisxTitle = @"来";
    NSInteger count = 1;
    for (BarChartItem *item in _dataArr) {
        count = item.dataArr > 0 ? item.dataArr.count : 1;
        if (item.xAisxTitle.length > xAisxTitle.length) {
            xAisxTitle = item.xAisxTitle;
        }
        for (int i = 0; i < item.dataArr.count; i++) {
            yMax = [item.dataArr[i] doubleValue] > yMax ? [item.dataArr[i] doubleValue] : yMax;
            xAixs =  1 * _barWidth + xAixs;
        }
        xAixs = xAixs + _gropPading;
    }
    
    NSInteger xx = ((NSInteger)yMax) / 5;
    //NSInteger yPading =  xx  + (xx % 5 != 0 ? 1 : 1);
    NSInteger yPading = xx % 5 != 0 ? (5 * (xx/5 + 1)) : xx+5;
    yMax = yPading * 5;
    _yMax = yMax;
    
    
    CGSize size = [self calculateString:xAisxTitle Font:10 width:_barWidth*count+_gropPading];
    _yBottom = size.height + 10;
    
    
    //    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(50, 50, 100, 50)];
    //    lbl.font = [UIFont systemFontOfSize:15];
    //    lbl.text = [NSString stringWithFormat:@"%ld",yMax];// @"12378";
    //    [lbl sizeToFit];
    //    _yAisxSize = lbl.frame.size;
    //    _yAisxLeft = lbl.frame.size.width + 15;
    
    CGSize xAisxSize = [self calculateString:[NSString stringWithFormat:@"%ld",yMax] Font:15 width:_barWidth*count+_gropPading];
    _yAisxSize = xAisxSize;
    _yAisxLeft = xAisxSize.width + 15;
    
    double yPadBoth = _yheight / 5;
    //Y轴线
    _yAisxLayer.frame = CGRectMake(_yAisxLeft, _ytop, 1, self.frame.size.height-_ytop-_yBottom+5);
    //X轴线
    _xAisxLayer.frame = CGRectMake(_yAisxLeft-5, _ytop+5*yPadBoth-0.5, self.frame.size.width-_yAisxLeft, 1);
    //原点
    _originLayer.frame = CGRectMake(0, _ytop+5*yPadBoth+5, _yAisxLeft, _yAisxSize.height);
    
    
    //c添加 Y轴
    for (int i = 0; i < _yAisxPointArr.count; i++) {
        CATextLayer *textLayer = _yAisxPointArr[i];
        textLayer.string = [NSString stringWithFormat:@"%0.0ld",i*yMax/5];
        textLayer.frame = CGRectMake(0, _ytop+(5-i)*yPadBoth-_yAisxSize.height/2.0, _yAisxLeft, _yAisxSize.height);
        
        if (i != 0) {
            CAShapeLayer *lineLayer = _yAisxLineArr[i-1];
            
            CGMutablePathRef dotteShapePath =  CGPathCreateMutable();
            //设置虚线颜色为blackColor
            [lineLayer setStrokeColor:[[UIColor lightGrayColor] CGColor]];
            //设置虚线宽度
            lineLayer.lineWidth = 1.0f ;
            //10=线的宽度 5=每条线的间距
            NSArray *dotteShapeArr = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:5],[NSNumber
                                                                                                  numberWithInt:5], nil];
            [lineLayer setLineDashPattern:dotteShapeArr];
            // 50为虚线Y值，和下面的50一起用。(s)
            //设置虚线绘制起点
            CGPathMoveToPoint(dotteShapePath, NULL, _yAisxLeft-5 ,_ytop+(5-i)*yPadBoth);
            //设置虚线绘制终点
            CGPathAddLineToPoint(dotteShapePath, NULL, self.frame.size.width-_yAisxLeft+15, _ytop+(5-i)*yPadBoth);
            [lineLayer setPath:dotteShapePath];
            CGPathRelease(dotteShapePath);
            
            //            lineLayer.frame = CGRectMake(_yAisxLeft-5, _ytop+(5-i)*yPadBoth-0.5, self.frame.size.width-_yAisxLeft, 1);
        }
    }
    _scrollview.frame = CGRectMake(_yAisxLeft+1, 0, self.frame.size.width-30-1, self.frame.size.height);
    
    
    xAixs = _gropPading - _barWidth;
    for (int i = 0; i < _dataArr.count; i++) {
        //X轴
        BarChartItem *item = _dataArr[i];
        CATextLayer *textLayer = _xAisxPointArr[i];
        textLayer.frame = CGRectMake(xAixs+_barWidth-_gropPading/2, _ytop+5*yPadBoth+5,_barWidth*item.dataArr.count+_gropPading, _yBottom-5);
        textLayer.wrapped = YES;
        //bar柱形图
        for (int j = 0; j < item.dataArr.count; j++) {
            
            xAixs =  1 * _barWidth + xAixs;
            CGFloat value = [item.dataArr[j] floatValue];
            CGFloat height = [self calculateHeight:value];
            
            CALayer *barLayer = _barArr[i][j];
            barLayer.frame = CGRectMake(xAixs, [self calculateFrameY:value]+_ytop, _barWidth, height);
            
            
            CATextLayer *valueLayer = _xAisxValueArr[i][j];
            if (height > 30) {
                valueLayer.frame = CGRectMake(xAixs, [self calculateFrameY:value]+_ytop+5, _barWidth, _yAisxSize.height);
            }else{
                valueLayer.frame = CGRectMake(xAixs,[self calculateFrameY:value]+_ytop-_yAisxSize.height, _barWidth, _yAisxSize.height);
            }
            CABasicAnimation *scaleUp = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
            scaleUp.fromValue = @0.1;
            scaleUp.toValue = @1;
            scaleUp.duration = 1;
            scaleUp.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            [barLayer addAnimation:scaleUp forKey:@"ff"];
            [valueLayer addAnimation:scaleUp forKey:@"ff5"];
            
        }
        xAixs = xAixs + _gropPading;
    }
    
    _scrollview.contentSize = CGSizeMake(xAixs+_barWidth, self.frame.size.height);
}


- (void)setDataArr:(NSArray *)dataArr{
    _dataArr = dataArr;
    [_barArr  removeAllObjects];
    [_yAisxPointArr  removeAllObjects];
    [_yAisxLineArr  removeAllObjects];
    [_xAisxPointArr  removeAllObjects];
    [_xAisxValueArr  removeAllObjects];
    
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    
    //Y轴线
    [self.layer addSublayer:self.yAisxLayer];
    //X轴线
    [self.layer addSublayer:self.xAisxLayer];
    //原点
    [self.layer addSublayer:self.originLayer];
    
    //c添加 Y轴
    for (int i = 0; i < 6; i++) {
        CATextLayer *yPointLayer= [self creareTextlayer:@"" textColor:[UIColor blackColor] fontSize:15];
        [self.layer addSublayer:yPointLayer];
        [_yAisxPointArr addObject:yPointLayer];
        
        if (i != 0) {
            CAShapeLayer *lineLayer = [CAShapeLayer layer];
            //            CALayer *lineLayer = [CALayer layer];
            //            lineLayer.backgroundColor = [UIColor lightGrayColor].CGColor;
            [self.layer addSublayer:lineLayer];
            [_yAisxLineArr addObject:lineLayer];
        }
    }
    
    _scrollview = [[UIScrollView alloc] init];
    [self addSubview:_scrollview];
    
    for (BarChartItem *item in dataArr) {
        //X轴
        CATextLayer *textLayer = [self creareTextlayer:item.xAisxTitle textColor:[UIColor blackColor] fontSize:10];//
        textLayer.wrapped = YES;
        textLayer.alignmentMode = kCAAlignmentCenter;
        textLayer.truncationMode = kCATruncationEnd;
        [_scrollview.layer addSublayer:textLayer];
        
        [_xAisxPointArr addObject:textLayer];
        
        //bar柱形图
        NSMutableArray *barArr = [NSMutableArray arrayWithCapacity:0];
        NSMutableArray *valueArr = [NSMutableArray arrayWithCapacity:0];
        
        for (int i = 0; i < item.dataArr.count; i++) {
            CGFloat value = [item.dataArr[i] floatValue];
            
            CALayer *barLayer = [CALayer layer];
            [_scrollview.layer addSublayer:barLayer];
            if (_colorArr.count > 0) {
                barLayer.backgroundColor = _colorArr[i % _colorArr.count].CGColor;
            }else{
                if (i == 0) {
                    barLayer.backgroundColor = [UIColor redColor].CGColor;
                }else{
                    barLayer.backgroundColor = [UIColor grayColor].CGColor;
                }
            }
            
            [barArr addObject:barLayer];
            
            CATextLayer *valueLayer= [self creareTextlayer:[NSString stringWithFormat:@"%0.1lf",value] textColor:[UIColor blackColor] fontSize:9];
            valueLayer.truncationMode = kCATruncationEnd;
            valueLayer.wrapped = YES;
            valueLayer.alignmentMode = kCAAlignmentCenter;
            [_scrollview.layer addSublayer:valueLayer];
            
            
            [valueArr addObject:valueLayer];
            
        }
        [_barArr addObject:barArr];
        [_xAisxValueArr addObject:valueArr];
    }
    _scrollview.showsVerticalScrollIndicator = NO;
    _scrollview.showsHorizontalScrollIndicator = NO;
}

- (CATextLayer *)creareTextlayer:(NSString *)string textColor:(UIColor *)textColor fontSize:(CGFloat)fontSize {
    CATextLayer *textLayer= [CATextLayer layer];
    textLayer.string = string;//[NSString stringWithFormat:@"%0.0ld",i*yMax/5];
    textLayer.alignmentMode = kCAAlignmentCenter;
    textLayer.contentsScale = [UIScreen mainScreen].scale;//2.0f;
    textLayer.fontSize = fontSize;//
    textLayer.foregroundColor = textColor.CGColor;
    return textLayer;
}

//计算柱形图framef的y的值
- (double)calculateFrameY:(double)height{
    return (_yheight - [self calculateHeight:height]) > 0 ? (_yheight - [self calculateHeight:height]) : 0;
}

//计算柱形图条的高度
- (double)calculateHeight:(double)height{
    return  (height / _yMax *_yheight);
}

#pragma mark - 懒加载
//Y轴线
- (CALayer *)yAisxLayer{
    if (!_yAisxLayer) {
        _yAisxLayer = [CALayer layer];
        _yAisxLayer.backgroundColor = [UIColor blackColor].CGColor;
    }
    return _yAisxLayer;
}
//X轴线
- (CALayer *)xAisxLayer{
    if (!_xAisxLayer) {
        _xAisxLayer = [CALayer layer];
        _xAisxLayer.backgroundColor = [UIColor blackColor].CGColor;
    }
    return _xAisxLayer;
}


//原点
- (CALayer *)originLayer{
    if (!_originLayer) {
        _originLayer= [self creareTextlayer:@"0" textColor:[UIColor blackColor] fontSize:15];
        _originLayer.frame = CGRectMake(0, self.frame.size.height-_yBottom-5, _yAisxLeft, 15);
    }
    return _originLayer;
}


//- (void)setDataArr:(NSArray *)dataArr{
//    _dataArr = dataArr;
//    [_barArr  removeAllObjects];
//    [_yAisxPointArr  removeAllObjects];
//    [_yAisxLineArr  removeAllObjects];
//    [_xAisxPointArr  removeAllObjects];
//    [_xAisxValueArr  removeAllObjects];
//
//
//
//    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
//    [self.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
//
//    _yheight = self.frame.size.height - _ytop - _yBottom;
//
//    NSInteger yMax = 0;
//    double xAixs = _gropPading - _barWidth;
//    for (BarChartItem *item in dataArr) {
//
//        for (int i = 0; i < item.dataArr.count; i++) {
//            yMax = [item.dataArr[i] doubleValue] > yMax ? [item.dataArr[i] doubleValue] : yMax;
//            xAixs =  1 * _barWidth + xAixs;
//        }
//        xAixs = xAixs + _gropPading;
//    }
//
//    NSInteger xx = ((NSInteger)yMax) / 5;
//    //NSInteger yPading =  xx  + (xx % 5 != 0 ? 1 : 1);
//   NSInteger yPading = xx % 5 != 0 ? (5 * (xx/5 + 1)) : xx+5;
//
//    yMax = yPading * 5;
//
//    _yMax = yMax;
//
//    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(50, 50, 100, 50)];
//    lbl.font = [UIFont systemFontOfSize:15];
//    lbl.text = [NSString stringWithFormat:@"%ld",yMax];// @"12378";
//    [lbl sizeToFit];
//
//    _yAisxSize = lbl.frame.size;
//    _yAisxLeft = lbl.frame.size.width + 15;
//    double yPadBoth = _yheight / 5;
//
//    //Y轴线
//    [self.layer addSublayer:self.yAisxLayer];
//    _yAisxLayer.frame = CGRectMake(_yAisxLeft, _ytop, 1, self.frame.size.height-_ytop-_yBottom+5);
//    //X轴线
//    [self.layer addSublayer:self.xAisxLayer];
//    _xAisxLayer.frame = CGRectMake(_yAisxLeft-5, _ytop+5*yPadBoth-0.5, self.frame.size.width-_yAisxLeft+5, 1);
//
//    //原点
//    [self.layer addSublayer:self.originLayer];
//    _originLayer.frame = CGRectMake(0, _ytop+5*yPadBoth+5, _yAisxLeft, _yAisxSize.height);
//
//
//    //c添加 Y轴
//    for (int i = 0; i < 6; i++) {
//        CATextLayer *textLayer= [self creareTextlayer:[NSString stringWithFormat:@"%0.0ld",i*yMax/5] textColor:[UIColor blackColor] fontSize:15];
//        [self.layer addSublayer:textLayer];
//        textLayer.frame = CGRectMake(0, _ytop+(5-i)*yPadBoth-_yAisxSize.height/2.0, _yAisxLeft, _yAisxSize.height);
//
//        [_yAisxPointArr addObject:textLayer];
//
//        if (i != 0) {
//            CALayer *lineLayer = [CALayer layer];
//            lineLayer.backgroundColor = [UIColor lightGrayColor].CGColor;
//            lineLayer.frame = CGRectMake(_yAisxLeft-5, _ytop+(5-i)*yPadBoth-0.5, self.frame.size.width-_yAisxLeft, 1);
//            [self.layer addSublayer:lineLayer];
//
//            [_yAisxLineArr addObject:lineLayer];
//        }
//    }
//
//
//
//    _scrollview = [[UIScrollView alloc] initWithFrame: CGRectMake(_yAisxLeft+1, 0, self.frame.size.width-30-1, self.frame.size.height)];
//    [self addSubview:_scrollview];
//
//
//    xAixs = _gropPading - _barWidth;
//    for (BarChartItem *item in dataArr) {
//        //X轴
//        CATextLayer *textLayer = [self creareTextlayer:item.xAisxTitle textColor:[UIColor blackColor] fontSize:13];//
//        textLayer.wrapped = YES;
//        textLayer.frame = CGRectMake(xAixs+_barWidth-_gropPading/2, _ytop+5*yPadBoth+5,_barWidth*item.dataArr.count+_gropPading, _yBottom-5);
//        [_scrollview.layer addSublayer:textLayer];
//
//        [_xAisxPointArr addObject:textLayer];
//
//        //bar柱形图
//        NSMutableArray *barArr = [NSMutableArray arrayWithCapacity:0];
//        NSMutableArray *valueArr = [NSMutableArray arrayWithCapacity:0];
//
//         for (int i = 0; i < item.dataArr.count; i++) {
//
//             xAixs =  1 * _barWidth + xAixs;
//             CGFloat value = [item.dataArr[i] floatValue];
//             CGFloat height = [self calculateHeight:value];
//
//             CALayer *barLayer = [CALayer layer];
//             barLayer.frame = CGRectMake(xAixs, [self calculateFrameY:value]+_ytop, _barWidth, height);
//             [_scrollview.layer addSublayer:barLayer];
//             if (_colorArr.count > 0) {
//                 barLayer.backgroundColor = _colorArr[i % _colorArr.count].CGColor;
//             }else{
//                 if (i == 0) {
//                     barLayer.backgroundColor = [UIColor redColor].CGColor;
//                 }else{
//                     barLayer.backgroundColor = [UIColor grayColor].CGColor;
//                 }
//             }
//
//             [barArr addObject:barLayer];
//
//             CATextLayer *valueLayer= [self creareTextlayer:[NSString stringWithFormat:@"%0.1lf",value] textColor:[UIColor blackColor] fontSize:9];
//            valueLayer. truncationMode = kCATruncationEnd;
//             [_scrollview.layer addSublayer:valueLayer];
//             if (height > 30) {
//                 valueLayer.frame = CGRectMake(xAixs, [self calculateFrameY:value]+_ytop+5, _barWidth, _yAisxSize.height);
//             }else{
//                 valueLayer.frame = CGRectMake(xAixs,[self calculateFrameY:value]+_ytop-_yAisxSize.height, _barWidth, _yAisxSize.height);
//             }
//
//             [valueArr addObject:valueLayer];
//
//         }
//        [_barArr addObject:barArr];
//        [_xAisxValueArr addObject:valueArr];
//        xAixs = xAixs + _gropPading;
//    }
//
//
//
//    _scrollview.contentSize = CGSizeMake(xAixs+_barWidth, self.frame.size.height);
//    _scrollview.showsVerticalScrollIndicator = NO;
//    _scrollview.showsHorizontalScrollIndicator = NO;
//
//
//}

@end




@implementation BarChartItem


@end

