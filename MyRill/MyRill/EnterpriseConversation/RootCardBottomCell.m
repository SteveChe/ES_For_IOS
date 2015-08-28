//
//  RootCardBottomCell.m
//  WeChatPublic
//
//  Created by Adrain Sun on 8/25/15.
//  Copyright (c) 2015 DaydayStudio. All rights reserved.
//

#import "RootCardBottomCell.h"

@interface RootCardBottomCell ()

@property (nonatomic, weak) IBOutlet UILabel *instructionLabel;
@property (nonatomic, weak) IBOutlet UIImageView *photoImageView;

@end

@implementation RootCardBottomCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    [_instructionLabel setPreferredMaxLayoutWidth:(CGRectGetWidth([UIScreen mainScreen].bounds) - 120.0f)];
}

- (void)setTitle:(NSString *)title image:(NSString *)image
{
    [_instructionLabel setText:title];
    [_photoImageView setImage:[UIImage imageNamed:image]];
}

@end
