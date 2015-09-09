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
                              } failure:^(NSError *err) {
                                  NSLog(@"%@",[err debugDescription]);
                              }];
}

@end
