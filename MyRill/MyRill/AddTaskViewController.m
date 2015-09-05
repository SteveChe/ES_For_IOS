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
#import "ESUserInfo.h"
#import "Masonry.h"
#import "TaskContactorCollectionViewCell.h"
#import "ESUserInfo.h"
//#import "RCDSelectPersonViewController.h"
#import "ChatViewController.h"
#import "MRProgress.h"
#import "RCDRadioSelectPersonViewController.h"

@interface AddTaskViewController () <AddTaskDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UITextFieldDelegate, UITextViewDelegate>

@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *holdViews;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *txtHoldViews;

@property (weak, nonatomic) IBOutlet UITextField *taskTitleTxtField;
@property (weak, nonatomic) IBOutlet UITextView *taskDescriptionTxtView;
@property (weak, nonatomic) IBOutlet UILabel *endDateLbl;
@property (nonatomic, strong) UIDatePicker *dateSelectedPicker;
@property (weak, nonatomic) IBOutlet UICollectionView *assignerCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *followsCollectionView;
@property (nonatomic, strong) MRProgressOverlayView *progress;

@property (nonatomic, strong) NSMutableArray *assignerDataSource; //负责人列表,ESUserInfo
@property (nonatomic, strong) NSMutableArray *followsDataSource;  //关注人列表,ESUserInfo
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
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBackground)];
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
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy/MM/dd HH:mm";
    NSDate *date = self.dateSelectedPicker.date;
    date = [date dateByAddingTimeInterval:24 *3600];
    self.endDateLbl.text = [dateFormatter stringFromDate:date];
}

#pragma mark - AddTaskDelegate method
- (void)addTaskSuccess {
    [self showTips:@"添加成功!" mode:MRProgressOverlayViewModeCheckmark isDismiss:YES isSucceuss:YES];
}

- (void)addTaskFailed:(NSString *)errorMessage {
    [self showTips:@"添加失败!" mode:MRProgressOverlayViewModeCross isDismiss:YES isSucceuss:NO];
}

#pragma mark - UICollectionViewDataSource&UICollectionViewDelegateFlowLayout
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView == self.assignerCollectionView) {
        return self.assignerDataSource.count;
    } else if (collectionView == self.followsCollectionView) {
        return self.followsDataSource.count;
    } else {
        return 0;
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TaskContactorCollectionViewCell *cell = (TaskContactorCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"TaskContactorCollectionViewCell" forIndexPath:indexPath];
    
    cell.contentView.backgroundColor = [UIColor whiteColor];
    
    ESUserInfo *user = nil;
    
    if (collectionView == self.assignerCollectionView) {
        user = (ESUserInfo *)self.assignerDataSource[indexPath.row];
        [cell updateCell:user];
        return cell;
    } else if (collectionView == self.followsCollectionView) {
        user = (ESUserInfo *)self.followsDataSource[indexPath.row];
        [cell updateCell:user];
        return cell;
    } else {
        return nil;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(54,54);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

//设置Cell的边界
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0,0,0,0);
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

#pragma mark - UITextField Delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [self hideDatePicker];
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    [self hideDatePicker];
    return YES;
}

#pragma mark - response methods
- (void)tapBackground {
    [self freeKeyboard];
    [self hideDatePicker];
}

- (void)freeKeyboard {
    [self.taskTitleTxtField resignFirstResponder];
    [self.taskDescriptionTxtView resignFirstResponder];
}

