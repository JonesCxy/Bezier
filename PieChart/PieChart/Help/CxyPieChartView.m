//
//  CxyPieChartView.m
//  PieChart
//
//  Created by 华美赛佳 on 2017/3/24.
//  Copyright © 2017年 JonesCxy. All rights reserved.
//

#import "CxyPieChartView.h"


static CGRect myFrame;

@interface CxyPieChartView ()

@end

@implementation CxyPieChartView

+(instancetype)initWithFrame:(CGRect)frame{

    CxyPieChartView *view = [[NSBundle mainBundle]loadNibNamed:@"CxyPieChartView" owner:self options:nil].lastObject;
    view.frame = frame;
    
    // 北京视图
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    bgView.backgroundColor = XYQColor(255, 229, 239);
    [view addSubview:bgView];
    myFrame = frame;
    
    return view;

}

-(void)drawXYLine:(NSMutableArray *)x_names{

    UIBezierPath *path = [UIBezierPath bezierPath];
    
    // 1.Y轴、X轴的直线
    [path moveToPoint:CGPointMake(MARGIN, CGRectGetHeight(myFrame)-MARGIN)];
    [path addLineToPoint:CGPointMake(MARGIN, MARGIN)];
    
    [path moveToPoint:CGPointMake(MARGIN, CGRectGetHeight(myFrame)-MARGIN)];
    [path addLineToPoint:CGPointMake(MARGIN+CGRectGetWidth(myFrame)-2*MARGIN, CGRectGetHeight(myFrame)-MARGIN)];
    
    // 2.添加箭头
    [path moveToPoint:CGPointMake(MARGIN, MARGIN)];
    [path addLineToPoint:CGPointMake(MARGIN-5, MARGIN+5)];
    [path moveToPoint:CGPointMake(MARGIN, MARGIN)];
    [path addLineToPoint:CGPointMake(MARGIN+5, MARGIN+5)];
    
    
    [path moveToPoint:CGPointMake(MARGIN+CGRectGetWidth(myFrame)-2*MARGIN, CGRectGetHeight(myFrame)-MARGIN)];
    [path addLineToPoint:CGPointMake(MARGIN+CGRectGetWidth(myFrame)-2*MARGIN-5, CGRectGetHeight(myFrame)-MARGIN-5)];
    [path moveToPoint:CGPointMake(MARGIN+CGRectGetWidth(myFrame)-2*MARGIN, CGRectGetHeight(myFrame)-MARGIN)];
    [path addLineToPoint:CGPointMake(MARGIN+CGRectGetWidth(myFrame)-2*MARGIN-5, CGRectGetHeight(myFrame)-MARGIN+5)];
    
    
    // 3.添加索引格
    for (int i = 0; i<x_names.count; i++) {
        
        CGFloat x= MARGIN + MARGIN * (i+1);
        CGPoint point = CGPointMake(x, CGRectGetHeight(myFrame)-MARGIN);
        [path moveToPoint:point];
        [path addLineToPoint:CGPointMake(point.x, point.y - 3)];
    }
    
    
    // Y轴(实际长度为200,此处比例缩小一倍使用)
    for (int i = 0; i<11; i++) {
        
        CGFloat Y = CGRectGetHeight(myFrame)-MARGIN-Y_EVERY_MARGIN*i;
        CGPoint point = CGPointMake(MARGIN, Y);
        [path moveToPoint:point];
        [path addLineToPoint:CGPointMake(point.x+3, point.y)];
    }
    
    // 4.添加索引格文字
    // X轴
    for (int i =0; i<x_names.count; i++) {
        
        CGFloat X = MARGIN + 15 + MARGIN * i;
        UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(X, CGRectGetHeight(myFrame)-MARGIN, MARGIN, 20)];
        
        textLabel.text = x_names[i];
        textLabel.font = [UIFont systemFontOfSize:10];
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.textColor = [UIColor redColor];
        [self addSubview:textLabel];
    }
    
    // Y轴
    for (int i = 0; i<11; i++) {
        CGFloat Y = CGRectGetHeight(myFrame)-MARGIN-Y_EVERY_MARGIN*i;
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, Y-5, MARGIN, 10)];
        textLabel.text = [NSString stringWithFormat:@"%d",10*i];
        textLabel.font = [UIFont systemFontOfSize:10];
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.textColor = [UIColor redColor];
        [self addSubview:textLabel];
    }
    
    // 5.渲染路径
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = path.CGPath;
    shapeLayer.strokeColor = [UIColor blackColor].CGColor;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.borderWidth = 2.0;
    [self.subviews[0].layer addSublayer:shapeLayer];
    
    
}

// 画折线图

