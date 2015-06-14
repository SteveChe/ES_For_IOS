//
//  CustomShowMessage.h
//  MyRill
//
//  Created by Steve on 15/6/14.
//
//

#import <UIKit/UIKit.h>
typedef enum
{
    APP_SEARCH_REQ_WAITING_INDICATOR = 0,
    LOAD_PAGE_REQ_WAITING_INDICATOR = 1,
    VERSION_UPDATE_WAITING_INDICATOR = 6,
    SYNCDATA_REQ_WAITING_INDICATOR = 7,
    SUBMIT_REQ_WAITING_INDICATOR = 8,
    
} IndicatorTYPE;


typedef enum
{
    SHARE_POSITION_DEFAULT_RESPONSE_WAITING_INDICATOR  = 20,
    SHARE_POSITION_DEFAULT_REQUEST_WAITING_INDICATOR   = 21,
    SHARE_POSITION_CREATING_ACTIVITY_WAITING_INDICATOR = 22,
    SHARE_POSITION_MODIFY_ACTIVITY_WAITING_INDICATOR,
    SHARE_POSITION_MODIFY_NICKNAME_WAITING_INDICATOR,
    SHARE_POSITION_RESPONSE_ACTIVITY_WAITING_INDICATOR,
    SHARE_POSITION_DEFAULT_WAITING_INDICATOR,
    
}SharePositionIndicatorTYPE;

typedef void(^CustomCancel)();

@interface CustomShowMessage:NSObject

+(CustomShowMessage*)getInstance;

+(void)releaseInstance;

-(void)showNotificationMessageAtMain:(NSString *)messageTitle;

-(void)showNotificationMessage:(NSString *)messageTitle;

-(void)showNotificationMessage:(NSString *)messageTitle withDuration:(NSTimeInterval)duration;

-(void)showNotificationMessage:(NSString *)messageTitle WithBgImg:(NSString *)imageName AndFrame:(CGRect)frame withAnimation:(bool)needAnimation;

-(void)showNotificationMessage:(NSString *)messageTitle WithBgImg:(NSString *)imageName AndFrame:(CGRect)frame withAnimation:(bool)needAnimation withDuration:(NSTimeInterval)duration;

- (void)showWaitingIndicator:(IndicatorTYPE)type;

- (void)showWaitingIndicator:(IndicatorTYPE)type withCancelMethod:(CustomCancel)cancel;

- (void)showWaitingIndicatorWithoutBackground:(IndicatorTYPE)type;

- (bool)getWaintingIndicatorStatus;//等待界面还在，返回true

- (void)hideWaitingIndicator;

- (void)showShareLocationWaitingIndicator:(SharePositionIndicatorTYPE)type;

- (void)showShareLocationWaitingIndicator:(SharePositionIndicatorTYPE)type withCancelMethod:(CustomCancel)cancel;

- (void)showShareLocationWaitingIndicatorWithoutBackground:(SharePositionIndicatorTYPE)type;

@end

