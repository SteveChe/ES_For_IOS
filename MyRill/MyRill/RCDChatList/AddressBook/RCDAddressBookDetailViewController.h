//
//  RCDAddressBookDetailViewController.h
//  MyRill
//
//  Created by Steve on 15/7/14.
//
//

#import <UIKit/UIKit.h>
#import "ESViewController.h"
#import "GetContactDetailDataParse.h"
@class ESUserInfo;

@interface RCDAddressBookDetailViewController : UIViewController <ContactDetailDataDelegate>

@property (nonatomic,strong)NSString* userId;
@end