-(void)drawLineChartView_Value_Names:(NSMutableArray *)x_names TargetValues:(NSMutableArray *)targetValues LineType:(LineType)lineType{

    // 1.画坐标轴
    [self drawXYLine:x_names];
    
    // 2.获取目标值点坐标
    NSMutableArray *allPoints = [NSMutableArray array];
    for (int i = 0; i<targetValues.count; i++) {
        
        CGFloat doubleValue = 2*[targetValues[i] floatValue];// 目标值放大两倍
        CGFloat X = MARGIN + MARGIN * (i+1);
        CGFloat Y = CGRectGetHeight(myFrame)-MARGIN-doubleValue;
        CGPoint point = CGPointMake(X, Y);
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(point.x-1, point.y-1, 2.5, 2.5) cornerRadius:2.5];
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.strokeColor = [UIColor purpleColor].CGColor;
        layer.fillColor = [UIColor purpleColor].CGColor;
        layer.path = path.CGPath;
        [self.subviews[0].layer addSublayer:layer];
        [allPoints addObject:[NSValue valueWithCGPoint:point]];
        
    }
    
    // 3.坐标连线
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:[allPoints[0]CGPointValue]];
    CGPoint PrePoint;
    switch (lineType) {
        case LineType_Straight: // 直线
            for (int i = 0; i<allPoints.count; i++) {
                CGPoint point = [allPoints[i] CGPointValue];
                [path addLineToPoint:point];
            }
            break;
            case LineType_Curve: // 曲线
            
            for (int i = 0; i<allPoints.count; i++) {
                
                if (i==0) {
                    
                    PrePoint = [allPoints[0] CGPointValue];
                }else{
                
                    CGPoint NowPoint = [allPoints[i] CGPointValue];
                    [path addCurveToPoint:NowPoint controlPoint1:CGPointMake((PrePoint.x+NowPoint.x)/2.0, PrePoint.y) controlPoint2:CGPointMake((PrePoint.x +NowPoint.x)/2, NowPoint.y)]; // 三次曲线
                    PrePoint = NowPoint;
                }
            }
            break;
        default:
            break;
            
    }
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = path.CGPath;
    shapeLayer.strokeColor = [UIColor orangeColor].CGColor;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.borderWidth = 2.0;
    [self.subviews[0].layer addSublayer:shapeLayer];
    
    // 4.添加目标值文字
    for (int i = 0; i<allPoints.count; i++) {
        
        UILabel *label = [[UILabel alloc] init];
        label.textColor = [UIColor purpleColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:10];
        [self.subviews[0] addSubview:label];
        
        if (i==0) {
            CGPoint NowPoint = [allPoints[0] CGPointValue];
            label.text = [NSString stringWithFormat:@"%.0lf",(CGRectGetHeight(myFrame)-NowPoint.y-MARGIN)/2];
            label.frame = CGRectMake(NowPoint.x-MARGIN/2, NowPoint.y-20, MARGIN, 20);
            PrePoint = NowPoint;
        }else{
        
        
            CGPoint NowPoint = [allPoints[i] CGPointValue];
            if (NowPoint.y<PrePoint.y) { // 文字置于上方
                
                label.frame = CGRectMake(NowPoint.x-MARGIN/2, NowPoint.y-20, MARGIN, 20);
            }else{ // 文字置于点下方
            
                label.frame = CGRectMake(NowPoint.x-MARGIN/2, NowPoint.y, MARGIN, 20);
            
            }
            label.text = [NSString stringWithFormat:@"%.01f",(CGRectGetHeight(myFrame)-NowPoint.y-MARGIN)/2];
            PrePoint = NowPoint;
        }
    }
}

-(void)drawBarChartViewWithX_value_Names:(NSMutableArray *)x_names TargetValues:(NSMutableArray *)targetValues{

    // 1.画坐标轴
    [self drawXYLine:x_names];
    // 2.每一个目标值点坐标
    for (int i = 0; i<targetValues.count; i++) {
        CGFloat doubleValue = 2 * [targetValues[i] floatValue];
        CGFloat X = MARGIN + MARGIN*(i+1)+5;
        CGFloat Y = CGRectGetHeight(myFrame)-MARGIN-doubleValue;
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(X-MARGIN/2, Y, MARGIN-10, doubleValue)];
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.path = path.CGPath;
        shapeLayer.strokeColor = [UIColor clearColor].CGColor;
        shapeLayer.fillColor = XYQRandomColor.CGColor;
        shapeLayer.borderWidth = 2.0;
        [self.subviews[0].layer addSublayer:shapeLayer];
        
        // 添加文字
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(X-MARGIN/2, Y-20, MARGIN-10, 20)];
        label.text = [NSString stringWithFormat:@"%.0lf",(CGRectGetHeight(myFrame)-Y-MARGIN)/2];
        label.textColor = [UIColor purpleColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:10];
        [self.subviews[0] addSubview:label];
    }
    
    
}

-(void)drawPieChartViewWithX_Value_Names:(NSMutableArray *)x_names TargetValues:(NSMutableArray *)targetValues{

    CGPoint point = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    CGFloat startAngle = 0;
    CGFloat endAngle;
    CGFloat radius = 100;
    
    // 计算总数
    __block CGFloat allValues = 0;
    [targetValues enumerateObjectsUsingBlock:^(NSNumber *targetNumber, NSUInteger idx, BOOL * _Nonnull stop) {
        
        allValues +=[targetNumber floatValue];
    }];

    // 画图
    for (int i = 0; i<targetValues.count; i++) {
        
        CGFloat targetValue = [targetValues[i] floatValue];
        endAngle = startAngle + targetValue/allValues*2*M_PI;
        
        // bezierPath行程闭合的扇形路径
        UIBezierPath *bezierPath = [UIBezierPath bezierPathWithArcCenter:point
                                                                  radius:radius           startAngle:startAngle endAngle:endAngle
                                                               clockwise:YES];
        [bezierPath addLineToPoint:point];
        [bezierPath closePath];
        
        
        // 添加文字
        CGFloat X = point.x + 120*cos(startAngle+(endAngle-startAngle)/2) - 10;
        CGFloat Y = point.y + 110*sin(startAngle+(endAngle-startAngle)/2) - 10;
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(X, Y, 30, 20)];
        label.text = x_names[i];
        label.font = [UIFont systemFontOfSize:11];
        label.textColor = XYQColor(13, 195, 176);
        [self.subviews[0] addSubview:label];
        
        // 熏染
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.lineWidth = 1;
        shapeLayer.fillColor = XYQRandomColor.CGColor;
        shapeLayer.path = bezierPath.CGPath;
        [self.layer addSublayer:shapeLayer];
        startAngle = endAngle;
        
    }
    
}






@end
