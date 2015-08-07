//
//  ESEnterpriseDetailInfo.h
//  MyRill
//
//  Created by Steve on 15/8/3.
//
//

#import <Foundation/Foundation.h>

@interface ESEnterpriseDetailInfo : NSObject
/** 企业ID */
@property(nonatomic, strong) NSString* enterpriseId;
/** 企业名*/
@property(nonatomic, strong) NSString* enterpriseName;
/** 企业名*/
@property(nonatomic, strong) NSString* enterpriseCategory;
/** 企业描述*/
@property(nonatomic, strong) NSString* enterpriseDescription;
/** 企业二维码*/
@property(nonatomic, strong) NSString* enterpriseQRCode;
/** 企业验证*/
@property(nonatomic, assign) BOOL bVerified;
/** 企业是否已经关注*/
@property(nonatomic, assign) BOOL bFollowed;
/** 企业是否已经关注*/
@property(nonatomic, assign) BOOL bCanFollowed;

@end
