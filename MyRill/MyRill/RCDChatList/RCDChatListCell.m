//
//  RCDChatListCell.m
//  RCloudMessage
//
//  Created by Liv on 15/4/15.
//  Copyright (c) 2015年 胡利武. All rights reserved.
//

#define HEXCOLOR(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#import "RCDChatListCell.h"
#import "Masonry.h"

@implementation RCDChatListCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        _ivAva = [UIImageView new];
        _ivAva.clipsToBounds = YES;
        _ivAva.layer.cornerRadius = 23.0f;
        [_ivAva setBackgroundColor:[UIColor clearColor]];
        
        _lblDetail = [UILabel new];
        [_lblDetail setFont:[UIFont systemFontOfSize:14.f]];
        [_lblDetail setTextColor:HEXCOLOR(0x8c8c8c)];
        _lblDetail.text = [NSString stringWithFormat:@"来自%@的好友请求",_userName];
        
        _lblName = [UILabel new];
        [_lblName setFont:[UIFont boldSystemFontOfSize:16.f]];
        [_lblName setTextColor:HEXCOLOR(0x252525)];
        _lblName.text = @"好友消息";
        
        _timeLabel = [UILabel new];
        [_timeLabel setFont:[UIFont systemFontOfSize:14.f]];
        [_timeLabel setTextColor:HEXCOLOR(0x8c8c8c)];
        _timeLabel.text = [NSString stringWithFormat:@""];

        _lblRedBadage = [UILabel new];
        _lblRedBadage.text = @"11";
        [_lblRedBadage setFont:[UIFont systemFontOfSize:8.f]];
        [_lblRedBadage setTextColor:[UIColor clearColor]];
        _lblRedBadage.hidden = YES;
        _lblRedBadage.backgroundColor = [UIColor redColor];
        self.lblRedBadage.clipsToBounds = YES;
        self.lblRedBadage.layer.cornerRadius = 5.f;

        
        [self addSubview:_ivAva];
        [self addSubview:_lblDetail];
        [self addSubview:_lblName];
        [self addSubview:_timeLabel];
        [self addSubview:_lblRedBadage];
        
        _ivAva.translatesAutoresizingMaskIntoConstraints = NO;
        _lblName.translatesAutoresizingMaskIntoConstraints = NO;
        _lblDetail.translatesAutoresizingMaskIntoConstraints = NO;
        
        NSDictionary *_bindingViews = NSDictionaryOfVariableBindings(_ivAva,_lblName,_lblDetail);
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_ivAva(46)]" options:kNilOptions metrics:nil views:_bindingViews]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-11-[_ivAva(46)]-8-[_lblDetail]-10-|" options:kNilOptions metrics:nil views:_bindingViews]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_ivAva attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0]];
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_lblName(18)]-[_lblDetail(18)]" options:kNilOptions metrics:kNilOptions views:_bindingViews]];
        
        //[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_lblDetail]-10-|" options:kNilOptions metrics:kNilOptions views:_bindingViews]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_lblName attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_ivAva attribute:NSLayoutAttributeTop multiplier:1.0 constant:2.f]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_lblName attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_ivAva attribute:NSLayoutAttributeRight multiplier:1.0 constant:8]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_lblDetail attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_lblName attribute:NSLayoutAttributeLeft multiplier:1.0 constant:1]];
        
        __weak UIView *ws = self;
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(ws.mas_top).with.offset(12);
            make.trailing.equalTo(ws.mas_trailing).with.offset(-8);
        }];

//        __weak UIView *ws = self;
        [_lblRedBadage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(ws.mas_top).with.offset(8);
            make.trailing.equalTo(ws.mas_left).with.offset(65);

//            make.width.equalTo(ws.mas_width).width;
//            make.width.equalTo(ws.mas_height).with.offset(10);
        }];
        
        
    }
    return self;
}

@end
