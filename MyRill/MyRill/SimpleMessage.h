//
//  SimpleMessage.h
//  MyRill
//
//  Created by Steve on 15/8/7.
//
//

#import <RongIMLib/RongIMLib.h>
#import <RongIMLib/RCMessageContentView.h>
#define RCLocalMessageTypeIdentifier @"RC:SimpleMsg"

@interface SimpleMessage : RCMessageContent<NSCoding,RCMessageContentView>
/** 文本消息内容 */
@property(nonatomic, strong) NSString* content;

/**
 * 附加信息
 */
@property(nonatomic, strong) NSString* extra;

/**
 * 根据参数创建文本消息对象
 * @param content 文本消息内容
 */
+(instancetype)messageWithContent:(NSString *)content;

@end

