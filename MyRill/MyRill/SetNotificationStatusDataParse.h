//
//  SetNotificationStatusDataParse.h
//  MyRill
//
//  Created by Steve on 15/10/20.
//
//

#import <Foundation/Foundation.h>

@protocol SetNotificationStatusDelegate <NSObject>
-(void)setNotificationStatusSucceed:(NSDictionary*)notificationStatus;
-(void)setNotificationStatusFailed:(NSString*)errorMessage;
@end

@interface SetNotificationStatusDataParse : NSObject
@property (nonatomic, weak) id<SetNotificationStatusDelegate> delegate;
//获取通知状态
-(void)setNotificationStatus:(NSString*)menu notificationType:(BOOL)bType ;

@end
