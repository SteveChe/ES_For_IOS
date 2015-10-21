//
//  GetVerificationCodeDataParse.m
//  MyRill
//
//  Created by Siyuan Wang on 15/9/23.
//
//

#import "GetVerificationCodeDataParse.h"
#import "AFHttpTool.h"
#import "DataParseDefine.h"

@implementation GetVerificationCodeDataParse

//get verificiation Code
-(void) getVerificationCode:(NSString *)phoneNum
{
    [AFHttpTool getVerificationCode:phoneNum
                            success:^(id response) {
                                NSDictionary *responseDic = (NSDictionary *)response;
//                                NSLog(@"%@",responseDic);
                                NSNumber *errorCodeNum = responseDic[NETWORK_ERROR_CODE];
                                
                                if (errorCodeNum == nil || [errorCodeNum isEqual:[NSNull null]]) {
                                    NSLog(@"请求有误！");
                                    [self.delegate getVerificationCodeFailed:@"验证码发送失败!"];
                                    return;
                                }
                                
                                NSInteger errorCode = [errorCodeNum integerValue];
                                if (errorCode == 0) {
                                    [self.delegate getVerificationCodeSucceed];
                                } else if (errorCode == 1) {
                                    [self.delegate getVerificationCodeFailed:@"手机号不合法!"];
                                } else if (errorCode == 2) {
                                    [self.delegate getVerificationCodeFailed:@"手机号已注册!"];
                                } else if (errorCode == 5) {
                                    [self.delegate getVerificationCodeFailed:@"验证码发送失败，请稍候重试!"];
                                } else {
                                    [self.delegate getVerificationCodeFailed:@"验证码发送失败!"];
                                }
                            }
                            failure:^(NSError *err) {
                                NSLog(@"%@",[err debugDescription]);
                                [self.delegate getVerificationCodeFailed:@"验证码发送失败!"];
                            }];
}

@end
