//
//  AddProfessionDataParse.m
//  MyRill
//
//  Created by Siyuan Wang on 15/9/9.
//
//

#import "AddProfessionDataParse.h"
#import "AFHttpTool.h"
#import "DataParseDefine.h"
#import "ESProfession.h"

@implementation AddProfessionDataParse

- (void)addProfessionWithName:(NSString *)name url:(NSString *)url {
    [AFHttpTool addProfessionWithName:name
                                  url:url
                              success:^(id response) {
                                  NSDictionary *responseDic = (NSDictionary *)response;
                                  NSNumber *errorCodeNum = responseDic[NETWORK_ERROR_CODE];
                                  
                                  if (errorCodeNum == nil || [errorCodeNum isEqual:[NSNull null]]) {
                                      NSLog(@"请求有误！");
                                      return;
                                  }
                                  
                                  NSInteger errorCode = [errorCodeNum integerValue];
                                  if (errorCode == 0) {
                                      NSDictionary *modelDic = (NSDictionary *)responseDic[NETWORK_OK_DATA];
                                      ESProfession *profession = [[ESProfession alloc] initWithDic:modelDic];
                                      [self.delegate addProfessionOperationSuccess:profession];
                                  }
                              }
                              failure:^(NSError *error) {
                                  NSLog(@"%@",[error debugDescription]);
                                  [self.delegate addProfessionOperationFailure:@"添加失败"];
                              }];
}

@end
