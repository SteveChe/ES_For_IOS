//
//  RootOutChatCell.m
//  WeChatPublic
//
//  Created by Adrain Sun on 8/25/15.
//  Copyright (c) 2015 DaydayStudio. All rights reserved.
//

#import "RootOutChatCell.h"
#import "UIImageView+WebCache.h"

@interface RootOutChatCell ()

@property (nonatomic, weak) IBOutlet UILabel *msgLabel;
@property (nonatomic, weak) IBOutlet UIImageView *photoImageView;

@end

@implementation RootOutChatCell

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
    [_photoImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"头像_100"]];
}

@end
