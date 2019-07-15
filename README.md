# ATChartView
使用CaLayer创建的柱形图，使用方便，可定制

```
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
    
```
