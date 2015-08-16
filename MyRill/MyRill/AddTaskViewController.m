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
#import "TaskContactorCollectionViewCell.h"
#import "ESUserInfo.h"
#import "RCDSelectPersonViewController.h"
#import "ChatViewController.h"

@interface AddTaskViewController () <AddTaskDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate>

@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *holdViews;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *txtHoldViews;

@property (weak, nonatomic) IBOutlet UITextField *taskTitleTxtField;
@property (weak, nonatomic) IBOutlet UITextView *taskDescriptionTxtView;
@property (weak, nonatomic) IBOutlet UILabel *endDateLbl;
@property (nonatomic, strong) UIDatePicker *dateSelectedPicker;
@property (weak, nonatomic) IBOutlet UICollectionView *assignerCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *followsCollectionView;

@property (nonatomic, strong) NSMutableArray *assignerDataSource;
@property (nonatomic, strong) NSMutableArray *followsDataSource;
@property (nonatomic, strong) AddTaskDataParse *addTaskDataDP;
@property (nonatomic,strong) NSMutableArray* tastObserversList;//关注人列表,ESUserInfo
@property (nonatomic,strong) NSMutableArray* tastRecipientsList;//负责人列表,ESUserInfo

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
    
    if (self.tastRecipientsList == nil) {
        self.tastRecipientsList = [NSMutableArray array];
    }
    if (self.tastObserversList == nil) {
        self.tastObserversList = [NSMutableArray array];
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy/MM/dd HH:mm";
    NSDate *date = self.dateSelectedPicker.date;
    date = [date dateByAddingTimeInterval:24 *3600];
    self.endDateLbl.text = [dateFormatter stringFromDate:date];
}

#pragma mark - AddTaskDelegate method
- (void)AddTaskSuccess {
    
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
    
    ESContactor *contactor = nil;
    
    if (collectionView == self.assignerCollectionView) {
        contactor = (ESContactor *)self.assignerDataSource[indexPath.row];
        [cell updateCell:contactor];
        return cell;
    } else if (collectionView == self.followsCollectionView) {
        contactor = (ESContactor *)self.followsDataSource[indexPath.row];
        [cell updateCell:contactor];
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

#pragma mark - response methods
- (void)hideKeyboard {
    [self.taskTitleTxtField resignFirstResponder];
    [self.taskDescriptionTxtView resignFirstResponder];
    
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
    if (sender.tag == 1003) {
        __weak typeof(&*self)  weakSelf = self;
        RCDSelectPersonViewController* selectPersonVC = [[RCDSelectPersonViewController alloc] init];
        [selectPersonVC setSeletedUsers:self.tastRecipientsList];
        //设置回调
        selectPersonVC.clickDoneCompletion = ^(RCDSelectPersonViewController* selectPersonViewController, NSArray* selectedUsers) {
            
            if (selectedUsers && selectedUsers.count)
            {
                [self.tastRecipientsList removeAllObjects];
                [self.tastRecipientsList addObjectsFromArray:selectedUsers];
                weakSelf.assignerDataSource = nil;
                for (ESUserInfo *user in self.tastRecipientsList) {
                    ESContactor *contactor = [[ESContactor alloc] init];
                    contactor.useID = [NSNumber numberWithInteger:[user.userId integerValue]];
                    contactor.name = user.userName;
                    contactor.imgURLstr = user.portraitUri;
                    contactor.enterprise = user.enterprise;
                    [weakSelf.assignerDataSource addObject:contactor];
                }
            }
            
            [weakSelf.navigationController popViewControllerAnimated:YES ];
            [self.assignerCollectionView reloadData];
        };
        [self.navigationController pushViewController:selectPersonVC animated:YES];
    }
    else if (sender.tag == 1004){
        RCDSelectPersonViewController* selectPersonVC = [[RCDSelectPersonViewController alloc] init];
        [selectPersonVC setSeletedUsers:self.tastObserversList];
        __weak typeof(&*self)  weakSelf = self;
        
        //设置回调
        selectPersonVC.clickDoneCompletion = ^(RCDSelectPersonViewController* selectPersonViewController, NSArray* selectedUsers) {
            
            if (selectedUsers && selectedUsers.count)
            {
                [self.tastObserversList removeAllObjects];
                [self.tastObserversList addObjectsFromArray:selectedUsers];
                weakSelf.followsDataSource = nil;
                for (ESUserInfo *user in self.tastObserversList) {
                    ESContactor *contactor = [[ESContactor alloc] init];
                    contactor.useID = [NSNumber numberWithInteger:[user.userId integerValue]];
                    contactor.name = user.userName;
                    contactor.imgURLstr = user.portraitUri;
                    contactor.enterprise = user.enterprise;
                    [weakSelf.followsDataSource addObject:contactor];
                }
            }
            [weakSelf.navigationController popViewControllerAnimated:YES ];
            [self.followsCollectionView reloadData];
        };
        [self.navigationController pushViewController:selectPersonVC animated:YES];
    }
}

- (void)confirmItemOnClicked {
    ESTask *task = [[ESTask alloc] init];
    task.title = self.taskTitleTxtField.text;
    task.taskDescription = self.taskDescriptionTxtView.text;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *date = self.dateSelectedPicker.date;
    task.endDate = [dateFormatter stringFromDate:date];
    
    if ([self.chatID isKindOfClass:[NSNull class]] || [self.chatID isEqualToString:@""]) {
        task.chatID = @"";
    } else {
        task.chatID = self.chatID;
    }
    
    task.personInCharge = [self.assignerDataSource firstObject];
    task.observers = [NSArray arrayWithArray:self.followsDataSource];
    
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

@end
