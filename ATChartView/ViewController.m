//
//  ViewController.m
//  ATChartView
//
//  Created by Mars on 2019/7/13.
//  Copyright © 2019 Mars. All rights reserved.
//

#import "ViewController.h"
#import "ATBarChartVIew.h"


@interface ViewController ()
@property (nonatomic,strong) ATBarChartVIew *chartView;
@end

@implementation ViewController
- (IBAction)clickMethod:(id)sender {
    
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:1];
    for (int i =0 ; i < 12; i++) {
        BarChartItem *item = [[BarChartItem alloc] init];
        item.xAisxTitle = [NSString stringWithFormat:@"第%d级",i];
        item.dataArr = @[
                         @(arc4random() % 17 + 1),
                         @(arc4random() % 67 + 1),
                         ];
        [arr addObject:item];
    }
    
    _chartView.dataArr = arr;
    _chartView.frame = CGRectMake(0, arc4random()%10, arc4random()%200+300, arc4random()%200+300);
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

    _chartView = [[ATBarChartVIew alloc] initWithFrame:CGRectMake(10, 100, 400, 400)];
    _chartView.backgroundColor = [UIColor greenColor];
    
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:1];
    for (int i =0 ; i < 12; i++) {
        BarChartItem *item = [[BarChartItem alloc] init];
        item.xAisxTitle = [NSString stringWithFormat:@"第%d级",i];
        item.dataArr = @[
                         @(arc4random() % 27 + 1),
                         @(arc4random() % 27 + 1),
                         ];
        [arr addObject:item];
    }
    
    _chartView.dataArr = arr;
    [self.view addSubview:_chartView];


}


@end
