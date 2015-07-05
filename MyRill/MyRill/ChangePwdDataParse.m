//
//  ChangePwdDataParse.m
//  MyRill
//
//  Created by Steve on 15/6/14.
//
//

#import "ChangePwdDataParse.h"
#import "AFHttpTool.h"
#import "DataParseDefine.h"

@implementation ChangePwdDataParse
-(void) changePassword:(NSString *)oldPassword  newPassword:(NSString *)newPassword
{
    [AFHttpTool changePassword:oldPassword newPassword:newPassword
                       success:^(id response)
     {
         NSDictionary* reponseDic = (NSDictionary*)response;
         NSNumber* errorCodeNum = [reponseDic valueForKey:NETWORK_ERROR_CODE];
         if (errorCodeNum == nil || [errorCodeNum isEqual:[NSNull null]] )
         {
             NSDictionary *detailDic = (NSDictionary *)detailDic[NETWORK_ERROR_DETAIL];
             NSString *detailMsg = detailDic[@"new_password"];
             [self.delegate changePasswordFailed:detailMsg];
             
             return ;
         }
         
         int errorCode = [errorCodeNum intValue];
         switch (errorCode)
         {
             case 0:
             {
                 if ([self.delegate respondsToSelector:@selector(changePasswordSucceed)])
                 {
                     [self.delegate changePasswordSucceed];
                 }
                 
             }
                 break;
             case 4:
             {
                 if ([self.delegate respondsToSelector:@selector(changePasswordFailed:)])
                 {
                     [self.delegate changePasswordFailed:@"原密码输入错误!"];
                 }
                 
             }
                 break;
                 
             default:
                 break;
         }
         NSString* errorMessage = [reponseDic valueForKey:NETWORK_ERROR_MESSAGE];
         if(errorMessage==nil)
             return;
         
         errorMessage= [errorMessage stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
         NSLog(@"%@",errorMessage);
         
     }
                       failure:^(NSError* err) {
                           if ([self.delegate respondsToSelector:@selector(changePasswordFailed)])
                           {
                               [self.delegate changePasswordFailed:nil];
                           }
                           
                       }];

}

@end
