//
//  SetNotificationStatusDataParse.m
//  MyRill
//
//  Created by Steve on 15/10/20.
//
//

#import "SetNotificationStatusDataParse.h"
#import "AFHttpTool.h"
#import "DataParseDefine.h"
#import "ColorHandler.h"

@implementation SetNotificationStatusDataParse
//获取通知状态
-(void)setNotificationStatus:(NSString*)menu notificationType:(BOOL)bType
{
    [AFHttpTool setNotificationStatus:menu notificationType:bType sucess:^(id response)
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
                
                if ([ColorHandler isNullOrNilNumber:temDic[@"assignment"]]) {
                    [notificationDic setObject:[NSNumber numberWithBool:NO] forKey:@"assignment"];
                } else {
                    [notificationDic setObject:temDic[@"assignment"] forKey:@"assignment"];
                }
                
                if ([ColorHandler isNullOrNilNumber:temDic[@"subscription"]]) {
                    [notificationDic setObject:[NSNumber numberWithBool:NO] forKey:@"subscription"];
                } else {
                    [notificationDic setObject:temDic[@"subscription"] forKey:@"subscription"];
                }
                
                if ([ColorHandler isNullOrNilNumber:temDic[@"contact"]]) {
                    [notificationDic setObject:[NSNumber numberWithBool:NO] forKey:@"contact"];
                } else {
                    [notificationDic setObject:temDic[@"contact"] forKey:@"contact"];
                }
                
                if ([ColorHandler isNullOrNilNumber:temDic[@"profession"]]) {
                    [notificationDic setObject:[NSNumber numberWithBool:NO] forKey:@"profession"];
                } else {
                    [notificationDic setObject:temDic[@"profession"] forKey:@"profession"];
                }
                
                if (self.delegate!= nil &&[self.delegate respondsToSelector:@selector(setNotificationStatusSucceed:)])
                {
                    [self.delegate setNotificationStatusSucceed:notificationDic];
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
                if (self.delegate!= nil &&[self.delegate respondsToSelector:@selector(setNotificationStatusFailed:)])
                {
                    [self.delegate setNotificationStatusFailed:errorMessage];
                }
                
            }
                break;
        }
    }failure:^(NSError* err)
    {
        NSLog(@"%@",err);
        if (self.delegate!= nil &&[self.delegate respondsToSelector:@selector(setNotificationStatusFailed:)])
        {
            [self.delegate setNotificationStatusFailed:@"网络请求失败"];
        }
    }];
}
@end
