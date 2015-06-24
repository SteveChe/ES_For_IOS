//
//  LoginDataParse.m
//  MyRill
//
//  Created by Siyuan Wang on 15/6/7.
//
//

#import "LoginDataParse.h"
#import "AFHttpTool.h"
#import "DataParseDefine.h"
#import "APService.h"
#import "NSString+MD5Addition.h"

@interface LoginDataParse()

@end

@implementation LoginDataParse

-(void) loginWithUserName:(NSString *) userName  password:(NSString *) password
{
    [AFHttpTool loginWithUserName:userName
                         password:password
                          success:^(id response) {
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
                                      [self setJpushAlias];
                                      if (self.delegate!= nil && [self.delegate respondsToSelector:@selector(loginSucceed)])
                                      {
                                          [self.delegate loginSucceed];
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
                                      if (self.delegate!= nil &&[self.delegate respondsToSelector:@selector(loginFailed:)])
                                      {
                                          [self.delegate loginFailed:errorMessage];
                                      }
                                  }
                                      break;
                              }
                          }
                          failure:^(NSError* err) {
                              if (self.delegate!= nil &&[self.delegate respondsToSelector:@selector(loginFailed:)])
                              {
                                  [self.delegate loginFailed:@"网络连接失败"];
                              }
                          }];

}

-(void) setJpushAlias
{
    NSData *cookiesdata = [[NSUserDefaults standardUserDefaults] objectForKey:@"sessionCookies"];
    if([cookiesdata length]) {
        NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData:cookiesdata];
        NSHTTPCookie *cookie;
        for (cookie in cookies) {
            if ([cookie.name  isEqual: @"sessionid"] )
            {
                NSLog(@"jpush alias = %@",cookie.value);

                [APService setAlias:[cookie.value stringFromMD5] callbackSelector:nil object:nil];
            }
        }
    }
}

-(void) getRongCloudToken
{
    [AFHttpTool getRongTokenSuccess:^(id response)
     {
         NSDictionary* reponseDic = (NSDictionary*)response;
         NSNumber* errorCodeNum = [reponseDic valueForKey:NETWORK_ERROR_CODE];
         if (errorCodeNum == nil || [errorCodeNum isEqual:[NSNull null]] )
         {
             return ;
         }
         if ([errorCodeNum integerValue] != 0)
         {
             return;
         }
         NSDictionary* dataDic = [reponseDic valueForKey:NETWORK_OK_DATA];
         if (dataDic == nil || [dataDic isEqual:[NSNull null]])
         {
             return;
         }
         
         NSString* rongCloudToken = [dataDic valueForKey:RONG_CLOUD_TOKEN];
         if (rongCloudToken == nil || [rongCloudToken isEqual:[NSNull null]]
             || [rongCloudToken length] <= 0)
         {
             return;
         }
         
         if (self.delegate!= nil && [self.delegate respondsToSelector:@selector(rongCloudToken:)])
         {
             [self.delegate rongCloudToken:rongCloudToken];
         }
         
     }
      failure:^(NSError* err)
     {
         
     }];
}



@end
