//
//  SignUpDataParse.m
//  MyRill
//
//  Created by Steve on 15/6/14.
//
//

#import "SignUpDataParse.h"
#import "AFHttpTool.h"
#import "DataParseDefine.h"

@interface SignUpDataParse()

@end
@implementation SignUpDataParse
-(void) signUpWithPhoneNum:(NSString *)phoneNum name:(NSString*)name password:(NSString *)password verificationCode:(NSString*) verificationCode
{
    [AFHttpTool signUpWithPhoneNum:phoneNum userName:name password:password verificationCode:verificationCode success:^(id response)
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
                 if (self.delegate!= nil && [self.delegate respondsToSelector:@selector(signUpSucceed)])
                 {
                     [self.delegate signUpSucceed];
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
                 if (self.delegate!= nil &&[self.delegate respondsToSelector:@selector(signUpFailed:)])
                 {
                     [self.delegate signUpFailed:errorMessage];
                 }
             }
                 break;
         }
     }
       failure:^(NSError* err) {
           if (self.delegate!= nil &&[self.delegate respondsToSelector:@selector(signUpFailed:)])
           {
               [self.delegate signUpFailed:@"网络连接失败"];
           }
    }];

}

@end
