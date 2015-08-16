//
//  GetEnterpriseDetailDataParse.m
//  MyRill
//
//  Created by Steve on 15/8/3.
//
//

#import "GetEnterpriseDetailDataParse.h"
#import "AFHttpTool.h"
#import "DataParseDefine.h"
#import "ESEnterpriseDetailInfo.h"

@implementation GetEnterpriseDetailDataParse
-(void) getEnterpriseDetailInfo:(NSString*)enterpriseId{
    [AFHttpTool getEnterpriseDetail:enterpriseId success:^(id response)
     {
         NSDictionary* reponseDic = (NSDictionary*)response;
         NSNumber* errorCodeNum = [reponseDic valueForKey:NETWORK_ERROR_CODE];
         if (errorCodeNum == nil || [errorCodeNum isEqual:[NSNull null]] )
         {
             return ;
         }
         int errorCode = [errorCodeNum intValue];
         switch (errorCode)
         {
             case 0:
             {
                 NSDictionary* temDic = [reponseDic valueForKey:NETWORK_OK_DATA];
                 if (temDic == nil || [temDic isEqual:[NSNull null]])
                 {
                     break;
                 }
                 ESEnterpriseDetailInfo* enterpriseDetailInfo = [[ESEnterpriseDetailInfo alloc] init];
                 NSNumber* enterPriseIdNum = [temDic valueForKey:@"id"];
                 if (enterPriseIdNum!=nil && ![enterPriseIdNum isEqual:[NSNull null]]) {
                     enterpriseDetailInfo.enterpriseId = [NSString stringWithFormat:@"%d",[enterPriseIdNum intValue]];
                 }
                 
                 NSString* enterPriseName = [temDic valueForKey:@"name"];
                 if (enterPriseName!=nil && ![enterPriseName isEqual:[NSNull null]] && [enterPriseName length] > 0) {
                     enterpriseDetailInfo.enterpriseName = enterPriseName;
                 }
                 
                 NSString* enterPriseCategory = [temDic valueForKey:@"category"];
                 if (enterPriseCategory!=nil && ![enterPriseCategory isEqual:[NSNull null]] && [enterPriseCategory length]>0) {
                     enterpriseDetailInfo.enterpriseCategory = enterPriseCategory;
                 }
                 
                 NSString* enterPriseDes = [temDic valueForKey:@"description"];
                 if(enterPriseDes!=nil && ![enterPriseDes isEqual:[NSNull null] ] && [enterPriseDes length] >0 )
                 {
                     enterpriseDetailInfo.enterpriseDescription = enterPriseDes;
                 }
                 
                 NSString* enterPriseQRCode = [temDic valueForKey:@"qrcode"];
                 if(enterPriseQRCode!=nil && ![enterPriseQRCode isEqual:[NSNull null]] && [enterPriseQRCode length] >0 ){
                     enterpriseDetailInfo.enterpriseQRCode = enterPriseQRCode;
                 }
                 
                 NSNumber* enterPriseVerified = [temDic valueForKey:@"verified"];
                 if (enterPriseVerified!=nil && ![enterPriseVerified isEqual:[NSNull null]]) {
                     enterpriseDetailInfo.bVerified = [enterPriseVerified boolValue];
                 }
                 
                 NSNumber* enterPriseFollowed = [temDic valueForKey:@"is_following"];
                 if (enterPriseFollowed!=nil && ![enterPriseFollowed isEqual:[NSNull null]]) {
                     enterpriseDetailInfo.bFollowed = [enterPriseFollowed boolValue];
                 }

                 NSNumber* enterPriseCanFollowed = [temDic valueForKey:@"can_follow"];
                 if (enterPriseCanFollowed!=nil && ![enterPriseCanFollowed isEqual:[NSNull null]]) {
                     enterpriseDetailInfo.bCanFollowed = [enterPriseCanFollowed boolValue];
                 }

                 NSString* enterprisePortraitUrl = [temDic objectForKey:@"avatar"];
                 if (enterprisePortraitUrl != nil && ![enterprisePortraitUrl isEqual:[NSNull null]] && [enterprisePortraitUrl length] >0 )
                 {
                     enterpriseDetailInfo.portraitUri = enterprisePortraitUrl;
                 }

                 if (self.delegate!= nil &&[self.delegate respondsToSelector:@selector(getEnterpriseDetailSucceed:)])
                 {
                     [self.delegate getEnterpriseDetailSucceed:enterpriseDetailInfo];
                 }
                 
             }
                 break;
             default:
             {
                 NSString* errorMessage = [reponseDic valueForKey:NETWORK_ERROR_MESSAGE];
                 if(errorMessage==nil)
                     return;
                 
                 errorMessage= [errorMessage stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                 NSLog(@"%@",errorMessage);
                 if (self.delegate!= nil &&[self.delegate respondsToSelector:@selector(getEnterpriseDetailFailed:)])
                 {
                     [self.delegate getEnterpriseDetailFailed:errorMessage];
                 }
             }
                 break;
         }
     }failure:^(NSError* err)
     {
         NSLog(@"%@",err);
         if (self.delegate!= nil &&[self.delegate respondsToSelector:@selector(getEnterpriseDetailFailed:)])
         {
             [self.delegate getEnterpriseDetailFailed:@"网络请求失败"];
         }
     }];

}

@end
