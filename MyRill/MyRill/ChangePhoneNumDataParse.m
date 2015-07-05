//
//  ChangePhoneNumDataParse.m
//  MyRill
//
//  Created by Siyuan Wang on 15/7/5.
//
//

#import "ChangePhoneNumDataParse.h"
#import "AFHttpTool.h"
#import "DataParseDefine.h"

@implementation ChangePhoneNumDataParse

- (void)changePhoneNumWithNewPhoneNum:(NSString *)newphoneNum vertificationCode:(NSString *)code {
    [AFHttpTool changePhoneNum:newphoneNum
              verificationCode:code
                       success:^(id response) {
                           NSDictionary *responseDic = (NSDictionary *)response;
                           NSNumber *errorCodeNum = responseDic[NETWORK_ERROR_CODE];
                           
                           if (errorCodeNum == nil || [errorCodeNum isEqual:[NSNull null]]) {
                               [self.delegate changePhoneNUmFail:responseDic[NETWORK_ERROR_MESSAGE]];
                               return;
                           }
                           
                           NSInteger errorCode = [errorCodeNum integerValue];
                           
                           if (errorCode == 0) {
                               [self.delegate changePhoneNumSuccess];
                           } else {
                               [self.delegate changePhoneNUmFail:responseDic[NETWORK_ERROR_MESSAGE]];
                           }
                           
                       } failure:^(NSError *err) {
                           ;
                       }];
}

@end
