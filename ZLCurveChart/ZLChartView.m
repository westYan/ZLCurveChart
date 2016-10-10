//
//  ZLChartView.m
//  ZLCurveChart
//
//  Created by 张亮 on 16/9/22.
//  Copyright © 2016年 张亮. All rights reserved.
//

#import "ZLChartView.h"

static CGRect  myFrame;
static int     count;    // 点个数
static int     yCount;   // Y轴的格数
static CGFloat unitX;    // X轴的格子宽
static CGFloat unitY;    // Y轴的格子高
static CGFloat maxY;     // 最大的Y值
static CGFloat totalH;   // 图表的总高度
static CGFloat totalW;   // 图表的总宽度

#define MARGIN 30

@interface ZLChartView()

@property (weak, nonatomic) IBOutlet UIView *bgView;


@end

@implementation ZLChartView


+ (instancetype)chartViewWithFrame:(CGRect)frame{
    
    
    ZLChartView *chartView = [[NSBundle mainBundle] loadNibNamed:@"zlChartView" owner:self options:nil].lastObject;
    chartView.frame = frame;
    myFrame = frame;

    return chartView;
}


- (void)doWithCalculate{

    int temp = self.xValues.count >= self.yValues.count ? (int)self.yValues.count : (int)self.xValues.count;
   
    
    if (temp) {
        NSMutableArray *arrX = [NSMutableArray array];
        NSMutableArray *arrY = [NSMutableArray array];
        for (int i = 0; i < temp; i ++) {
            [arrX addObject:_xValues[i]];
            [arrY addObject:_yValues[i]];
        }
    }
//   X轴
    count = (int)self.xValues.count;
    unitX = (CGFloat)(CGRectGetWidth(myFrame) - MARGIN * 2) / count;
//    Y轴
    yCount = count <= 5 ? count : 5;  //最多5格;
    unitY = (CGFloat)(CGRectGetHeight(myFrame) - MARGIN * 2) / yCount;
    
    maxY = CGFLOAT_MIN;
    for (int i = 0 ; i < count ; i ++ ) {
        if ([self.yValues[i] floatValue] > maxY) {
            maxY = [self.yValues[i] floatValue];
        }
    }
    
    totalH = CGRectGetHeight(myFrame) - MARGIN * 2;
    totalW = CGRectGetWidth(myFrame) - MARGIN * 2;
}
#pragma mark 画XY轴
- (void)drawXY{
    UIBezierPath *path = [UIBezierPath bezierPath];

    [path moveToPoint:CGPointMake(MARGIN, MARGIN/ 2.0 - 5)];
    [path addLineToPoint:CGPointMake(MARGIN, CGRectGetHeight(myFrame) - MARGIN)];

    [path addLineToPoint:CGPointMake(CGRectGetWidth(myFrame) - MARGIN / 2.0 + 5, CGRectGetHeight(myFrame) - MARGIN)];
//    箭头
//    y轴
    [path moveToPoint:CGPointMake(MARGIN - 5, MARGIN / 2.0 + 4)];
    [path addLineToPoint:CGPointMake(MARGIN, MARGIN / 2.0 - 4)];
    [path addLineToPoint:CGPointMake(MARGIN + 5, MARGIN / 2.0 +4)];
//    x轴
    [path moveToPoint:CGPointMake(CGRectGetWidth(myFrame) - MARGIN / 2.0 -4, CGRectGetHeight(myFrame) - MARGIN - 5)];
    [path addLineToPoint:CGPointMake(CGRectGetWidth(myFrame) - MARGIN / 2.0 + 5 , CGRectGetHeight(myFrame) - MARGIN)];
    [path addLineToPoint:CGPointMake(CGRectGetWidth(myFrame) - MARGIN / 2.0 - 4, CGRectGetHeight(myFrame) - MARGIN + 5)];
    
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    layer.path = path.CGPath;
    layer.strokeColor = [UIColor orangeColor].CGColor;
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.lineWidth = 2.0;
    [self.bgView.layer addSublayer:layer];
}

#pragma mark - 添加label
- (void)drawLabels{
    //Y轴
    for(int i = 0; i <= yCount; i ++){
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, MARGIN  + unitY * i - unitY / 2, MARGIN - 1, unitY)];
        lbl.textColor = [UIColor whiteColor];
        lbl.font = [UIFont systemFontOfSize:12];
        lbl.textAlignment = NSTextAlignmentRight;
        lbl.text = [NSString stringWithFormat:@"%d", (int)(maxY / yCount * (yCount - i)) ];
        
        [self.bgView addSubview:lbl];
    }
    
    // X轴
    for(int i = 1; i <= count; i ++){
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(MARGIN + unitX * i - unitX / 2, CGRectGetHeight(myFrame) - MARGIN, unitX, MARGIN)];
        
        lbl.textColor = [UIColor whiteColor];
        lbl.font = [UIFont systemFontOfSize:12];
        lbl.textAlignment = NSTextAlignmentCenter;
        lbl.text = [NSString stringWithFormat:@"%@", self.xValues[i - 1]];
        
        [self.bgView addSubview:lbl];
    }

}

#pragma mark - 网格

- (void)drawLines{
    UIBezierPath *pathL = [UIBezierPath bezierPath];
//    横向
    for (int i = 0; i < yCount ; i ++ ) {
        [pathL moveToPoint:CGPointMake(MARGIN, MARGIN + unitY * i)];
        [pathL addLineToPoint:CGPointMake(MARGIN + totalW, MARGIN + unitY * i)];
    }
//    纵向
    for (int i = 0 ; i <= count ; i ++ ) {
        [pathL moveToPoint:CGPointMake(MARGIN + unitX * i , MARGIN)];
        [pathL addLineToPoint:CGPointMake(MARGIN + unitX * i , MARGIN + totalH)];
    }
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.path = pathL.CGPath;
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.strokeColor = [UIColor whiteColor].CGColor;
    layer.lineWidth = 0.5;
    [self.bgView.layer addSublayer:layer];
}

