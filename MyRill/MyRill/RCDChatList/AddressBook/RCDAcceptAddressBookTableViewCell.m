//
//  RCDPhoneAddressBookTableViewCell.m
//  MyRill
//
//  Created by Steve on 15/7/12.
//
//

#import "RCDAcceptAddressBookTableViewCell.h"

@implementation RCDAcceptAddressBookTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.ivAva.clipsToBounds = YES;
    self.ivAva.layer.cornerRadius = 18.f;
    self.addButton.clipsToBounds = YES;
    self.addButton.layer.cornerRadius = 5.f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(IBAction)addButtonClick:(id)sender
{
    if (self.delegate!= nil && [self.delegate respondsToSelector:@selector(addButtonClick:)])
    {
        [self.delegate addButtonClick:self];
    }
}


@end
