//
//  ESEnterpriseInfo.h
//  MyRill
//
//  Created by Steve on 15/7/19.
//
//

#import <Foundation/Foundation.h>

@interface ESEnterpriseInfo : NSObject
/** 企业ID */
@property(nonatomic, strong) NSString* enterpriseId;
/** 企业名 */
@property(nonatomic, strong) NSString* enterpriseName;
/** 企业分类 */
@property(nonatomic, strong) NSString* enterpriseCategory;
/** 企业描述 */
@property(nonatomic, strong) NSString* enterpriseDescription;
/** 企业二维码 */
@property(nonatomic, strong) NSString* enterpriseQRCode;
/** 企业验证码 */
@property(nonatomic, assign) BOOL bVerified;
/** 企业是否已经关注 */
@property(nonatomic, assign) BOOL bIsFollowed;
/** 企业头像URL **/
@property(nonatomic, strong) NSString* portraitUri;

//designed initilize
- (instancetype)initWithDic:(NSDictionary *)dic;

@end
