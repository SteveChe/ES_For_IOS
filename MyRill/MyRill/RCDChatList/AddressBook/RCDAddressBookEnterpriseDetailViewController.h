//
//  RCDAddressBookEnterpriseDetailViewController.h
//  MyRill
//
//  Created by Steve on 15/8/10.
//
//

#import <UIKit/UIKit.h>
#import "ESViewController.h"
#import "GetEnterpriseDetailDataParse.h"

@interface RCDAddressBookEnterpriseDetailViewController : ESViewController<EnterpriseDetailInfoDataDelegate>

@property (nonatomic,strong) NSString* enterpriseId;
@end
