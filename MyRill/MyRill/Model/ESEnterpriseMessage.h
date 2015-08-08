//
//  ESEnterpriseMessage.h
//  MyRill
//
//  Created by Steve on 15/8/8.
//
//

#import <Foundation/Foundation.h>
@class ESEnterpriseInfo;
@class ESUserInfo;

@interface ESEnterpriseMessage : NSObject
@property(nonatomic,strong) NSString* message_id;
@property(nonatomic,strong) ESEnterpriseInfo* send_enterprise;
@property(nonatomic,strong) ESUserInfo* receiver_userInfo;

@property(nonatomic,assign) BOOL bRead;
@property(nonatomic,assign) BOOL bSuggestion;
@property(nonatomic,strong) NSDate* message_time;

@end
