//
//  RCDJoinEnterpriseViewController.m
//  MyRill
//
//  Created by Steve on 15/8/2.
//
//

#import "RCDJoinEnterpriseViewController.h"
#import "CustomShowMessage.h"
#import "UserDefaultsDefine.h"

@interface RCDJoinEnterpriseViewController ()

@property (nonatomic,strong) EnterPriseRequestDataParse* enterpriseRequestDataParse;
@end

@implementation RCDJoinEnterpriseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"加入公司验证";
    self.tabBarController.tabBar.hidden = YES;
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:self action:@selector(backToLastPage)];
    [self.navigationItem setLeftBarButtonItem:backButton];
    
    _enterpriseRequestDataParse = [[EnterPriseRequestDataParse alloc] init];
    _enterpriseRequestDataParse.joinEnterPriseDelegate = self;
}

-(void)viewWillAppear:(BOOL)animated
{
    //自定义rightBarButtonItem
    UIBarButtonItem *settintBtnItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self
                                                                                    action:@selector(rightBarButtonItemPressed:)];
    self.navigationItem.rightBarButtonItem = settintBtnItem;
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString* myName = [userDefaults stringForKey:DEFAULTS_USERNAME];
    
    NSString* joinEnterpriseText = [NSString stringWithFormat:@"我是%@，申请加入你的公司",myName];
    _joinEnterpriseTextField.text = joinEnterpriseText;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - RequestJoinEnterPriseRequestDelegate
-(void)requestJoinEnterPriseSucceed
{
    [[CustomShowMessage getInstance] showNotificationMessage:@"已经发送请求！"];
    [self performSelector:@selector(backToLastPage)
               withObject:nil
               afterDelay:1];
}
-(void)requestJoinEnterPriseFailed:(NSString*)errorMessage
{
    [[CustomShowMessage getInstance] showNotificationMessage:errorMessage];
}

#pragma mark - response events
/**
 *  重载右边导航按钮的事件
 *
 *  @param sender
 */
-(void)rightBarButtonItemPressed:(id)sender
{
    if (_strUserId == nil || _strUserId == nil
        ||[_strUserId length] <= 0)
    {
        return;
    }
    [_enterpriseRequestDataParse requestJoinEnterPriseWithUserId:_strUserId];
}


-(void)backToLastPage
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
