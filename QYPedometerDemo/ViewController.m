//
//  ViewController.m
//  QYPedometerDemo
//
//  Created by 田 on 16/5/19.
//  Copyright © 2016年 田鹏涛. All rights reserved.
//

#import "QYPedometerManager.h"
#import "ViewController.h"
@interface ViewController ()
@property(nonatomic, strong) UILabel *stepsLabel;
@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.stepsLabel = [[UILabel alloc]
      initWithFrame:CGRectMake(20, 150,
                               [UIScreen mainScreen].bounds.size.width - 40,
                               200)];
  _stepsLabel.numberOfLines = 5;
  _stepsLabel.backgroundColor = [UIColor redColor];
  _stepsLabel.textColor = [UIColor whiteColor];
  [self.view addSubview:_stepsLabel];
  __weak ViewController *weakSelf = self;

  /*
  NSDate *toDate = [NSDate date];
NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
[dateFormatter setDateFormat:@"yyyy-MM-dd"];
NSDate *fromDate =
[dateFormatter dateFromString:[dateFormatter stringFromDate:toDate]];

[[QYPedometerManager shared]
queryPedometerDataFromDate:fromDate
                    toDate:toDate
               withHandler:^(QYPedometerData *pedometerData,
                             NSError *error) {
                 if (!error) {
                   weakSelf.stepsLabel.text = [NSString
                       stringWithFormat:
                           @" 步数:%@\n 距离:%@\n 爬楼:%@\n 下楼:%@",
                           pedometerData.numberOfSteps,
                           pedometerData.distance,
                           pedometerData.floorsAscended,
                           pedometerData.floorsDescended];
                 }
               }];
  */

  if ([QYPedometerManager isStepCountingAvailable]) {
    [[QYPedometerManager shared]
        startPedometerUpdatesTodayWithHandler:^(QYPedometerData *pedometerData,
                                                NSError *error) {
          if (!error) {
            weakSelf.stepsLabel.text = [NSString
                stringWithFormat:@" 步数:%@\n 距离:%@\n 爬楼:%@\n 下楼:%@",
                                 pedometerData.numberOfSteps,
                                 pedometerData.distance,
                                 pedometerData.floorsAscended,
                                 pedometerData.floorsDescended];
          }
        }];
  } else {
    UIAlertView *alertView = [[UIAlertView alloc]
            initWithTitle:@"此设备不支持记步功能"
                  message:@"仅支持iPhone5s及其以上设备"
                 delegate:self
        cancelButtonTitle:nil
        otherButtonTitles:@"OK", nil];
    [alertView show];
  }
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
