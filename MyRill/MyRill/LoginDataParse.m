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
                                      if ([self.delegate respondsToSelector:@selector(loginSucceed)])
                                      {
                                          [self.delegate loginSucceed];
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
                              if ([self.delegate respondsToSelector:@selector(loginFailed)])
                              {
                                  [self.delegate loginFailed];
                              }
                          }];

}


@end
