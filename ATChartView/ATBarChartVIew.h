//
//  ATBarChartVIew.h
//  ATChartView
//
//  Created by Mars on 2019/7/13.
//  Copyright © 2019 Mars. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class BarChartItem;

@interface ATBarChartVIew : UIView

@property (nonatomic,strong) NSArray<UIColor *> *colorArr;

@property (nonatomic,strong) NSArray<BarChartItem *> *dataArr;


@end



@interface BarChartItem : NSObject

@property (nonatomic,copy) NSString *xAisxTitle;
@property (nonatomic,strong) NSArray *dataArr;


@end



NS_ASSUME_NONNULL_END
