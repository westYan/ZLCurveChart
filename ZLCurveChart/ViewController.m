//
//  ViewController.m
//  ZLCurveChart
//
//  Created by 张亮 on 16/9/22.
//  Copyright © 2016年 张亮. All rights reserved.
//

#import "ViewController.h"
#import "ZLChartView.h"


@interface ViewController ()
@property (nonatomic,strong) ZLChartView *zlChartView;

@property (weak, nonatomic) IBOutlet UISwitch *pliterSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *cubeSwitch;

@property (weak, nonatomic) IBOutlet UISwitch *pointSwitch;

@property (weak, nonatomic) IBOutlet UISwitch *dataSwitch;
@property (weak, nonatomic) IBOutlet UISegmentedControl *lineType;
@property (weak, nonatomic) IBOutlet UISegmentedControl *pointType;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ZLChartView *zlView = [ZLChartView chartViewWithFrame:CGRectMake(10, 60, CGRectGetWidth([UIScreen mainScreen].bounds) - 20, 180)];
    zlView.xValues = @[@1, @2, @3, @4, @5, @6, @7, @8, @9, @10];
    zlView.yValues = @[@35, @5, @80, @40, @50, @13, @50, @75,@25, @100, @64, @95, @33, @100];
    
    _zlChartView = zlView;
    
    [self.view addSubview:_zlChartView];
    
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)segmentValueChange:(id)sender {
    
    [self setUp];
}
- (IBAction)switchValueChange:(id)sender {

    [self setUp];
}

//- (void)createView{
//
//    ZLChartView *zlView = [ZLChartView chartViewWithFrame:CGRectMake(10, 60, CGRectGetWidth([UIScreen mainScreen].bounds) - 20, 180)];
//    zlView.xValues = @[@1, @2, @3, @4, @5, @6, @7, @8, @9, @10];
//    zlView.yValues = @[@35, @5, @80, @40, @50, @13, @50, @75,@25, @100, @64, @95, @33, @100];
//    
//    _zlChartView = zlView;
//     [self.view addSubview:_zlChartView];
//    
//}


-(void)setUp{
    self.zlChartView.isShowCube   = self.cubeSwitch.isOn;
    self.zlChartView.isShowData   = self.dataSwitch.isOn;
    self.zlChartView.isShowPoint  = self.pointSwitch.isOn;
    self.zlChartView.isShowPillar = self.pliterSwitch.isOn;
    
    [self.zlChartView drawChartWithLinestyle:self.lineType.selectedSegmentIndex pointStyle:self.pointType.selectedSegmentIndex];
}

//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}



@end
