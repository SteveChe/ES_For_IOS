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

@interface RCDAddressBookDetailViewController : ESViewController <ContactDetailDataDelegate>

@property (nonatomic,strong)ESUserInfo* userInfo;
@end
