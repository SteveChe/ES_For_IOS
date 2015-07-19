//
//  EnterpriseInfoDataSource.h
//  MyRill
//
//  Created by Steve on 15/7/19.
//
//

#import <Foundation/Foundation.h>
@class ESEnterpriseInfo;

@interface EnterpriseInfoDataSource : NSObject
+(EnterpriseInfoDataSource *) shareInstance;
//从表中获取用户信息
-(ESEnterpriseInfo*) getEnterpriseById:(NSString*)enterpriseId;

@end
