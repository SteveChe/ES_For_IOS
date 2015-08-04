//
//  GetEnterpriseDetailDataParse.h
//  MyRill
//
//  Created by Steve on 15/8/3.
//
//

#import <Foundation/Foundation.h>
@class ESEnterpriseDetailInfo;
@protocol EnterpriseDetailInfoDataDelegate <NSObject>
- (void)getEnterpriseDetailSucceed:(ESEnterpriseDetailInfo *)enterpriseDetailInfo;
- (void)getEnterpriseDetailFailed:(NSString*)errorMessage;
@end

@interface GetEnterpriseDetailDataParse : NSObject
@property (nonatomic, weak) id<EnterpriseDetailInfoDataDelegate> delegate;

//获取企业的详细信息
-(void) getEnterpriseDetailInfo:(NSString*)enterpriseId ;
@end
