//
//  RCDPhoneAddressBookTableViewCell.m
//  MyRill
//
//  Created by Steve on 15/7/12.
//
//

#import "RCDPhoneAddressBookTableViewCell.h"

@implementation RCDPhoneAddressBookTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.ivAva.clipsToBounds = YES;
    self.ivAva.layer.cornerRadius = 18.f;
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
