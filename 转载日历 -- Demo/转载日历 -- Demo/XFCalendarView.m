//
//  XFCalendarView.m
//  转载日历 -- Demo
//
//  Created by QIUGUI on 2017/3/29.
//  Copyright © 2017年 QIUGUI. All rights reserved.
//


#import "XFCalendarView.h"
#import "RiButton.h"
@implementation XFCalendarView
{
    UIButton  *_selectButton;
    NSMutableArray *_daysArray;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _daysArray = [NSMutableArray arrayWithCapacity:42];
        for (int i = 0; i < 42; i++) {
            RiButton *button = [[RiButton alloc] init];
            [self addSubview:button];
            [_daysArray addObject:button];
        }
    }
    return self;
}

#pragma mark - create View
- (void)setDate:(NSDate *)date{
    _date = date;
    
    [self createCalendarViewWith:date];
    
}

- (void)createCalendarViewWith:(NSDate *)date{
    
    CGFloat itemW     = self.frame.size.width / 7;
    CGFloat itemH     = self.frame.size.height / 7;
    
    // 1.year month 
    UILabel *headlabel = [[UILabel alloc] init];
    headlabel.text     = [NSString stringWithFormat:@"%li-%li",[XFCalendarTool year:date],[XFCalendarTool month:date]];
    headlabel.font     = [UIFont systemFontOfSize:14];
    headlabel.frame           = CGRectMake(0, 0, self.frame.size.width, itemH);
    headlabel.textAlignment   = NSTextAlignmentCenter;
    [self addSubview:headlabel];
    
    // 2.weekday
    ////1.Sun. 2.Mon. 3.Thes. 4.Wed. 5.Thur. 6.Fri. 7.Sat.
    //    NSArray *array = @[@"Sat", @"Sun", @"Mon", @"Thes", @"Wed", @"Thur", @"Fri"];
    NSArray *array = @[@"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六"];
    
    UIView *weekBg = [[UIView alloc] init];
    weekBg.backgroundColor = [UIColor orangeColor];
    weekBg.frame = CGRectMake(0, CGRectGetMaxY(headlabel.frame), self.frame.size.width, itemH);
    [self addSubview:weekBg];
    
    for (int i = 0; i < 7; i++) {
        UILabel *week = [[UILabel alloc] init];
        week.text     = array[i];
        week.font     = [UIFont systemFontOfSize:14];
        week.frame    = CGRectMake(itemW * i, 0, itemW, 32);
        week.textAlignment   = NSTextAlignmentCenter;
        week.backgroundColor = [UIColor clearColor];
        week.textColor       = [UIColor whiteColor];
        [weekBg addSubview:week];
    }
    
    NSInteger daysInLastMonth = [XFCalendarTool totaldaysInMonth:[XFCalendarTool lastMonth:date]];
    NSInteger daysInThisMonth = [XFCalendarTool totaldaysInMonth:date];
    NSInteger firstWeekday    = [XFCalendarTool firstWeekdayInThisMonth:date];
    
    //    28--31--3
    
    NSLog(@"%ld--%ld--%ld",daysInLastMonth,daysInThisMonth,firstWeekday);
    
    
    //  3.days (1-31)
    for (int i = 0; i < 42; i++) {
        
        int x = (i % 7) * itemW ;
        int y = (i / 7) * itemH + CGRectGetMaxY(weekBg.frame);
        
        RiButton *dayButton = _daysArray[i];
        dayButton.frame = CGRectMake(x, y, itemW, itemH);
        dayButton.contentMode = UIViewContentModeCenter;
        dayButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
        dayButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        dayButton.layer.cornerRadius = 5.0f;
        [dayButton setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        [dayButton addTarget:self action:@selector(logDate:) forControlEvents:UIControlEventTouchUpInside];
        
        
        
        NSInteger day = 0;
        
        
        if (i < firstWeekday) {
            //0 1 2   上个月
            day = daysInLastMonth - firstWeekday + i + 1;
            [self setStyle_BeyondThisMonth:dayButton];
            //            3 + 31  - 1 下个月
        }else if (i > firstWeekday + daysInThisMonth - 1){
            day = i + 1 - firstWeekday - daysInThisMonth;
            [self setStyle_BeyondThisMonth:dayButton];
            
            
            
        }else{
            //            当前月
            day = i - firstWeekday + 1;
            [self setStyle_AfterToday:dayButton];
        }
        
        [dayButton setTitle:[NSString stringWithFormat:@"%li", day] forState:UIControlStateNormal];
        
        // this month
        if ([XFCalendarTool month:date] == [XFCalendarTool month:[NSDate date]]) {
            
            // 29 + 3 - 1
            NSInteger todayIndex = [XFCalendarTool day:date] + firstWeekday - 1;
        
            //            1 -- 31
            if (i < todayIndex && i >= firstWeekday) {
                
                [self setStyle_BeforeToday:dayButton];
                [self setSign:i - (int)firstWeekday + 1 andBtn:dayButton];
                
            }else if(i ==  todayIndex){
                
            [self setStyle_Today:dayButton];
            _dayButton = dayButton;
                
            }
        }
    }
}


#pragma mark 设置已经签到
- (void)setSign:(int)i andBtn:(UIButton*)dayButton{
    [_signArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        int now = i;
        int now2 = [obj intValue];
        if (now2== now) {
            [self setStyle_SignEd:dayButton];
        }
    }];
}


#pragma mark - output date
-(void)logDate:(UIButton *)dayBtn
{
    _selectButton.selected = NO;
    
    dayBtn.selected = YES;
    _selectButton = dayBtn;
    
    NSInteger day = [[dayBtn titleForState:UIControlStateNormal] integerValue];
    
    NSDateComponents *comp = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self.date];
    
    if (self.calendarBlock) {
        self.calendarBlock(day, [comp month], [comp year]);
    }
}


#pragma mark - date button style
//设置不是本月的日期字体颜色   ---白色  看不到
- (void)setStyle_BeyondThisMonth:(UIButton *)btn
{
    btn.enabled = NO;
    [btn setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
}

//这个月 今日之前的日期style
- (void)setStyle_BeforeToday:(UIButton *)btn
{
    btn.enabled = NO;
    [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
}


//今日已签到
- (void)setStyle_Today_Signed:(UIButton *)btn
{
    btn.enabled = NO;
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    //    [btn setBackgroundColor:[UIColor orangeColor]];
    
    
    [btn setBackgroundImage:[UIImage imageNamed:@"3"] forState:UIControlStateNormal];
    
    
}

//今日没签到
- (void)setStyle_Today:(UIButton *)btn
{
    btn.enabled = YES;
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    //    [btn setBackgroundColor:[UIColor grayColor]];
    
    [btn setBackgroundImage:[UIImage imageNamed:@"2"] forState:UIControlStateNormal];
    
}

//这个月 今天之后的日期style
- (void)setStyle_AfterToday:(UIButton *)btn
{
    btn.enabled = NO;
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}


//已经签过的 日期style
- (void)setStyle_SignEd:(UIButton *)btn
{
    btn.enabled = NO;
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    //    [btn setBackgroundColor:[UIColor greenColor]];
    [btn setBackgroundImage:[UIImage imageNamed:@"3"] forState:UIControlStateNormal];
    
}
@end
