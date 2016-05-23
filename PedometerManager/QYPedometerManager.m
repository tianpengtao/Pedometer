//
//  QYPedometerManager.m
//  QYPedometerDemo
//
//  Created by 田 on 16/5/19.
//  Copyright © 2016年 田鹏涛. All rights reserved.
//

#import "QYPedometerManager.h"
#import <CoreMotion/CoreMotion.h>

@interface QYPedometerManager ()
@property(nonatomic, strong) CMStepCounter *stepCounter;
@property(nonatomic, strong) CMPedometer *pedometer;
@property(nonatomic, strong) NSOperationQueue *operationQueue;

@end
@implementation QYPedometerManager
+ (QYPedometerManager *)shared {
  static dispatch_once_t pred;
  static QYPedometerManager *sharedInstance = nil;

  dispatch_once(&pred, ^{
    sharedInstance = [[self alloc] init];
  });

  return sharedInstance;
}
- (instancetype)init {
  self = [super init];
  if (self) {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0
    if ([CMPedometer isStepCountingAvailable]) {
      self.pedometer = [[CMPedometer alloc] init];
    }
#else
    if ([CMStepCounter isStepCountingAvailable]) {
      self.stepCounter = [[CMStepCounter alloc] init];
      self.operationQueue = [[NSOperationQueue alloc] init];
    }
#endif
  }
  return self;
}
/**
 *  查询某时间段的运动数据
 *
 *  @param start   开始时间
 *  @param end     结束时间
 *  @param handler 查询结果
 */
- (void)queryPedometerDataFromDate:(NSDate *)start
                            toDate:(NSDate *)end
                       withHandler:(QYPedometerHandler)handler {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0

  [_pedometer
      queryPedometerDataFromDate:start
                          toDate:end
                     withHandler:^(CMPedometerData *_Nullable pedometerData,
                                   NSError *_Nullable error) {
                       dispatch_async(dispatch_get_main_queue(), ^{
                         QYPedometerData *customPedometerData =
                             [[QYPedometerData alloc] init];
                         customPedometerData.numberOfSteps =
                             pedometerData.numberOfSteps;
                         customPedometerData.distance = pedometerData.distance;
                         customPedometerData.floorsAscended =
                             pedometerData.floorsAscended;
                         customPedometerData.floorsDescended =
                             pedometerData.floorsDescended;

                         handler(customPedometerData, error);
                       });
                     }];
#else
  [_stepCounter queryStepCountStartingFrom:start
                                        to:end
                                   toQueue:_operationQueue
                               withHandler:^(NSInteger numberOfSteps,
                                             NSError *__nullable error) {
                                 dispatch_async(dispatch_get_main_queue(), ^{
                                   QYPedometerData *pedometerData =
                                       [[QYPedometerData alloc] init];
                                   pedometerData.numberOfSteps =
                                       @(numberOfSteps);
                                   handler(pedometerData, error);
                                 });
                               }];

#endif
}
/**
 *  监听今天（从零点开始）的行走数据
 *
 *  @param handler 查询结果、变化就更新
 */
- (void)startPedometerUpdatesTodayWithHandler:(QYPedometerHandler)handler;
{

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0
  NSDate *toDate = [NSDate date];
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setDateFormat:@"yyyy-MM-dd"];
  NSDate *fromDate =
      [dateFormatter dateFromString:[dateFormatter stringFromDate:toDate]];
  [_pedometer
      startPedometerUpdatesFromDate:fromDate
                        withHandler:^(CMPedometerData *_Nullable pedometerData,
                                      NSError *_Nullable error) {
                          dispatch_async(dispatch_get_main_queue(), ^{
                            QYPedometerData *customPedometerData =
                                [[QYPedometerData alloc] init];
                            customPedometerData.numberOfSteps =
                                pedometerData.numberOfSteps;
                            customPedometerData.distance =
                                pedometerData.distance;
                            customPedometerData.floorsAscended =
                                pedometerData.floorsAscended;
                            customPedometerData.floorsDescended =
                                pedometerData.floorsDescended;
                            handler(customPedometerData, error);
                          });
                        }];
#else
  [_stepCounter startStepCountingUpdatesToQueue:_operationQueue
                                       updateOn:10
                                    withHandler:^(NSInteger numberOfSteps,
                                                  NSDate *_Nonnull timestamp,
                                                  NSError *_Nullable error) {
                                      QYPedometerData *pedometerData =
                                          [[QYPedometerData alloc] init];
                                      pedometerData.numberOfSteps =
                                          @(numberOfSteps);
                                      handler(pedometerData, error);
                                    }];

#endif
}
/**
 *  停止监听运动数据
 */
- (void)stopPedometerUpdates {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0
  [_pedometer stopPedometerUpdates];
#else
  [_stepCounter stopStepCountingUpdates];
#endif
}
/**
 *  计步器是否可以使用
 *
 *  @return YES or NO
 */
+ (BOOL)isStepCountingAvailable {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0
  return [CMPedometer isStepCountingAvailable];
#else
  return [CMStepCounter isStepCountingAvailable];
#endif
}
@end
