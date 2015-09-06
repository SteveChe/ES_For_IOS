//
//  RCDApprovedJoinEnterpriseViewController.h
//  MyRill
//
//  Created by Steve on 15/8/2.
//
//

#import <UIKit/UIKit.h>
#import "RCDAcceptAddressBookTableViewCell.h"
#import "EnterPriseRequestDataParse.h"
@interface RCDApprovedJoinEnterpriseViewController : UITableViewController<RCDAcceptAddressBookTableViewCellDelegate,GetEnterPriseRequestListDelegate,ApprovedEnterPriseRequestDelegate>

@end
