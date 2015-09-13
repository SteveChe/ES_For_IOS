//
//  ChangeUserMsgDataParse.m
//  MyRill
//
//  Created by Siyuan Wang on 15/8/16.
//
//

#import "ChangeUserMsgDataParse.h"
#import "AFHttpTool.h"
#import "DataParseDefine.h"
#import "ESUserDetailInfo.h"

@implementation ChangeUserMsgDataParse

- (void)changeUserMsgWithUserInfo:(ESUserDetailInfo *)userInfo {
    [AFHttpTool changeUserMsgWithUserInfo:userInfo
                                  success:^(id response) {
                                      NSDictionary *responseDic = (NSDictionary *)response;
                                      NSNumber* errorCodeNum = [responseDic valueForKey:NETWORK_ERROR_CODE];
                                      if (errorCodeNum == nil || [errorCodeNum isEqual:[NSNull null]] ) {
                                          return ;
                                      }
                                      
                                      int errorCode = [errorCodeNum intValue];
                                      switch (errorCode)
                                      {
                                          case 0:
                                              [self.delegate changeUserMsgSuccess:nil];
                                              break;
                                          default:
                                              [self.delegate changeUserMsgSuccess:responseDic[NETWORK_ERROR_MESSAGE]];
                                              break;
                                      }
                                      
                                  } failure:^(NSError *err) {
                                      NSLog(@"%@", [err debugDescription]);
                                      [self.delegate changeUserMsgFailed:@"请求失败,或者无效的邮箱地址!"];
                                  }];
}

@end
