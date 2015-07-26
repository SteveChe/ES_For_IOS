//
//  AddProfessionViewController.m
//  MyRill
//
//  Created by Siyuan Wang on 15/7/9.
//
//

#import "AddProfessionViewController.h"
#import "ColorHandler.h"
#import "ProfessionDataParse.h"
#import "ESProfession.h"

@interface AddProfessionViewController () <ProfessionDataDelegate>

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *holdViews;
@property (weak, nonatomic) IBOutlet UITextField *nameTxtField;
@property (weak, nonatomic) IBOutlet UITextField *urlTxtField;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (nonatomic, strong) ProfessionDataParse *professionDP;

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
- (void)professionOperationSuccess:(id)context {
    if ([context isKindOfClass:[ESProfession class]]) {
        ESProfession *profession = (ESProfession *)context;
        [self.delegate addProfessionSuccess:profession];
        [self.navigationController popViewControllerAnimated:YES];
    } else if (YES) {
        
    } else {
        
    }
}

- (void)professionOperationFailure:(NSString *)errorMsg {
    NSLog(@"添加业务失败,请检查网络");
}

#pragma mark - response events
- (IBAction)saveBtnOnClicked:(UIButton *)sender {
    if (self.nameTxtField.text != nil && self.urlTxtField.text != nil) {
        [self.professionDP addProfessionWithName:self.nameTxtField.text url:self.urlTxtField.text];
    } else {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示"
                                                                                 message:@"名称和URL不能为空!"
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        
        
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

- (ProfessionDataParse *)professionDP {
    if (!_professionDP) {
        _professionDP = [[ProfessionDataParse alloc] init];
        _professionDP.delegate = self;
    }
    
    return _professionDP;
}

@end
