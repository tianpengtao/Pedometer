//
//  QYPedometerManager.h
//  QYPedometerDemo
//
//  Created by 田 on 16/5/19.
//  Copyright © 2016年 田鹏涛. All rights reserved.
//
/**
 *  计步器管理类
 */

#import "QYPedometerData.h"
#import <UIKit/UIKit.h>
typedef void (^QYPedometerHandler)(QYPedometerData *pedometerData,
                                   NSError *error);

@interface QYPedometerManager : NSObject
+ (QYPedometerManager *)shared;
/**
 *  计步器是否可以使用
 *
 *  @return YES or NO
 */
+ (BOOL)isStepCountingAvailable;
/**
 *  查询某时间段的行走数据
 *
 *  @param start   开始时间
 *  @param end     结束时间
 *  @param handler 查询结果
 */
- (void)queryPedometerDataFromDate:(NSDate *)start
                            toDate:(NSDate *)end
                       withHandler:(QYPedometerHandler)handler;
/**
 *  监听今天（从零点开始）的行走数据
 *
 *  @param handler 查询结果、变化就更新
 */
- (void)startPedometerUpdatesTodayWithHandler:(QYPedometerHandler)handler;
/**
 *  停止监听运动数据
 */
- (void)stopPedometerUpdates;

@end
