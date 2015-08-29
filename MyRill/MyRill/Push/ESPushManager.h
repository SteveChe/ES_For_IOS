//
//  ESPushManager.h
//  MyRill
//
//  Created by Steve on 15/8/29.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PushDefine.h"

@interface ESPushManager : NSObject

+(void)parsePushJsonDic:(NSDictionary*)pushDic applicationState:(UIApplicationState) applicationState;

+(void)postNotificationMessage:(NSString*)notificationMessage;

+(void)changeToPageWithType:(E_PUSH_CATEGORY_TYPE)categoryType;

@end
