//
//  ResetPwdDataParse.m
//  MyRill
//
//  Created by Siyuan Wang on 15/9/29.
//
//

#import "ResetPwdDataParse.h"
#import "AFHttpTool.h"
#import "DataParseDefine.h"

@implementation ResetPwdDataParse

- (void)resetPwdWithPhoneNum:(NSString *)phoneNum
                    password:(NSString *)password
            verificationCode:(NSString *)verificationCode {
    [AFHttpTool resetPwdWithPhoneNum:phoneNum
                            password:password
                    verificationCode:verificationCode
                             success:^(id response) {
                                 NSDictionary *responseDic = (NSDictionary *)response;
                                 NSLog(@"%@",responseDic);
                                 NSNumber *errorCodeNum = responseDic[NETWORK_ERROR_CODE];
                                 
                                 if (errorCodeNum == nil || [errorCodeNum isEqual:[NSNull null]]) {
                                     NSLog(@"请求有误！");
                                     [self.delegate resetPwdFailed:@"验证码发送失败!"];
                                     return;
                                 }
                                 
                                 NSInteger errorCode = [errorCodeNum integerValue];
                                 if (errorCode == 0) {
                                     [self.delegate resetPwdSucceed];
                                 } else {
                                     [self.delegate resetPwdFailed:@"密码重置失败!"];
                                 }
                             } failure:^(NSError *err) {
                                 NSLog(@"%@",[err debugDescription]);
                                 [self.delegate resetPwdFailed:@"密码重置失败!"];
                             }];
}

@end
