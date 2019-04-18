//
//  ViewController.m
//  DateTimeExamples
//
//  Created by 綦帅鹏 on 2019/4/18.
//  Copyright © 2019年 QSP. All rights reserved.
//

#import "ViewController.h"
#import "MainModel.h"
#import "MainTableViewCell.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) MainModel *mainModel;

@end

@implementation ViewController

- (MainModel *)mainModel {
    if (_mainModel == nil) {
        _mainModel = [MainModel modelWithTitle:@"日期和时间编程"];
        
        SectionModel *date = [SectionModel modelWithTitle:@"日期"];
        [date addRowModelWithTitle:@"具有时间间隔的日期对象创建" detail:@"initWithTimeInterval...方法相对于特定时间初始化日期对象，方法名称描述了该特定时间。指定（以秒为单位）希望日期对象在过去或以前多少。要指定早于方法参考日期的日期，请使用负秒数。" selectedAction:^(UIViewController *controller, UITableView *tableView, NSIndexPath *indexPath) {
            NSTimeInterval secondsPerDay = 24*60*60;
            NSDate *tomorrow = [[NSDate alloc] initWithTimeIntervalSinceNow:secondsPerDay];
            NSDate *yestoday = [[NSDate alloc] initWithTimeIntervalSinceNow:-secondsPerDay];
            NSLog(@"\n明天：%f\n昨天：%f", tomorrow.timeIntervalSinceReferenceDate, yestoday.timeIntervalSinceReferenceDate);
            NSLog(@"\n明天：%f\n昨天：%f", tomorrow.timeIntervalSince1970, yestoday.timeIntervalSince1970);
        }];
        [date addRowModelWithTitle:@"调整的日期和时间值来获取新的日期对象" detail:@"NSDate的dateByAddingTimeInterval:实例方法调整的日期和时间值来获取新的日期对象。" selectedAction:^(UIViewController *controller, UITableView *tableView, NSIndexPath *indexPath) {
            NSTimeInterval secondsPerDay = 24*60*60;
            NSDate *today = [[NSDate alloc] init];
            NSDate *tomorrow = [today dateByAddingTimeInterval:secondsPerDay];
            NSDate *yestoday = [today dateByAddingTimeInterval:-secondsPerDay];
            NSLog(@"\n今天：%f\n明天：%f\n昨天：%f", today.timeIntervalSinceReferenceDate, tomorrow.timeIntervalSinceReferenceDate, yestoday.timeIntervalSinceReferenceDate);
            NSLog(@"\n今天：%f\n明天：%f\n昨天：%f", today.timeIntervalSince1970, tomorrow.timeIntervalSince1970, yestoday.timeIntervalSince1970);
        }];
        [date addRowModelWithTitle:@"基本日期计算" detail:@"可以使用isEqualToDate:，compare:，laterDate:，和earlierDate:方法对时间对象进行比较，timeIntervalSinceDate:方法对两个日期对象进行更细小的比较。" selectedAction:^(UIViewController *controller, UITableView *tableView, NSIndexPath *indexPath) {
            NSTimeInterval secondsPerDay = 24*60*60;
            NSDate *today = [[NSDate alloc] init];
            NSDate *tomorrow = [today dateByAddingTimeInterval:secondsPerDay];
            NSDate *yestoday = [today dateByAddingTimeInterval:-secondsPerDay];
            if ([today isEqualToDate:tomorrow]) {
                NSLog(@"今天等于明天。");
            } else {
                NSLog(@"今天不等于明天。");
            }
            switch ([today compare:yestoday]) {
                case NSOrderedAscending:
                    NSLog(@"今天比明天小。");
                    break;
                case NSOrderedSame:
                    NSLog(@"今天等于明天。");
                    break;
                case NSOrderedDescending:
                    NSLog(@"今天比明天大。");
                    break;
                    
                default:
                    break;
            }
            NSDate *earlierDate = [today earlierDate:tomorrow];
            NSDate *laterDate = [today laterDate:tomorrow];
            NSLog(@"\nearlierDate：%f\nlaterDate：%f", earlierDate.timeIntervalSince1970, laterDate.timeIntervalSince1970);
            NSTimeInterval time = [today timeIntervalSinceDate:tomorrow];
            NSLog(@"今天与明天相差%f秒。", time);
        }];
        [_mainModel addSectionModel:date];
    }
    
    return _mainModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.title = self.mainModel.title;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.mainModel sectionCount];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.mainModel rowCountOfSetion:section];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [MainTableViewCell cellWithTableView:tableView indexPath:indexPath model:[self.mainModel rowModelOfIndexPath:indexPath]];
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    SectionModel *model = [self.mainModel sectionModelOfSection:section];
    return model.title;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    RowModel *model = [self.mainModel rowModelOfIndexPath:indexPath];
    if (model.selectedAction) {
        model.selectedAction(self, tableView, indexPath);
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
