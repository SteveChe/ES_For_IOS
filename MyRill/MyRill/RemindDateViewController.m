//
//  RemindDateViewController.m
//  MyRill
//
//  Created by Siyuan Wang on 15/8/9.
//
//

#import "RemindDateViewController.h"
#import "RemindDateTableViewCell.h"
#import "ZCActionOnCalendar.h"

@interface RemindDateViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *popOverView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) NSIndexPath *lastIndexPath;

@end

@implementation RemindDateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UINib *nib = [UINib nibWithNibName:@"RemindDateTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"RemindDateTableViewCell"];
    self.lastIndexPath = nil;
}

#pragma mark - UITableViewDataSource&UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    RemindDateTableViewCell *cell = (RemindDateTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    if ([self.lastIndexPath isEqual:indexPath]) {
        cell.isCheck = !cell.isCheck;
    } else {
        cell.isCheck = YES;
        if (self.lastIndexPath != nil) {
            RemindDateTableViewCell *lastCell = (RemindDateTableViewCell *)[tableView cellForRowAtIndexPath:self.lastIndexPath];
            lastCell.isCheck = !cell.isCheck;
        }
    }
    
    self.lastIndexPath = indexPath;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RemindDateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RemindDateTableViewCell" forIndexPath:indexPath];
    
    cell.remindTime = self.dataSource[indexPath.row];
    
    return cell;
}

#pragma mark - response events
- (IBAction)dismissSelf:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)confirmSelf:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        NSString *alarmInteral = self.dataSource[self.lastIndexPath.row];
        NSDate *date = [NSDate date];
        
        //设置事件之前多长时候开始提醒
        double alarm = 0;
        if ([alarmInteral isEqualToString:@"15分钟"]) {
            alarm = 15 * 60;
        } else if ([alarmInteral isEqualToString:@"30分钟"]) {
            alarm = 30 * 60;
        } else if ([alarmInteral isEqualToString:@"1小时"]) {
            alarm = 60 * 60;
        } else if ([alarmInteral isEqualToString:@"1天"]) {
            alarm = 24 * 60 * 60;
        } else if ([alarmInteral isEqualToString:@"1周"]) {
            alarm = 7 * 24 * 60 * 60;
        } else if ([alarmInteral isEqualToString:@"1天"]) {
            alarm = 30 * 24 * 60 * 60;
        } else {
            
        }
        
        date = [date dateByAddingTimeInterval:alarm];
        
        //isReminder 是否写入提醒事项
        [ZCActionOnCalendar saveEventStartDate:date
                                       endDate:date
                                         alarm:0
                                    eventTitle:self.taskTitle
                                      location:self.taskDescriptsion
                                    isReminder:YES];
    }];
}


#pragma mark - setters&getters
-(void)setPopOverView:(UIView *)popOverView {
    _popOverView = popOverView;
    
    _popOverView.layer.cornerRadius = 6.f;
    [_popOverView removeGestureRecognizer:[[_popOverView gestureRecognizers] lastObject]];
}

- (NSArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [[NSArray alloc] initWithObjects:@"15分钟", @"30分钟", @"1小时", @"1天", @"1周", @"1月", nil];
    }
    
    return _dataSource;
}

@end
