//
//  ESEnterPriseRequestInfo.h
//  MyRill
//
//  Created by Steve on 15/8/1.
//
//

#import <Foundation/Foundation.h>

@class ESUserInfo;
@interface ESEnterPriseRequestInfo : NSObject
@property (nonatomic,strong) NSString* requestId;
@property (nonatomic,strong) NSString* receiverId;
@property (nonatomic,strong) NSString* enterPriseId;
@property (nonatomic,strong) ESUserInfo* sender;
@property (nonatomic,assign) BOOL bApproved;
@end
