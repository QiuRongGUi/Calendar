//
//  XFCalendarTool.m
//  转载日历 -- Demo
//
//  Created by QIUGUI on 2017/3/29.
//  Copyright © 2017年 QIUGUI. All rights reserved.
//

#import "XFCalendarTool.h"

@implementation XFCalendarTool



/**
 
 @param date 当前 几号
 @return <#return value description#>
 */
+ (NSInteger)day:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitDay) fromDate:date];
    return [components day];
}


/**
 当前 月
 
 @param date <#date description#>
 @return <#return value description#>
 */
+ (NSInteger)month:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitMonth) fromDate:date];
    return [components month];
}
/**
 当前 年
 
 @param date <#date description#>
 @return <#return value description#>
 */
+ (NSInteger)year:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear) fromDate:date];
    return [components year];
}


/**
 当前时间 当前月 1号 是 weak 
 
 @param date <#date description#>
 @return <#return value description#>
 */
+ (NSInteger)firstWeekdayInThisMonth:(NSDate *)date{
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setFirstWeekday:1];
    NSDateComponents *comp = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    [comp setDay:1];
    NSDate *firstDayOfMonthDate = [calendar dateFromComponents:comp];
    NSUInteger firstWeekday = [calendar ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitWeekOfMonth forDate:firstDayOfMonthDate];
    return firstWeekday - 1;
}


/**
 当前月 天数
 
 @param date 31-
 @return <#return value description#>
 */
+ (NSInteger)totaldaysInMonth:(NSDate *)date{
    NSRange daysInOfMonth = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    return daysInOfMonth.length;
}

/**
 上个月 
 
 @param date 2017-02-28 14:29:50 +0000--
 @return <#return value description#>
 */
+ (NSDate *)lastMonth:(NSDate *)date{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = -1;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
    return newDate;
}


/**
 下个月 
 
 @param date 2017-04-29 14:29:50 +0000--
 @return <#return value description#>
 */
+ (NSDate*)nextMonth:(NSDate *)date{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = +1;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
    return newDate;
}



























@end
