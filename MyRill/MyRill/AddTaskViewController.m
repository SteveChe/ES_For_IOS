//
//  AddTaskViewController.m
//  MyRill
//
//  Created by Siyuan Wang on 15/8/7.
//
//

#import "AddTaskViewController.h"
#import "ColorHandler.h"
#import "AddTaskDataParse.h"
#import "ESTask.h"
#import "ESContactor.h"
#import "Masonry.h"

@interface AddTaskViewController () <AddTaskDelegate>

@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *holdViews;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *txtHoldViews;

@property (weak, nonatomic) IBOutlet UITextField *TaskTitleTxtfield;
@property (weak, nonatomic) IBOutlet UITextField *taskTitleLbl;
@property (weak, nonatomic) IBOutlet UITextView *taskDescriptionTxtView;
@property (weak, nonatomic) IBOutlet UILabel *endDateLbl;
@property (nonatomic, strong) UIDatePicker *dateSelectedPicker;

@property (nonatomic, strong) AddTaskDataParse *addTaskDataDP;

@end

@implementation AddTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"新增任务";
    
    UIBarButtonItem *confirmItem = [[UIBarButtonItem alloc] initWithTitle:@"确定"
                                                                    style:UIBarButtonItemStyleDone
                                                                   target:self
                                                                   action:@selector(confirmItemOnClicked)];
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithTitle:@"取消"
                                                                   style:UIBarButtonItemStyleDone
                                                                  target:self
                                                                  action:@selector(cancelItemOnClicked)];
    self.navigationItem.rightBarButtonItem = confirmItem;
    self.navigationItem.leftBarButtonItem = cancelItem;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    [self.view addSubview:self.dateSelectedPicker];
    
    __weak UIView *ws = self.view;
    [self.dateSelectedPicker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(ws.mas_leading);
        make.trailing.equalTo(ws.mas_trailing);
        make.bottom.equalTo(ws.mas_bottom).with.offset(216);
        make.height.equalTo(@216);
    }];
    
    [self.view layoutIfNeeded];
}

#pragma mark - AddTaskDelegate method
- (void)AddTaskSuccess {
    
}

#pragma mark - response methods
- (void)hideKeyboard {
    [self.TaskTitleTxtfield resignFirstResponder];
    
    if (self.dateSelectedPicker) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy/MM/dd HH:mm";
        
        NSDate *date = self.dateSelectedPicker.date;
        self.endDateLbl.text = [dateFormatter stringFromDate:date];
        
        [UIView animateWithDuration:.3f
                              delay:0
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             __weak UIView *ws = self.view;
                             [self.dateSelectedPicker mas_updateConstraints:^(MASConstraintMaker *make) {
                                 make.bottom.equalTo(ws.mas_bottom).with.offset(216);
                             }];
                             [self.view layoutIfNeeded];
                         }
                         completion:^(BOOL finished) {
                             self.dateSelectedPicker.hidden = YES;
                         }];
    }
}

- (IBAction)dateBtnOnClicked:(UIButton *)sender {
    if (self.dateSelectedPicker.hidden == YES) {
        self.dateSelectedPicker.hidden = NO;
        [UIView animateWithDuration:.3f
                              delay:0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             __weak UIView *ws = self.view;
                             [self.dateSelectedPicker mas_updateConstraints:^(MASConstraintMaker *make) {
                                 make.bottom.equalTo(ws.mas_bottom);
                             }];
                             [self.view layoutIfNeeded];
                         }
                         completion:nil];
    }
}

- (void)confirmItemOnClicked {
    
    ESTask *task = [[ESTask alloc] init];
    task.title = self.taskTitleLbl.text;
    task.taskDescription = self.TaskTitleTxtfield.text;
    task.endDate = @"2015-08-12 04:00:00";
    
    ESContactor *personInCharge = [[ESContactor alloc] init];
    personInCharge.useID = [NSNumber numberWithInteger:[@"3" integerValue]];
    personInCharge.name = @"13555762177";
    personInCharge.enterprise = @"锐捷网络";
    personInCharge.imgURLstr = @"http://120.25.249.144/media/avatar_img/01/20150808101546.png";
    task.personInCharge = personInCharge;
    
    ESContactor *observe = [[ESContactor alloc] init];
    observe.useID = [NSNumber numberWithInteger:[@"3" integerValue]];
    observe.name = @"13555762177";
    observe.enterprise = @"锐捷网络";
    observe.imgURLstr = @"http://120.25.249.144/media/avatar_img/01/20150808101546.png";
    task.personInCharge = observe;
    
    ESContactor *observe1 = [[ESContactor alloc] init];
    observe1.useID = [NSNumber numberWithInteger:[@"5" integerValue]];
    observe1.name = @"18511893717";
    observe1.enterprise = @"";
    observe1.imgURLstr = @"http://120.25.249.144/media/avatar_img/XJ/20150803223129.png";
    task.personInCharge = observe1;
    
    task.observers = [NSArray arrayWithObjects:observe,observe1,nil];
    
    [self.addTaskDataDP addTaskWithModel:task];
    
    [self cancelItemOnClicked];
}

- (void)cancelItemOnClicked {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - setters&getters
- (void)setHoldViews:(NSArray *)holdViews {
    _holdViews = holdViews;
    
    for (UIView *view in _holdViews) {
        view.layer.borderWidth = 1.f;
        view.layer.borderColor = [ColorHandler colorFromHexRGB:@"DDDDDD"].CGColor;
    }
}

- (void)setTxtHoldViews:(NSArray *)txtHoldViews {
    _txtHoldViews = txtHoldViews;
    
    for (UIView *view in _txtHoldViews) {
        view.layer.borderColor = [ColorHandler colorFromHexRGB:@"EEEEEE"].CGColor;
        view.layer.borderWidth = .8f;
        view.layer.cornerRadius = 5.f;
    }
}

- (UIDatePicker *)dateSelectedPicker {
    if (!_dateSelectedPicker) {
        _dateSelectedPicker = [UIDatePicker new];
        _dateSelectedPicker.datePickerMode = UIDatePickerModeDateAndTime;
        _dateSelectedPicker.minuteInterval = 10;
        NSDate *dateNow = [NSDate date];
        _dateSelectedPicker.minimumDate = dateNow;
        _dateSelectedPicker.maximumDate = [[NSDate alloc] initWithTimeInterval:365 * 24 * 3600
                                                                     sinceDate:dateNow];
        _dateSelectedPicker.backgroundColor = [UIColor grayColor];
        _dateSelectedPicker.hidden = YES;
    }
    
    return _dateSelectedPicker;
}

- (AddTaskDataParse *)addTaskDataDP {
    if (!_addTaskDataDP) {
        _addTaskDataDP = [[AddTaskDataParse alloc] init];
        _addTaskDataDP.delegate = self;
    }
    
    return _addTaskDataDP;
}

@end
