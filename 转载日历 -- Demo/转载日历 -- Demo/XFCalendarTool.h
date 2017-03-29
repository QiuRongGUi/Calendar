//
//  XFCalendarTool.h
//  转载日历 -- Demo
//
//  Created by QIUGUI on 2017/3/29.
//  Copyright © 2017年 QIUGUI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XFCalendarTool : NSObject



+ (NSInteger)day:(NSDate *)date;
+ (NSInteger)month:(NSDate *)date;
+ (NSInteger)year:(NSDate *)date;

+ (NSInteger)firstWeekdayInThisMonth:(NSDate *)date;
+ (NSInteger)totaldaysInMonth:(NSDate *)date;

+ (NSDate *)lastMonth:(NSDate *)date;
+ (NSDate*)nextMonth:(NSDate *)date;


@end
