//
//  DeleteProfessionDataParse.m
//  MyRill
//
//  Created by Siyuan Wang on 15/9/10.
//
//

#import "DeleteProfessionDataParse.h"
#import "AFHttpTool.h"
#import "DataParseDefine.h"

@implementation DeleteProfessionDataParse

- (void)deleteProfessionWithId:(NSString *)professionId {
    [AFHttpTool deleteProfessionWithId:professionId
                               success:^(id response) {
                                   NSDictionary *responseDic = (NSDictionary *)response;
                                   NSNumber *errorCodeNum = responseDic[NETWORK_ERROR_CODE];
                                   
                                   if (errorCodeNum == nil || [errorCodeNum isEqual:[NSNull null]]) {
                                       [self.delegate deleteProfessionFailure:@"请求有误!"];
                                       NSLog(@"请求有误！");
                                       return;
                                   }
                                   
                                   NSInteger errorCode = [errorCodeNum integerValue];
                                   if (errorCode == 0) {
                                       [self.delegate deleteProfessionSuccess];
                                   }
                               }
                               failure:^(NSError *error) {
                                   [self.delegate deleteProfessionFailure:@"请求失败!"];
                                   NSLog(@"%@",[error debugDescription]);
                               }];
}

@end
