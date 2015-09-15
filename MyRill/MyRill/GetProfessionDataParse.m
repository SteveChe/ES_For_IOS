//
//  GetProfessionDataParse.m
//  MyRill
//
//  Created by Siyuan Wang on 15/9/15.
//
//

#import "GetProfessionDataParse.h"
#import "AFHttpTool.h"
#import "DataParseDefine.h"
#import "ESProfession.h"

@implementation GetProfessionDataParse

- (void)getProfessionWithProfessionID:(NSString *)professionID {
    [AFHttpTool getProfessionWithProfessionID:professionID
                                      success:^(id response) {
                                          NSDictionary *responseDic = (NSDictionary *)response;
                                          NSNumber *errorCodeNum = responseDic[NETWORK_ERROR_CODE];
                                          
                                          if (errorCodeNum == nil || [errorCodeNum isEqual:[NSNull null]]) {
                                              NSLog(@"请求有误！");
                                              [self.delegate getProfessionFailure:@"请求有误!获取业务失败！"];
                                              return;
                                          }
                                          
                                          NSInteger errorCode = [errorCodeNum integerValue];
                                          if (errorCode == 0) {
                                              NSDictionary *dataDic = (NSDictionary *)responseDic[NETWORK_OK_DATA];
                                              
                                              ESProfession *profession = [[ESProfession alloc] initWithDic:dataDic];
                                              [self.delegate getProfessionSuccess:profession];
                                          }
                                      } failure:^(NSError *err) {
                                          NSLog(@"%@",[err debugDescription]);
                                          [self.delegate getProfessionFailure:@"请求失败!获取业务失败!"];
                                      }];
}
@end
