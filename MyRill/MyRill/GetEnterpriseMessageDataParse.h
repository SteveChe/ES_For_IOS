//
//  GetEnterpriseMessageDataParse.h
//  MyRill
//
//  Created by Steve on 15/8/8.
//
//

#import <Foundation/Foundation.h>
@class ESEnterpriseMessage;

@protocol GetLastestMessageDelegate <NSObject>
-(void)getLastestMessageSucceed:(NSArray*)enterpriseMessage;
-(void)getLastestMessageFailed:(NSString*)errorMessage;
@end

@protocol GetLastestRILLMessageDelegate <NSObject>
-(void)getLastestRILLMessageSucceed:(ESEnterpriseMessage*)enterpriseMessage;
-(void)getLastestRILLMessageFailed:(NSString*)errorMessage;
@end

@protocol GetRILLMessageListDelegate <NSObject>
-(void)getRILLMessageSucceed:(NSArray*)enterpriseList;
-(void)getRILLMessageFailed:(NSString*)errorMessage;
@end

@protocol ReplyToRILLMessageDelegate <NSObject>
-(void)replyToRillMessageSucceed;
-(void)replyToRillMessageFailed:(NSString*)errorMessage;
@end

@protocol GetLastestEnterpriseMessageDelegate <NSObject>
-(void)getLastestEnterpriseMessageSucceed:(NSArray*)enterpriseList;
-(void)getLastestEnterpriseMessageFailed:(NSString*)errorMessage;
@end

@protocol GetALLEnterpriseLastestMessageListDelegate <NSObject>
-(void)getALLEnterpriseLastestMessageListSucceed:(NSArray*)enterpriseList;
-(void)getALLEnterpriseLastestMessageListFailed:(NSString*)errorMessage;
@end

@protocol GetOneEnterpriseMessageListDelegate <NSObject>
-(void)getOneEnterpriseMessageListSucceed:(NSArray*)enterpriseList;
-(void)getOneEnterpriseMessageListFailed:(NSString*)errorMessage;
@end

@protocol ReplyToOneEnterpriseMessageDelegate <NSObject>
-(void)replyOneEnterpriseMessageSucceed;
-(void)replyOneEnterpriseMessageFailed:(NSString*)errorMessage;
@end


@interface GetEnterpriseMessageDataParse : NSObject

@property (nonatomic, weak) id<GetLastestMessageDelegate> getLastestMessageDelegate;
@property (nonatomic, weak) id<GetRILLMessageListDelegate> getRillMessageListDelegate;
@property (nonatomic, weak) id<ReplyToRILLMessageDelegate> replyToRillMessageDelegate;
@property (nonatomic, weak) id<GetALLEnterpriseLastestMessageListDelegate> getAllEnterpriseLastestMessageListDelegate;
@property (nonatomic, weak) id<GetOneEnterpriseMessageListDelegate> getOneEnterpriseMessageListDelegate;
@property (nonatomic, weak) id<ReplyToOneEnterpriseMessageDelegate> replyToOneEnterpriseMessageDelegate;
//@property (nonatomic, weak) id<GetLastestRILLMessageDelegate> getLastestRillMessageDelegate;
//@property (nonatomic, weak) id<GetLastestEnterpriseMessageDelegate> getLastestEnterpriseMessageDelegate;

//获取最新消息
-(void)getLastestMessage;
-(void)getLastestRillMessage;
//获取rill的所有消息
-(void)getRillMessageList;
//想Rill发送消息
-(void)replyToRillMessage:(NSString*)content;
//获取最后的一条企业消息
-(void)getLastestEnterpriseMessage;
//获取所有企业的最后一条消息列表
-(void)getAllEnterpriseLastestMessageList;
//获取一个企业的所有消息
-(void)getOneEnterpriseMessage:(NSString*)enterpriseId;
//向企业发送消息
-(void)replyToOneEnterpriseMessage:(NSString*)enterpriseId content:(NSString*)content;

@end
