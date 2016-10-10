//
//  ZLChartView.h
//  ZLCurveChart
//
//  Created by 张亮 on 16/9/22.
//  Copyright © 2016年 张亮. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, LineStyle){
    LineStyle_straight, // 折线
    LineStyle_curve     // 曲线
};

typedef NS_ENUM(NSInteger,PointStyle){
    PointType_Rect,     // 方点
    PointType_circel    // 圆点
};

@interface ZLChartView : UIView


// 点的X和Y值
@property (nonatomic, copy) NSArray *xValues;
@property (nonatomic, copy) NSArray *yValues;

// 是否显示方点
@property (nonatomic, assign) BOOL isShowCube;

//是否显示圆点
@property (nonatomic, assign) BOOL isShowPoint;

//是否显示柱状图
@property (nonatomic, assign) BOOL isShowPillar;

//是否显示数据
@property (nonatomic, assign) BOOL isShowData;


+ (instancetype)chartViewWithFrame:(CGRect)frame;

- (void)drawChartWithLinestyle:(LineStyle)lineStyle pointStyle:(PointStyle)pointStyle;


@end
