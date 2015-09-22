//
//  BMCLoginDataParse.m
//  MyRill
//
//  Created by Siyuan Wang on 15/9/9.
//
//

#import "BMCLoginDataParse.h"
#import "AFHttpTool.h"

@implementation BMCLoginDataParse

- (void)loginBMCWithUserName:(NSString *)userName password:(NSString *)password {
    [AFHttpTool loginBMCWithUserName:userName
                            password:password
                              sucess:^(id response) {
                                  NSDictionary *responseDic = (NSDictionary *)response;
                                  if ([[responseDic allKeys] containsObject:@"error"]) {
                                      [self.delegate loginFailed:@"BMC登录失败!"];
                                      NSLog(@"请求有误!");
                                      return;
                                  }
                                  [self.delegate loginSucceed:nil];
                              } failure:^(NSError *err) {
                                  NSLog(@"%@",[err debugDescription]);
                                  [self.delegate loginFailed:@"无法连接服务器"];
                              }];
}

@end
