//
//  RCDApprovedJoinEnterpriseViewController.h
//  MyRill
//
//  Created by Steve on 15/8/2.
//
//

#import <UIKit/UIKit.h>
#import "RCDPhoneAddressBookTableViewCell.h"
#import "EnterPriseRequestDataParse.h"
@interface RCDApprovedJoinEnterpriseViewController : UITableViewController<RCDPhoneAddressBookTableViewCellDelegate,GetEnterPriseRequestListDelegate,ApprovedEnterPriseRequestDelegate>

@end
