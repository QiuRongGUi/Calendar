//
//  XFCalendarView.h
//  转载日历 -- Demo
//
//  Created by QIUGUI on 2017/3/29.
//  Copyright © 2017年 QIUGUI. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "XFCalendarTool.h"

@interface XFCalendarView : UIView

@property (nonatomic, strong) NSDate *date;
@property (nonatomic, copy) void(^calendarBlock)(NSInteger day, NSInteger month, NSInteger year);

@property (nonatomic,strong)  NSMutableArray *signArray;

//今天
@property (nonatomic,strong)  UIButton *dayButton;


- (void)setStyle_Today_Signed:(UIButton *)btn;
- (void)setStyle_Today:(UIButton *)btn;




@end
