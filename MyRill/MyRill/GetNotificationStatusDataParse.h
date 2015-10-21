//
//  GetNotificationStatusDataParse.h
//  MyRill
//
//  Created by Steve on 15/10/20.
//
//

#import <Foundation/Foundation.h>
@protocol GetNotificationStatusDelegate <NSObject>
-(void)getNotificationStatusSucceed:(NSDictionary*)notificationStatus;
-(void)getNotificationStatusFailed:(NSString*)errorMessage;
@end

@interface GetNotificationStatusDataParse : NSObject
@property (nonatomic, weak) id<GetNotificationStatusDelegate> delegate;
//获取通知状态
-(void)getNotificationStatus;

@end
