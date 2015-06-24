//
//  ChatViewController.h
//  MyRill
//
//  Created by Steve on 15/6/24.
//
//

#import <RongIMKit/RongIMKit.h>

@interface ChatViewController : RCConversationViewController
/**
 *  会话数据模型
 */
@property (strong,nonatomic) RCConversationModel *conversation;

@end
