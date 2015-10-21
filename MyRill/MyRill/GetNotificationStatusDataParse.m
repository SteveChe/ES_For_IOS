//
//  GetNotificationStatusDataParse.m
//  MyRill
//
//  Created by Steve on 15/10/20.
//
//

#import "GetNotificationStatusDataParse.h"
#import "AFHttpTool.h"
#import "DataParseDefine.h"
#import "ColorHandler.h"

@implementation GetNotificationStatusDataParse
//获取
-(void)getNotificationStatus
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
                 NSMutableDictionary* notificationDic = [NSMutableDictionary dictionary];

                 if ([ColorHandler isNullOrNilNumber:notificationDic[@"assignment"]]) {
                     [notificationDic setObject:[NSNumber numberWithBool:NO] forKey:@"assignment"];
                 } else {
                     [notificationDic setObject:notificationDic[@"assignment"] forKey:@"assignment"];
                 }
                 
                 if ([ColorHandler isNullOrNilNumber:notificationDic[@"subscription"]]) {
                     [notificationDic setObject:[NSNumber numberWithBool:NO] forKey:@"subscription"];
                 } else {
                     [notificationDic setObject:notificationDic[@"subscription"] forKey:@"subscription"];
                 }

                 if ([ColorHandler isNullOrNilNumber:notificationDic[@"contact"]]) {
                     [notificationDic setObject:[NSNumber numberWithBool:NO] forKey:@"contact"];
                 } else {
                     [notificationDic setObject:notificationDic[@"contact"] forKey:@"contact"];
                 }

                 if ([ColorHandler isNullOrNilNumber:notificationDic[@"profession"]]) {
                     [notificationDic setObject:[NSNumber numberWithBool:NO] forKey:@"profession"];
                 } else {
                     [notificationDic setObject:notificationDic[@"profession"] forKey:@"profession"];
                 }
                 
                 if (self.delegate!= nil &&[self.delegate respondsToSelector:@selector(getNotificationStatusSucceed:)])
                 {
                     [self.delegate getNotificationStatusSucceed:notificationDic];
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
                 if (self.delegate!= nil &&[self.delegate respondsToSelector:@selector(getNotificationStatusFailed:)])
                 {
                     [self.delegate getNotificationStatusFailed:errorMessage];
                 }
                 
             }
                 break;
         }
     }failure:^(NSError* err)
     {
         NSLog(@"%@",err);
         if (self.delegate!= nil &&[self.delegate respondsToSelector:@selector(getNotificationStatusFailed:)])
         {
             [self.delegate getNotificationStatusFailed:@"网络请求失败"];
         }
     }];

}

@end
