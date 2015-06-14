//
//  ChangePasswordDataParse.m
//  MyRill
//
//  Created by Steve on 15/6/14.
//
//

#import "ChangePasswordDataParse.h"
#import "AFHttpTool.h"
#import "DataParseDefine.h"
@interface ChangePasswordDataParse()
@property (nonatomic,assign)id<ChangePasswordDataDelegate>delegate;

@end
@implementation ChangePasswordDataParse
-(void) changePassword:(NSString *)oldPassword  newPassword:(NSString *)newPassword
{
    [AFHttpTool changePassword:oldPassword newPassword:newPassword
                       success:^(id response)
     {
         NSDictionary* reponseDic = (NSDictionary*)response;
         NSNumber* errorCodeNum = [reponseDic valueForKey:NETWORK_ERROR_CODE];
         if (errorCodeNum == nil)
         {
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
                               [self.delegate changePasswordFailed];
                           }
                           
                       }];

}

@end
