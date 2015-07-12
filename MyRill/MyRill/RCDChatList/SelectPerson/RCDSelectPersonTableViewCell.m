//
//  RCDSelectPersonTableViewCell.m
//  RCloudMessage
//
//  Created by Liv on 15/3/27.
//  Copyright (c) 2015年 胡利武. All rights reserved.
//

#import "RCDSelectPersonTableViewCell.h"

@interface RCDSelectPersonTableViewCell ()

@end

@implementation RCDSelectPersonTableViewCell

-(void)awakeFromNib
{
    self.ivAva.clipsToBounds = YES;
    self.ivAva.layer.cornerRadius = 18.f;
}

-(void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    if (selected) {
        
        _ivSelected.image = [UIImage imageNamed:@"faqiduihua_xuanzhong"];
    }else{
        _ivSelected.image = [UIImage imageNamed:@"faqiduihua_xuanze"];
    }
}

@end
