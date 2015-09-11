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
                                  [self.delegate loginSucceed:nil];
                              } failure:^(NSError *err) {
                                  NSLog(@"%@",[err debugDescription]);
                                  [self.delegate loginFailed:nil];
                              }];
}

@end
