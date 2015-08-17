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
                                      if (errorCodeNum == nil || [errorCodeNum isEqual:[NSNull null]] )
                                      {
                                          return ;
                                      }
                                      
                                      NSDictionary *dataDic = responseDic[NETWORK_OK_DATA];
                                      ESUserDetailInfo *userInfo = [[ESUserDetailInfo alloc] init];
                                      userInfo.contactDescription = dataDic[@"description"];
                                      userInfo.position = dataDic[@"position"];
                                      userInfo.userName = dataDic[@"name"];
                                      [self.delegate changeUserMsgSuccess:userInfo];
                                  } failure:^(NSError *err) {
                                      NSLog(@"%@", [err debugDescription]);
                                  }];
}

@end