- (void)hideDatePicker {
    if (self.dateSelectedPicker) {
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

- (void)dateChanged:(UIDatePicker *)sender {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy/MM/dd HH:mm";
    
    NSDate *date = self.dateSelectedPicker.date;
    self.endDateLbl.text = [dateFormatter stringFromDate:date];
}

- (IBAction)dateBtnOnClicked:(UIButton *)sender {
    [self freeKeyboard];
    
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

- (IBAction)chooseContactorBtnOnClicked:(UIButton *)sender {
    [self tapBackground];
    
    if (sender.tag == 1003) {
        __weak typeof(&*self)  weakSelf = self;
        RCDRadioSelectPersonViewController* selectPersonVC = [[RCDRadioSelectPersonViewController alloc] init];
        selectPersonVC.type = e_Selected_Person_Radio;
        [selectPersonVC setSeletedUsers:self.assignerDataSource];
        //设置回调
        selectPersonVC.clickDoneCompletion = ^(RCDRadioSelectPersonViewController* selectPersonViewController, NSArray* selectedUsers) {
            
            if (selectedUsers && selectedUsers.count)
            {
                [self.assignerDataSource removeAllObjects];
                [self.assignerDataSource addObjectsFromArray:selectedUsers];
            }
            
            [weakSelf.navigationController popViewControllerAnimated:YES ];
            [self.assignerCollectionView reloadData];
        };
        [self.navigationController pushViewController:selectPersonVC animated:YES];
    }
    else if (sender.tag == 1004){
        RCDRadioSelectPersonViewController* selectPersonVC = [[RCDRadioSelectPersonViewController alloc] init];
                selectPersonVC.type = e_Selected_Check_Box_Deselect;
        [selectPersonVC setSeletedUsers:self.followsDataSource];
        __weak typeof(&*self)  weakSelf = self;
        
        //设置回调
        selectPersonVC.clickDoneCompletion = ^(RCDRadioSelectPersonViewController* selectPersonViewController, NSArray* selectedUsers) {
            
            if (selectedUsers && selectedUsers.count)
            {
                [self.followsDataSource removeAllObjects];
                [self.followsDataSource addObjectsFromArray:selectedUsers];
            }
            [weakSelf.navigationController popViewControllerAnimated:YES ];
            [self.followsCollectionView reloadData];
        };
        [self.navigationController pushViewController:selectPersonVC animated:YES];
    }
}

- (void)confirmItemOnClicked {
    
    if ([ColorHandler isNullOrEmptyString:self.taskTitleTxtField.text]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"注意"
                                                                                 message:@"请输入任务名称!"
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"好的!" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alertController
                           animated:YES
                         completion:nil];
        return;
    } else if ([ColorHandler isNullOrEmptyString:self.taskDescriptionTxtView.text]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"注意"
                                                                                 message:@"请输入任务说明!"
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"好的!" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alertController
                           animated:YES
                         completion:nil];
        return;
    } else if (self.assignerDataSource.count == 0) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"注意"
                                                                                 message:@"分配人不能为空!"
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"好的!" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alertController
                           animated:YES
                         completion:nil];
        return;
    } else {
        ESTask *task = [[ESTask alloc] init];
        task.title = self.taskTitleTxtField.text;
        task.taskDescription = self.taskDescriptionTxtView.text;
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        NSDate *date = self.dateSelectedPicker.date;
        task.endDate = [dateFormatter stringFromDate:date];
        
        if ([self.chatID isKindOfClass:[NSNull class]] || self.chatID == nil || [self.chatID isEqualToString:@""]) {
            task.chatID = @"";
        } else {
            task.chatID = self.chatID;
        }
        
        task.personInCharge = [self.assignerDataSource firstObject];
        task.observers = self.followsDataSource;
        
        [self.addTaskDataDP addTaskWithModel:task];
    }
}

- (void)cancelItemOnClicked {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - private methods
- (void)showTips:(NSString *)tip mode:(MRProgressOverlayViewMode)mode isDismiss:(BOOL)isDismiss isSucceuss:(BOOL)success
{
    [self.navigationController.view addSubview:self.progress];
    [self.progress show:YES];
    self.progress.mode = mode;
    self.progress.titleLabelText = tip;
    if (isDismiss)
    {
        [self performSelector:@selector(dismissProgress:) withObject:@(success) afterDelay:1.8];
    }
}

//参数作为布尔对象传递，使用Bool会出问题
- (void)dismissProgress:(Boolean)isSuccess
{
    if (self.progress)
    {
        [self.progress dismiss:YES];
        if (isSuccess) {
            [self cancelItemOnClicked];
        }
    }
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

- (void)setAssignerCollectionView:(UICollectionView *)assignerCollectionView {
    _assignerCollectionView = assignerCollectionView;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 0;
    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    _assignerCollectionView.collectionViewLayout = layout;
    
    UINib *professionCell = [UINib nibWithNibName:@"TaskContactorCollectionViewCell" bundle:nil];
    [_assignerCollectionView registerNib:professionCell forCellWithReuseIdentifier:@"TaskContactorCollectionViewCell"];
    _assignerCollectionView.bounces = NO;
}

- (void)setFollowsCollectionView:(UICollectionView *)followsCollectionView {
    _followsCollectionView = followsCollectionView;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 0;
    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    _followsCollectionView.collectionViewLayout = layout;
    
    UINib *professionCell = [UINib nibWithNibName:@"TaskContactorCollectionViewCell" bundle:nil];
    [_followsCollectionView registerNib:professionCell forCellWithReuseIdentifier:@"TaskContactorCollectionViewCell"];
    _followsCollectionView.bounces = NO;
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
        [_dateSelectedPicker addTarget:self
                                action:@selector(dateChanged:)
                      forControlEvents:UIControlEventValueChanged ];
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

- (NSMutableArray *)assignerDataSource {
    if (!_assignerDataSource) {
        _assignerDataSource = [[NSMutableArray alloc] init];
    }
    return _assignerDataSource;
}

- (NSMutableArray *)followsDataSource {
    if (!_followsDataSource) {
        _followsDataSource = [[NSMutableArray alloc] init];
    }
    return _followsDataSource;
}

- (MRProgressOverlayView *)progress {
    if (!_progress) {
        _progress = [[MRProgressOverlayView alloc] init];
    }
    
    return _progress;
}

@end
