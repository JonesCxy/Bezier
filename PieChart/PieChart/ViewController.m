//
//  ViewController.m
//  PieChart
//
//  Created by 华美赛佳 on 2017/3/24.
//  Copyright © 2017年 JonesCxy. All rights reserved.
//

#import "ViewController.h"
#import "CxyPieChartView.h"

#define SCREEN_W  [UIScreen mainScreen].bounds.size.width
#define SCREEN_H  [UIScreen mainScreen].bounds.size.height

@interface ViewController ()


@property(strong,nonatomic)CxyPieChartView *bezierView;

@property(strong,nonatomic)NSMutableArray *x_names;

@property(strong,nonatomic)NSMutableArray *targets;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    //1.初始化
    _bezierView = [CxyPieChartView initWithFrame:CGRectMake(30, 30, SCREEN_W-60, 280)];
    _bezierView.center = self.view.center;
    [self.view addSubview:_bezierView];
    
    //2.折线图
    //    [self drawLineChart];
    
    //3.柱状图
        [self drawBaseChart];
    
    //4.饼状图
//    [self drawPieChart];

    
}

//画折线图
-(void)drawLineChart{
    
    //直线
    [_bezierView drawLineChartView_Value_Names:self.x_names TargetValues:self.targets LineType:LineType_Straight];
    
    //曲线
    [_bezierView drawLineChartView_Value_Names:self.x_names TargetValues:self.targets LineType:LineType_Curve];
}


//画柱状图
-(void)drawBaseChart{
    [_bezierView drawBarChartViewWithX_value_Names:self.x_names TargetValues:self.targets];
}


//画饼状图
-(void)drawPieChart{
    [_bezierView drawPieChartViewWithX_Value_Names:self.x_names TargetValues:self.targets];
}


-(NSMutableArray *)x_names{

    if (!_x_names) {
        _x_names = [NSMutableArray arrayWithArray:@[@"语文",@"数学",@"英语",@"物理",@"化学",@"生物",@"政治",@"历史",@"地理"]];
    }
    return _x_names;
}


/**
 *  Y轴值
 */
-(NSMutableArray *)targets{
    if (!_targets) {
        _targets = [NSMutableArray arrayWithArray:@[@20,@40,@20,@50,@30,@90,@30,@100,@70]];
    }
    return _targets;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
