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
@property (strong, nonatomic) NSArray *heavenlyStems;
@property (strong, nonatomic) NSArray *earthlyBranches;
@property (strong, nonatomic) NSArray *years;

@end

@implementation ViewController
- (NSArray *)heavenlyStems {
    if (_heavenlyStems == nil) {
        _heavenlyStems = @[@"甲", @"乙", @"丙", @"丁", @"戊", @"己", @"庚", @"辛", @"壬", @"癸"];
    }
    
    return _heavenlyStems;
}
- (NSArray *)earthlyBranches {
    if (_earthlyBranches == nil) {
        _earthlyBranches = @[@"子", @"丑", @"寅", @"卯", @"辰", @"巳", @"午", @"未", @"申", @"酉", @"戌", @"亥"];
    }
    
    return _earthlyBranches;
}
- (NSArray *)years {
    if (_years == nil) {
        NSMutableArray *mArray = [NSMutableArray arrayWithCapacity:1];
        for (NSInteger i = 0; i < self.heavenlyStems.count; i++) {
            BOOL end = NO;
            for (NSInteger j = 0; j < self.earthlyBranches.count; j++) {
                NSInteger h = (j + self.earthlyBranches.count*i)%self.heavenlyStems.count;
                [mArray addObject:[NSString stringWithFormat:@"%@%@", [self.heavenlyStems objectAtIndex:h], [self.earthlyBranches objectAtIndex:j]]];
                if (h == self.heavenlyStems.count - 1 && j == self.earthlyBranches.count - 1) {
                    end = YES;
                    break;
                }
            }
            if (end) {
                break;
            }
        }
        _years = [NSArray arrayWithArray:mArray];
    }
    
    return _years;
}

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
                    NSLog(@"今天比昨天小。");
                    break;
                case NSOrderedSame:
                    NSLog(@"今天等于昨天。");
                    break;
                case NSOrderedDescending:
                    NSLog(@"今天比昨天大。");
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
        
        SectionModel *calendar = [SectionModel modelWithTitle:@"日历"];
        [calendar addRowModelWithTitle:@"创建日历对象" detail:@"可以使用NSCalendar方法currentCalendar最轻松地获取用户首选区域设置的日历; 可以使用NSLocaleCalendar从任何NSLocale对象获取默认日历。还可以通过指定所需日历的标识符来创建任意日历对象。" selectedAction:^(UIViewController *controller, UITableView *tableView, NSIndexPath *indexPath) {
            NSCalendar *currentCanlendar = [NSCalendar currentCalendar];
            NSCalendar *japaneseCanlendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierJapanese];
            NSCalendar *useCanlendar = [[NSLocale currentLocale] objectForKey:NSLocaleCalendar];
            NSLog(@"currentCanlendar: %@", currentCanlendar);
            NSLog(@"japaneseCanlendar: %@", japaneseCanlendar);
            NSLog(@"useCanlendar: %@", useCanlendar);
        }];
        [calendar addRowModelWithTitle:@"创建日期组件对象" detail:@"NSDateComponents对象表示日期的组成元素。" selectedAction:^(UIViewController *controller, UITableView *tableView, NSIndexPath *indexPath) {
            NSDateComponents *components = [[NSDateComponents alloc] init];
            [components setDay:18];
            [components setMonth:4];
            [components setYear:2019];
            NSLog(@"weekday: %zi", components.weekday);
        }];
        [calendar addRowModelWithTitle:@"获取日期的组件" detail:@"将日期分解为组成组件，使用NSCalendar的components:fromDate:方法。除了日期本身，还需要指定要在NSDateComponents对象中返回的组件。" selectedAction:^(UIViewController *controller, UITableView *tableView, NSIndexPath *indexPath) {
            NSDate *today = [NSDate date];
            NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierChinese];
            NSLog(@"local: %@", calendar.calendarIdentifier);
            NSDateComponents *components = [calendar components:NSCalendarUnitDay|NSCalendarUnitMonth|NSCalendarUnitYear fromDate:today];
            NSLog(@"今天是%@年%zi月%zi日", [self.years objectAtIndex:components.year - 1], components.month, components.day);
        }];
        [calendar addRowModelWithTitle:@"从组件创建日期" detail:@"配置NSDateComponents实例以指定日期的组件，然后使用NSCalendar的dateFromComponents:方法创建相应的日期对象。" selectedAction:^(UIViewController *controller, UITableView *tableView, NSIndexPath *indexPath) {
            NSDateComponents *components = [[NSDateComponents alloc] init];
            [components setWeekday:1];
            [components setWeekdayOrdinal:1];
            [components setMonth:4];
            [components setYear:2019];
            NSCalendar *calendar = [NSCalendar currentCalendar];
            NSDate *date = [calendar dateFromComponents:components];
            NSDateComponents *endComponents = [calendar components:NSCalendarUnitDay|NSCalendarUnitMonth|NSCalendarUnitYear fromDate:date];
            NSLog(@"2019年4月的第一个星期一是%zi年%zi月%zi日", endComponents.year, endComponents.month, endComponents.day);
        }];
        [calendar addRowModelWithTitle:@"创建无年代日期" detail:@"为了保证正确的行为，必须确保使用的组件对日历有意义。" selectedAction:^(UIViewController *controller, UITableView *tableView, NSIndexPath *indexPath) {
            NSDateComponents *components = [[NSDateComponents alloc] init];
            [components setDay:22];
            [components setMonth:4];
            NSCalendar *calendar = [NSCalendar currentCalendar];
            NSDate *birthday = [calendar dateFromComponents:components];
            NSDateComponents *endComponents = [calendar components:NSCalendarUnitDay|NSCalendarUnitMonth|NSCalendarUnitYear fromDate:birthday];
            NSLog(@"生日是%zi年%zi月%zi日", endComponents.year, endComponents.month, endComponents.day);
        }];
        [calendar addRowModelWithTitle:@"将日期组件从一个日历转换为另一个日历" detail:@"要将日期的组件从一个日历转换为另一个日历，首先使用第一个日历从组件创建日期对象，然后使用第二个日历将日期分解为组件。" selectedAction:^(UIViewController *controller, UITableView *tableView, NSIndexPath *indexPath) {
            NSDateComponents *components = [[NSDateComponents alloc] init];
            [components setDay:19];
            [components setMonth:4];
            [components setYear:2019];
            NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
            NSDate *date = [calendar dateFromComponents:components];
            NSCalendar *endCalendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierChinese];
            NSDateComponents *endComponents = [endCalendar components:NSCalendarUnitDay|NSCalendarUnitMonth|NSCalendarUnitYear fromDate:date];
            NSLog(@"公历%zi年%zi月%zi日是农历%@年%zi月%zi日", components.year, components.month, components.day, [self.years objectAtIndex:endComponents.year - 1], endComponents.month, endComponents.day);
        }];
        [_mainModel addSectionModel:calendar];
        
        SectionModel *calculation = [SectionModel modelWithTitle:@"日历计算"];
        [calculation addRowModelWithTitle:@"计算未来一个半小时的日期" detail:@"可以使用dateByAddingComponents:toDate:options:方法将日期的组件添加到现有日期。" selectedAction:^(UIViewController *controller, UITableView *tableView, NSIndexPath *indexPath) {
            NSDate *today = [[NSDate alloc] init];
            NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
            NSDateComponents *components = [[NSDateComponents alloc] init];
            [components setHour:1];
            [components setMinute:30];
            NSDate *war3 = [calendar dateByAddingComponents:components toDate:today options:NSCalendarWrapComponents];
            NSDateComponents *war3C = [calendar components:NSCalendarUnitDay|NSCalendarUnitMonth|NSCalendarUnitYear|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond fromDate:war3];
            NSLog(@"%zi年%zi月%zi日%zi时%zi分%zi秒", war3C.year, war3C.month, war3C.day, war3C.hour, war3C.minute, war3C.second);
        }];
        [calculation addRowModelWithTitle:@"计算当周的星期日" detail:@"添加的组件可能是负的" selectedAction:^(UIViewController *controller, UITableView *tableView, NSIndexPath *indexPath) {
            NSDate *date = [[NSDate alloc] init];
            NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
            NSDateComponents *componentes = [calendar components:NSCalendarUnitWeekday fromDate:date];
            NSDateComponents *subComponentes = [[NSDateComponents alloc] init];
            [subComponentes setWeekday:1 - componentes.weekday];
            NSDate *beginWeek = [calendar dateByAddingComponents:subComponentes toDate:date options:NSCalendarWrapComponents];
            NSDateComponents *endComponentes = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:beginWeek];
            NSLog(@"本周的星期日是%zi年%zi月%zi日", endComponentes.year, endComponentes.month, endComponentes.day);
        }];
        [calculation addRowModelWithTitle:@"计算本周的开始时间" detail:@"不是所有日历中星期日都是一周的开始。" selectedAction:^(UIViewController *controller, UITableView *tableView, NSIndexPath *indexPath) {
            NSDate *date = [[NSDate alloc] init];
            NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
            NSDate *benginDate = nil;
            BOOL ok = [calendar rangeOfUnit:NSCalendarUnitWeekOfMonth startDate:&benginDate interval:NULL forDate:date];
            if (ok) {
                NSDateComponents *endComponentes = [calendar components:NSCalendarUnitDay|NSCalendarUnitMonth|NSCalendarUnitYear|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond fromDate:benginDate];
                NSLog(@"本周的开始时间是%zi年%zi月%zi日%zi时%zi分%zi秒", endComponentes.year, endComponentes.month, endComponentes.day, endComponentes.hour, endComponentes.minute, endComponentes.second);
            } else {
                NSLog(@"出错");
            }
        }];
        [calculation addRowModelWithTitle:@"计算两个日期之间的差异" detail:@"使用components:fromDate:toDate:options:确定两个日期在单元单位之间的时间差异。" selectedAction:^(UIViewController *controller, UITableView *tableView, NSIndexPath *indexPath) {
            NSDate *begin = [[NSDate alloc] init];
            NSDate *end = [NSDate dateWithTimeIntervalSince1970:0];
            NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
            NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:end toDate:begin options:NSCalendarWrapComponents];
            NSLog(@"%zi年%zi月%zi日", components.year, components.month, components.day);
        }];
        [calculation addRowModelWithTitle:@"计算两个日期之间的天数" detail:@"由两个日期之间的午夜数来计算。" selectedAction:^(UIViewController *controller, UITableView *tableView, NSIndexPath *indexPath) {
            NSDate *begin = [NSDate dateWithTimeIntervalSince1970:0];
            NSDate *end = [[NSDate alloc] init];
            NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
            NSInteger beginDay = [calendar ordinalityOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitEra forDate:begin];
            NSInteger endDay = [calendar ordinalityOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitEra forDate:end];
            NSDateComponents *beginComponents = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:begin];
            NSDateComponents *endComponents = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:end];
            NSLog(@"%zi年%zi月%zi日到%zi年%zi月%zi日一个过了%zi天", beginComponents.year, beginComponents.month, beginComponents.day, endComponents.year, endComponents.month, endComponents.day, endDay - beginDay);
        }];
        [calculation addRowModelWithTitle:@"计算不同世纪的两个日期之间的天数" detail:@"从给定日期创建组件，然后标准化时间并比较两个日期。" selectedAction:^(UIViewController *controller, UITableView *tableView, NSIndexPath *indexPath) {
            NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
            NSDate *begin = [NSDate dateWithTimeIntervalSince1970:-60*60*24*365*100.0];
            NSDate *end = [[NSDate alloc] init];
            NSCalendarUnit flags = NSCalendarUnitEra|NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay;
            NSDateComponents *beginComponents = [calendar components:flags fromDate:begin];
            NSDateComponents *endComponents = [calendar components:flags fromDate:end];
            beginComponents.hour = 12;
            endComponents.hour = 12;
            NSDateComponents *subComponents = [calendar components:NSCalendarUnitDay fromDate:[calendar dateFromComponents:beginComponents] toDate:[calendar dateFromComponents:endComponents] options:0];
            NSLog(@"%zi年%zi月%zi日到%zi年%zi月%zi日一个过了%zi天", beginComponents.year, beginComponents.month, beginComponents.day, endComponents.year, endComponents.month, endComponents.day, subComponents.day);
        }];
        [calculation addRowModelWithTitle:@"计算日期是否为本周" detail:@"需要确定日期是否属于当前周（或任何单位），可以使用该NSCalendar的rangeOfUnit:startDate:interval:forDate:方法。" selectedAction:^(UIViewController *controller, UITableView *tableView, NSIndexPath *indexPath) {
            NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
            NSDate *date = [NSDate dateWithTimeIntervalSinceNow:60*60*24*2];
            NSDate *current = [NSDate date];
            NSDate *beginDate = nil;
            NSTimeInterval extends = 0;
            BOOL success = [calendar rangeOfUnit:NSCalendarUnitWeekOfMonth startDate:&beginDate interval:&extends forDate:current];
            NSTimeInterval beginSec = [beginDate timeIntervalSinceReferenceDate];
            NSTimeInterval dateSec = [date timeIntervalSinceReferenceDate];
            NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:date];
            if (success && dateSec > beginSec && dateSec < beginSec + extends) {
                NSLog(@"%zi年%zi月%zi日在本周", components.year, components.month, components.day);
            } else {
                NSLog(@"%zi年%zi月%zi日不在本周", components.year, components.month, components.day);
            }
        }];
        
        [_mainModel addSectionModel:calculation];SectionModel *timezone = [SectionModel modelWithTitle:@"日历计算"];
        [timezone addRowModelWithTitle:@"系统已知的时区名称的完整列表" detail:@"使用knownTimeZoneNames类方法查看系统已知的时区名称的完整列表。" selectedAction:^(UIViewController *controller, UITableView *tableView, NSIndexPath *indexPath) {
            NSLog(@"%@", [NSTimeZone knownTimeZoneNames]);
        }];
        [timezone addRowModelWithTitle:@"使用特定时区从组件创建日期" detail:@"创建独立于时区的日期，则可以将日期存储为NSDateComponents对象。" selectedAction:^(UIViewController *controller, UITableView *tableView, NSIndexPath *indexPath) {
            NSTimeZone *timezone = [NSTimeZone timeZoneWithAbbreviation:@"CDT"];
            NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
            [calendar setTimeZone:timezone];
            NSDateComponents *components = [[NSDateComponents alloc] init];
            components.year = 2019;
            components.month = 4;
            components.day = 26;
            NSDate *date = [calendar dateFromComponents:components];
            NSLog(@"%@", date);
        }];
        [_mainModel addSectionModel:timezone];
        
        [_mainModel addSectionModel:calculation];SectionModel *historical = [SectionModel modelWithTitle:@"历史日期"];
        [historical addRowModelWithTitle:@"负年份来表示公元前日期" detail:@"创建年份为0的日期，则为公元前1年。此外，如果使用负年份值从组件创建日期，则使用天文年编号创建日期，其中0对应于元前1年，-1对应于元前2年，依此类推。" selectedAction:^(UIViewController *controller, UITableView *tableView, NSIndexPath *indexPath) {
            NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
            NSDateComponents *bceComponents = [[NSDateComponents alloc] init];
            bceComponents.era = 0;
            bceComponents.year = 8;
            bceComponents.month = 5;
            bceComponents.day = 7;
            
            NSDateComponents *otherComponents = [[NSDateComponents alloc] init];
            otherComponents.year = -7;
            otherComponents.month = 5;
            otherComponents.day = 7;
            
            NSDate *bceDate = [calendar dateFromComponents:bceComponents];
            NSDate *otherDate = [calendar dateFromComponents:otherComponents];
            NSLog(@"bce: %f, other: %f", [bceDate timeIntervalSinceReferenceDate], [otherDate timeIntervalSinceReferenceDate]);
        }];
        [historical addRowModelWithTitle:@"公元前7年12月31日的明天是哪天" detail:@"创建独立于时区的日期，则可以将日期存储为NSDateComponents对象。" selectedAction:^(UIViewController *controller, UITableView *tableView, NSIndexPath *indexPath) {
            NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
            NSDateComponents *bceComponents = [[NSDateComponents alloc] init];
            bceComponents.era = 0;
            bceComponents.year = 1;
            bceComponents.month = 12;
            bceComponents.day = 31;
            NSDate *date = [calendar dateFromComponents:bceComponents];
            NSDate *resultDate = [calendar dateByAddingUnit:NSCalendarUnitDay value:1 toDate:date options:0];
            NSDateComponents *resultComponents = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:resultDate];
            NSLog(@"%zi年%zi月%zi日", resultComponents.year, resultComponents.month, resultComponents.day);
        }];
        [_mainModel addSectionModel:historical];
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
