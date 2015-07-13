//
//  RCDPhoneAddressBookViewController.h
//  MyRill
//
//  Created by Steve on 15/7/8.
//
//

#import <UIKit/UIKit.h>
#import "GetPhoneContactListDataParse.h"
#import "RCDPhoneAddressBookTableViewCell.h"

@interface RCDPhoneAddressBookViewController : UITableViewController<GetPhoneContactListDelegate,RCDPhoneAddressBookTableViewCellDelegate>

@end
