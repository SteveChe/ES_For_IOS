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
@property (nonatomic,assign)id<LoginDataDelegate>delegate;

@end

@implementation LoginDataParse

-(void) loginWithUserName:(NSString *) userName  password:(NSString *) password
{
    [AFHttpTool loginWithUserName:userName
                         password:password
                          success:^(id response) {
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
                              
                              NSLog(@"%@",errorMessage);
                              
                          }
                          failure:^(NSError* err) {
                              if ([self.delegate respondsToSelector:@selector(loninFailed)])
                              {
                                  [self.delegate loninFailed];
                              }

                          }];
}


@end
