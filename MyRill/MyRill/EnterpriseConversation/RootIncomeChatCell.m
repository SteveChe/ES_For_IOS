//
//  RootIncomeChatCell.m
//  WeChatPublic
//
//  Created by Adrain Sun on 8/25/15.
//  Copyright (c) 2015 DaydayStudio. All rights reserved.
//

#import "RootIncomeChatCell.h"
#import "UIImageView+WebCache.h"

@interface RootIncomeChatCell ()

@property (nonatomic, weak) IBOutlet UILabel *msgLabel;
@property (nonatomic, weak) IBOutlet UIImageView *photoImageView;

@end

@implementation RootIncomeChatCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    [_msgLabel setPreferredMaxLayoutWidth:(CGRectGetWidth([UIScreen mainScreen].bounds) - 120.0f)];
    [_photoImageView.layer setBorderWidth:0.5f];
    [_photoImageView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
}

- (void)setMsgData:(NSString *)msg image:(NSString *)imageUrl
{
    [_msgLabel setText:msg];
//    [_photoImageView setImage:[UIImage imageNamed:imageName]];
    [_photoImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"头像_100"]];
}

@end
