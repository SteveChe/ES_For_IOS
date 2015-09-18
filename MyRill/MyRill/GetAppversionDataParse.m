//
//  GetAppversionDataParse.m
//  MyRill
//
//  Created by Steve on 15/9/18.
//
//

#import "GetAppversionDataParse.h"
#import "AFHttpTool.h"
#import "DataParseDefine.h"

@implementation GetAppversionDataParse

-(void)getAppVersion
{
    [AFHttpTool getAppVersionSucess:^(id response)
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
                 NSString* appVersionString = [temDic objectForKey:@"version"];
                 if (appVersionString == nil || [appVersionString isEqual:[NSNull null]] || [appVersionString length] <= 0)
                 {
                     break;
                 }
                 if (self.delegate!= nil &&[self.delegate respondsToSelector:@selector(getAppVersionSucceed:)])
                 {
                     [self.delegate getAppVersionSucceed:appVersionString];
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
                 if (self.delegate!= nil &&[self.delegate respondsToSelector:@selector(getAppVersionFailed:)])
                 {
                     [self.delegate getAppVersionFailed:errorMessage];
                 }

             }
                 break;
         }
     }failure:^(NSError* err)
     {
         NSLog(@"%@",err);
         if (self.delegate!= nil &&[self.delegate respondsToSelector:@selector(getAppVersionFailed:)])
         {
             [self.delegate getAppVersionFailed:@"网络请求失败"];
         }
     }];

}

@end
