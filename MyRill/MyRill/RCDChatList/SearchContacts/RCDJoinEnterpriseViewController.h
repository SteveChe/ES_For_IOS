//
//  RCDJoinEnterpriseViewController.h
//  MyRill
//
//  Created by Steve on 15/8/2.
//
//

#import <UIKit/UIKit.h>
#import "EnterPriseRequestDataParse.h"



@interface RCDJoinEnterpriseViewController : UIViewController<RequestJoinEnterPriseRequestDelegate>

@property (nonatomic,strong) NSString * strUserId;

@property (weak, nonatomic) IBOutlet UITextField *joinEnterpriseTextField;
@end
