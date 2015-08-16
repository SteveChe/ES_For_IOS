//
//  ComplexMessageCell.h
//  MyRill
//
//  Created by Steve on 15/8/16.
//
//

#import <RongIMKit/RongIMKit.h>

@interface ComplexMessageCell : RCMessageCell
/**
 * 消息显示Label
 */
@property(strong, nonatomic) RCAttributedLabel *textLabel;

/**
 * 消息背景
 */
@property(nonatomic, strong) UIImageView *bubbleBackgroundView;

/**
 * 设置消息数据模型
 *
 * @param model 消息数据模型
 */
- (void)setDataModel:(RCMessageModel *)model;
@end
