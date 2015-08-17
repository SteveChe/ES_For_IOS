//
//  ChangeUserMsgDataParse.m
//  MyRill
//
//  Created by Siyuan Wang on 15/8/16.
//
//

#import "ChangeUserMsgDataParse.h"
#import "AFHttpTool.h"

@implementation ChangeUserMsgDataParse

- (void)changeUserMsgWithUserInfo:(ESUserDetailInfo *)userInfo {
    [AFHttpTool changeUserMsgWithUserInfo:userInfo
                                  success:^(id response) {
                                      NSDictionary *responseDic = (NSDictionary *)response;
                                      [self.delegate changeUserMsgSuccess];
                                  } failure:^(NSError *err) {
                                      NSLog(@"%@", [err debugDescription]);
                                  }];
}

@end
