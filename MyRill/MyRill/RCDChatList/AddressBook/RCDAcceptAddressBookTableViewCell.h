//
//  RCDPhoneAddressBookTableViewCell.h
//  MyRill
//
//  Created by Steve on 15/7/12.
//
//

#import <UIKit/UIKit.h>

@protocol RCDAcceptAddressBookTableViewCellDelegate <NSObject>

-(void)addButtonClick:(id)sender;
@end

@interface RCDAcceptAddressBookTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *ivAva;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *subtitle;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (nonatomic,weak)id<RCDAcceptAddressBookTableViewCellDelegate>delegate;

-(IBAction)addButtonClick:(id)sender;


@end
