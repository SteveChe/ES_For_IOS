//
//  AddProfessionViewController.m
//  MyRill
//
//  Created by Siyuan Wang on 15/7/9.
//
//

#import "AddProfessionViewController.h"
#import "ColorHandler.h"
#import "AddProfessionDataParse.h"
#import "ESProfession.h"

@interface AddProfessionViewController () <AddProfessionDataDelegate>

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *holdViews;
@property (weak, nonatomic) IBOutlet UITextField *nameTxtField;
@property (weak, nonatomic) IBOutlet UITextField *urlTxtField;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (nonatomic, strong) AddProfessionDataParse *addProfessionDP;

@end

@implementation AddProfessionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"添加业务";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = YES;
}

#pragma mark - ProfessionDataDelegate methods
- (void)addProfessionOperationSuccess:(ESProfession *)profession {
    ESProfession *newProfession = (ESProfession *)profession;
    [self.delegate addProfessionSuccess:newProfession];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addProfessionOperationFailure:(NSString *)errorMsg {

    NSString *msg = @"";
    if ([errorMsg isEqualToString:@"添加失败"]) {
        msg = @"请输入一个有效的URL!";
    } else {
        msg = @"添加业务失败,请检查网络";
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                    message:@"请输入一个有效的URL!"
                                                   delegate:self
                                          cancelButtonTitle:@"知道了!"
                                          otherButtonTitles:nil, nil];
    [alert show];
}

#pragma mark - response events
- (IBAction)saveBtnOnClicked:(UIButton *)sender {
    if (![ColorHandler isNullOrEmptyString:self.nameTxtField.text] && ![ColorHandler isNullOrEmptyString:self.urlTxtField.text]) {
        [self.addProfessionDP addProfessionWithName:self.nameTxtField.text url:self.urlTxtField.text];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"名称和URL不能为空!"
                                                       delegate:self
                                              cancelButtonTitle:@"知道了!"
                                              otherButtonTitles:nil, nil];
        [alert show];
    }
}

#pragma mark - setters&getters
- (void)setContentView:(UIView *)contentView {
    _contentView = contentView;
    
    _contentView.layer.borderWidth = 1.f;
    _contentView.layer.borderColor = [ColorHandler colorFromHexRGB:@"DDDDDD"].CGColor;
}

- (void)setHoldViews:(NSArray *)holdViews {
    _holdViews = holdViews;
    
    for (UIView *view in _holdViews) {
        view.layer.borderWidth = 1.f;
        view.layer.borderColor = [ColorHandler colorFromHexRGB:@"DDDDDD"].CGColor;
        view.layer.cornerRadius = 3.f;
    }
}

- (void)setSaveBtn:(UIButton *)saveBtn {
    _saveBtn = saveBtn;
    
    _saveBtn.layer.cornerRadius = 20.f;
}

- (AddProfessionDataParse *)addProfessionDP {
    if (!_addProfessionDP) {
        _addProfessionDP = [[AddProfessionDataParse alloc] init];
        _addProfessionDP.delegate = self;
    }
    
    return _addProfessionDP;
}

@end
