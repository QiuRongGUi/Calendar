//
//  ViewController.m
//  转载日历 -- Demo
//
//  Created by QIUGUI on 2017/3/29.
//  Copyright © 2017年 QIUGUI. All rights reserved.
//

#import "ViewController.h"

#import "XFCalendarView.h"

#import "FMDB.h"

@interface ViewController ()

@property (nonatomic ,strong ) XFCalendarView *calendarView;

@property(nonatomic,strong) FMDatabase  *db;

@end

@implementation ViewController





- (void)viewDidLoad {
    
    
    [super viewDidLoad];
    //    
    CGSize size = [UIScreen mainScreen].bounds.size;
    
    _calendarView = [[XFCalendarView alloc] init];
    _calendarView.frame = CGRectMake(10, 30, size.width-20, 200);
    [self.view addSubview:_calendarView];
    
    //设置已经签到的天数日期
    
    NSMutableArray* _signArray = [[NSMutableArray alloc] init];
    [_signArray addObject:[NSNumber numberWithInt:1]];
    [_signArray addObject:[NSNumber numberWithInt:5]];
    [_signArray addObject:[NSNumber numberWithInt:9]];
    [_signArray addObject:[NSNumber numberWithInt:13]];
    [_signArray addObject:[NSNumber numberWithInt:15]];
    
    _calendarView.signArray = _signArray;
    
    //    [self FMDB];
    //    
    //    [self addData];
    
    
    _calendarView.date = [NSDate date];
    
    
    NSDateComponents *comp = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:[NSDate date]];
    
    
    //    __weak typeof ViewController *view = FMDBSelf;
    
    __weak typeof(*& self) weakSelf = self;
    
    //日期点击事件
    __weak typeof(XFCalendarView) *weakDemo = _calendarView;
    
    _calendarView.calendarBlock =  ^(NSInteger day, NSInteger month, NSInteger year){
        if ([comp day]==day) {
            //            NSLog(@"%li-%li-%li", year,month,day);
            
            NSLog(@"%li",day);
            
            
            //sql插入语句的拼接
            NSString *resultStr = [NSString stringWithFormat:@"INSERT INTO t_test1 (AGE) VALUES(%zd) ",day];
            
            //执行sql插入语句(调用FMDB对象方法)
            BOOL success = [weakSelf.db executeUpdate:resultStr];
            //判断是否添加成功
            if (success) {
                NSLog(@"添加数据成功!");
            }else{
                NSLog(@"添加数据失败!");
            }
            
            //根据自己逻辑条件 设置今日已经签到的style 没有签到不需要写
            [weakDemo setStyle_Today_Signed:weakDemo.dayButton];
            
        }
    };
    
    
    
    
    
    
}


- (void)addData{
    
    
    NSMutableArray *data = [NSMutableArray array];
    
    //查询语句
    //    NSString *sqlStr = @"SELECT NAME,AGE FROM t_test WHERE AGE = 23;";
    NSString *sqlStr = @"SELECT * FROM t_test1;";
    
    
    //执行sql查询语句(调用FMDB对象方法)
    FMResultSet *set =  [self.db executeQuery:sqlStr];
    
    while ([set next]) { //等价于 == sqlite_Row
        
        
        
        int age = [set intForColumn:@"AGE"];
        
        [data addObject:[NSString stringWithFormat:@"%d",age]];
        
        //        [_calendarView.signArray addObject:[NSString stringWithFormat:@"%d",age]];
        
        
        NSLog(@"AGE = %ld",(long)age);
    }
    
    
    _calendarView.signArray = data;
    
    
    
    
}

- (void)FMDB{
    
    //创建数据库路径
    NSString *path  = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject]stringByAppendingPathComponent:@"new1.db"];
    FMDatabase *db = [FMDatabase databaseWithPath:path];
    self.db = db;
    BOOL success = [db open];
    if (success) { //打开成功
        NSLog(@"数据库打开成功!");
        //        
        //        创建表  执行一条sql语句  增删改 都是这样的  查询比较特殊
        
        NSString *sqlStr = @"CREATE TABLE IF NOT EXISTS t_test1 (ID INTEGER PRIMARY KEY AUTOINCREMENT ,AGE INTEGER );";
        BOOL successT = [self.db executeUpdate:sqlStr];
        
        if (successT) {
            NSLog(@"创建表成功!");
        }else{
            NSLog(@"创建表失败!");
        }
        
        
    }else{
        NSLog(@"数据库打开失败!");
    }
    
    NSLog(@"%@",NSHomeDirectory());
    
    //关闭数据库
    //sqlite3_close(_db);
    [_db open];
    
    
    
}
- (IBAction)clike:(id)sender {
    
    //往表中循环插入100条数据
    for (int i = 7; i < 16 ; i++) {
        
        //sql插入语句的拼接
        NSString *resultStr = [NSString stringWithFormat:@"INSERT INTO t_test1 (AGE) VALUES(%zd) ",i];
        
        //执行sql插入语句(调用FMDB对象方法)
        BOOL success = [self.db executeUpdate:resultStr];
        //判断是否添加成功
        if (success) {
            NSLog(@"添加数据成功!");
        }else{
            NSLog(@"添加数据失败!");
        }
        
    }
    
}
- (IBAction)ins:(id)sender {
    
}



@end
