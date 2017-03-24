//
//  CxyPieChartView.h
//  PieChart
//
//  Created by 华美赛佳 on 2017/3/24.
//  Copyright © 2017年 JonesCxy. All rights reserved.
//

#import <UIKit/UIKit.h>

#define MARGIN            30   // 坐标轴与画布间距
#define Y_EVERY_MARGIN    20   // y轴每一个值的间隔数


// 颜色RGB
#define XYQColor(r, g, b)  [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define XYQColorRGBA(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]

// 随机色
#define XYQRandomColor  XYQColor(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))


typedef NS_ENUM(NSInteger,LineType) {

    LineType_Straight, // 折线
    LineType_Curve // 曲线
};




@interface CxyPieChartView : UIView

// 初始化画布

+(instancetype)initWithFrame:(CGRect)frame;



/**
 画折线图

 @param x_names x轴值得所有值名称
 @param targetValues 所有目标值
 @param lineType 直线类型
 */
-(void)drawLineChartView_Value_Names:(NSMutableArray *)x_names TargetValues:(NSMutableArray *)targetValues LineType:(LineType) lineType;



/**
 画柱状图

 @param x_names x轴值得所有值名称
 @param targetValues 所有目标值
 */
-(void)drawBarChartViewWithX_value_Names:(NSMutableArray *)x_names TargetValues:(NSMutableArray *)targetValues;




/**
 画饼状图

 @param x_names x轴值得所有值得名称
 @param targetValues 所有目标值
 */
-(void)drawPieChartViewWithX_Value_Names:(NSMutableArray *)x_names TargetValues:(NSMutableArray *)targetValues;










@end
