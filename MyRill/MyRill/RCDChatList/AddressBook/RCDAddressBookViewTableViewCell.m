//
//  RCDAddressBookViewTableViewCell.m
//  MyRill
//
//  Created by Steve on 15/7/12.
//
//

#import "RCDAddressBookViewTableViewCell.h"

@implementation RCDAddressBookViewTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.redBadgeLabel.clipsToBounds = YES;
    self.redBadgeLabel.layer.cornerRadius = 5.f;
    self.redBadgeLabel.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
