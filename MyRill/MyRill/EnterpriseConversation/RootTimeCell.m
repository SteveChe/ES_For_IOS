//
//  RootViewControllerTimeCell.m
//  WeChatPublic
//
//  Created by Adrain Sun on 8/25/15.
//  Copyright (c) 2015 DaydayStudio. All rights reserved.
//

#import "RootTimeCell.h"

@interface RootTimeCell ()

@property (nonatomic, weak) IBOutlet UIView *bgView;
@property (nonatomic, weak) IBOutlet UILabel *timeLabel;

@end

@implementation RootTimeCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    [_bgView.layer setCornerRadius:4.0f];
}

- (void)setCellData:(NSString *)data
{
    [_timeLabel setText:data];
}

@end
