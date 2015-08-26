//
//  RootViewControllerImageCell.m
//  WeChatPublic
//
//  Created by Adrain Sun on 8/25/15.
//  Copyright (c) 2015 DaydayStudio. All rights reserved.
//

#import "RootImageCell.h"
#import "UIImageView+WebCache.h"

@interface RootImageCell ()

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *timeLabel;
@property (nonatomic, weak) IBOutlet UILabel *instructionLabel;
@property (nonatomic, weak) IBOutlet UIImageView *coverImageView;

@end

@implementation RootImageCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    [_titleLabel setPreferredMaxLayoutWidth:(CGRectGetWidth([UIScreen mainScreen].bounds) - 60.0f)];
    [_instructionLabel setPreferredMaxLayoutWidth:(CGRectGetWidth([UIScreen mainScreen].bounds) - 60.0f)];
}

- (void)setTitle:(NSString *)title time:(NSString *)time image:(NSString *)image instruction:(NSString *)instruction
{
    [_titleLabel setText:title];
    [_timeLabel setText:time];
    [_coverImageView setImage:[UIImage imageNamed:image]];
    [_instructionLabel setText:instruction];
}

- (void)setTitle:(NSString *)title image:(NSString *)imageUrl instruction:(NSString *)instruction
{
    [_titleLabel setText:title];
    [_timeLabel setHidden:YES];
//    [_coverImageView setImage:[UIImage imageNamed:image]];
    [_coverImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@""]];

    [_instructionLabel setText:instruction];

}



@end