#pragma mark - 画点
- (void)drawPointsWithPointStyle:(PointStyle)pointStyle{
    switch (pointStyle) {
        case 0:
            for (int i = 0; i < count; i ++ ) {
            CGPoint point = CGPointMake(MARGIN + unitX * (i + 1) , MARGIN + (1 - [self.yValues[i] floatValue] / maxY ) * totalH);
            CAShapeLayer *layer = [[CAShapeLayer alloc] init];
            layer.frame = CGRectMake(point.x - 2.5, point.y - 2.5, 5, 5);
            layer.backgroundColor = [UIColor redColor].CGColor;
            [self.bgView.layer addSublayer:layer];
            }
            
            break;
            
        case 1:
            for (int i = 0; i < count; i ++) {
                CGPoint point = CGPointMake(MARGIN + unitX * (i + 1) , MARGIN + (1 - [self.yValues[i] floatValue] / maxY ) * totalH);
                
                UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(point.x - 2.5, point.y - 2.5, 5, 5) cornerRadius:2.5];
                
                CAShapeLayer *layer = [CAShapeLayer layer];
                layer.path = path.CGPath;
                layer.strokeColor = [UIColor redColor].CGColor;
                layer.fillColor = [UIColor redColor].CGColor;
                [self.bgView.layer addSublayer:layer];
            }
            break;
            
    }
}

#pragma mark - 柱状图

- (void)drawPillar{
    for (int i = 0 ; i < count ; i ++ ) {
        CGPoint point = CGPointMake(MARGIN + unitX * (i + 1), MARGIN + (1 - [self.yValues[i] floatValue] / maxY) * totalH);
        
        CGFloat width = unitX <= 20 ? 10: 20;
        
        CGRect rect = CGRectMake(point.x - width / 2, point.y, width, (CGRectGetHeight(myFrame) -  MARGIN - point.y));
        
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:rect];
        
        CAShapeLayer *layer = [[CAShapeLayer alloc] init];
        layer.path = path.CGPath;
        layer.strokeColor = [UIColor whiteColor].CGColor;
        layer.fillColor = [UIColor yellowColor].CGColor;
        
        [self.bgView.layer addSublayer:layer];
        
    }
}

#pragma mark - 折线/曲线
- (void)drawLineWithLineStyle:(LineStyle)lineStyle{
    UIBezierPath *path = [UIBezierPath bezierPath];
   [path moveToPoint:CGPointMake(MARGIN + unitX, MARGIN + (1 - [self.yValues.firstObject floatValue] / maxY) * totalH)];
    switch (lineStyle) {
        case 0:
            for (int i = 1; i < count; i ++) {
                [path addLineToPoint:CGPointMake(MARGIN + unitX * (i + 1), MARGIN + (1 - [self.yValues[i] floatValue] / maxY) * totalH)];
            }
            break;
            
        case 1:
            for (int i = 1; i < count; i ++) {
                
                CGPoint prePoint = CGPointMake(MARGIN + unitX * i, MARGIN + (1 - [self.yValues[i-1] floatValue] / maxY) * totalH);
                
                CGPoint nowPoint = CGPointMake(MARGIN + unitX * (i + 1), MARGIN + (1 - [self.yValues[i] floatValue] / maxY) * totalH);
                // 两个控制点的两个x中点为X值，preY、nowY为Y值；
                [path addCurveToPoint:nowPoint controlPoint1:CGPointMake((nowPoint.x+prePoint.x)/2, prePoint.y) controlPoint2:CGPointMake((nowPoint.x+prePoint.x)/2, nowPoint.y)];
            }
            break;
    }
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.path = path.CGPath;
    layer.strokeColor = [UIColor greenColor].CGColor;
    layer.fillColor = [UIColor clearColor].CGColor;
    [self.bgView.layer addSublayer:layer];
}

#pragma mark - 数据显示
- (void)dataLoad{
    for (int i = 0 ; i < count ; i ++) {
        CGPoint nowPoint = CGPointMake(MARGIN + unitX * (i + 1), MARGIN + (1 - [self.yValues[i] floatValue] / maxY) * totalH);
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(nowPoint.x - unitX/2.0-5, nowPoint.y - 20, unitX+10, 20)];
        lbl.textColor = [UIColor grayColor];
        lbl.textAlignment = NSTextAlignmentCenter;
        lbl.text = [NSString stringWithFormat:@"%@",self.yValues[i]];
        lbl.font = [UIFont systemFontOfSize:14];
        lbl.adjustsFontSizeToFitWidth = YES;
        [self.bgView addSubview:lbl];
    }
}


#pragma mark - 综合画图
- (void)drawChartWithLinestyle:(LineStyle)lineStyle pointStyle:(PointStyle)pointStyle{

    [self doWithCalculate];
    
    NSArray *layers = [self.bgView.layer.sublayers mutableCopy];
    for (CAShapeLayer *layer in layers) {
        [layer removeFromSuperlayer];
    }
    
//    画XY轴
    [self drawXY];
//    画折线
    [self drawLineWithLineStyle:lineStyle];
//    文字
    [self drawLabels];
//    画点
    if (_isShowPoint) {
        [self drawPointsWithPointStyle:pointStyle];
    }
//    画柱状图
    if (_isShowPillar) {
        [self drawPillar];
    }
//    画网格
    if (_isShowCube) {
        [self drawLines];
    }
//    数据显示
    if (_isShowData) {
        [self dataLoad];
    }

}

@end
