//
//  RCDAcceptContactViewController.h
//  MyRill
//
//  Created by Steve on 15/7/6.
//
//

#import <UIKit/UIKit.h>
#import "GetRequestContactListDataParse.h"
#import "AddContactDataParse.h"
#import "RCDAcceptAddressBookTableViewCell.h"

@interface RCDAcceptContactViewController : UITableViewController<GetRequestContactListDelegate,AddContactDelegate,RCDAcceptAddressBookTableViewCellDelegate>

@end
