//
//  UpdateProfessionDataParse.m
//  MyRill
//
//  Created by Siyuan Wang on 15/9/10.
//
//

#import "UpdateProfessionDataParse.h"
#import "AFHttpTool.h"
#import "DataParseDefine.h"
#import "ESProfession.h"

@implementation UpdateProfessionDataParse

- (void)updateProfessionWithId:(NSString *)professionId
                          name:(NSString *)name
                           url:(NSString *)url {
    [AFHttpTool updateProfessioinWithId:professionId
                                   name:name
                                    url:url
                                success:^(id response) {
                                    NSDictionary *responseDic = (NSDictionary *)response;
                                    NSNumber *errorCodeNum = responseDic[NETWORK_ERROR_CODE];
                                    
                                    if (errorCodeNum == nil || [errorCodeNum isEqual:[NSNull null]]) {
                                        [self.delegate updateProfessionFailure:@"请求有误!"];
                                        NSLog(@"请求有误！");
                                        return;
                                    }
                                    
                                    NSInteger errorCode = [errorCodeNum integerValue];
                                    if (errorCode == 0) {
                                        NSDictionary *modelDic = (NSDictionary *)responseDic[NETWORK_OK_DATA];
                                        ESProfession *profession = [[ESProfession alloc] initWithDic:modelDic];
                                        [self.delegate updateProfessionSuccess:profession];
                                    } else if (errorCode == 20) {
                                        [self.delegate updateProfessionFailure:responseDic[NETWORK_ERROR_MESSAGE]];
                                    } else {
                                        //empty
                                    }
                                } failure:^(NSError *err) {
                                    [self.delegate updateProfessionFailure:@"请求失败!"];
                                    NSLog(@"%@",[err debugDescription]);
                                }];
}

@end
