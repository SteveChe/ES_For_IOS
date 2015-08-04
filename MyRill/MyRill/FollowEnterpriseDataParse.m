//
//  FollowEnterpriseDataParse.m
//  MyRill
//
//  Created by Steve on 15/8/3.
//
//

#import "FollowEnterpriseDataParse.h"
#import "AFHttpTool.h"
#import "DataParseDefine.h"

@implementation FollowEnterpriseDataParse
-(void)followEnterPriseWithEnterpriseId:(NSString*)enterpriseId
{
    [AFHttpTool followEnterPriseId:enterpriseId action:@"follow" success:^(id response)
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
                 if (self.followEnterPriseDelegate!= nil &&[self.followEnterPriseDelegate respondsToSelector:@selector(followEnterpriseSucceed)])
                 {
                     [self.followEnterPriseDelegate followEnterpriseSucceed];
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
                 if (self.followEnterPriseDelegate!= nil &&[self.followEnterPriseDelegate respondsToSelector:@selector(followEnterpriseFailed:)])
                 {
                     [self.followEnterPriseDelegate followEnterpriseFailed:errorMessage];
                 }
             }
                 break;
         }
     }failure:^(NSError* err)
     {
         NSLog(@"%@",err);
         if (self.followEnterPriseDelegate!= nil &&[self.followEnterPriseDelegate respondsToSelector:@selector(followEnterpriseFailed:)])
         {
             [self.followEnterPriseDelegate followEnterpriseFailed:@"网络请求失败"];
         }
     }];

}
-(void)unfollowEnterPriseWithEnterpriseId:(NSString*)enterpriseId
{
    [AFHttpTool followEnterPriseId:enterpriseId action:@"unfollow" success:^(id response)
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
                 if (self.unfollowEnterPriseDelegate!= nil &&[self.unfollowEnterPriseDelegate respondsToSelector:@selector(unFollowEnterpriseSucceed)])
                 {
                     [self.unfollowEnterPriseDelegate unFollowEnterpriseSucceed];
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
                 if (self.unfollowEnterPriseDelegate!= nil &&[self.unfollowEnterPriseDelegate respondsToSelector:@selector(unFollowEnterpriseFailed:)])
                 {
                     [self.unfollowEnterPriseDelegate unFollowEnterpriseFailed:errorMessage];
                 }
             }
                 break;
         }
     }failure:^(NSError* err)
     {
         NSLog(@"%@",err);
         if (self.unfollowEnterPriseDelegate!= nil &&[self.unfollowEnterPriseDelegate respondsToSelector:@selector(followEnterpriseFailed:)])
         {
             [self.unfollowEnterPriseDelegate unFollowEnterpriseFailed:@"网络请求失败"];
         }
     }];
}

@end
