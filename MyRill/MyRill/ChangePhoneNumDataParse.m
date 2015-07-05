//
//  ChangePhoneNumDataParse.m
//  MyRill
//
//  Created by Siyuan Wang on 15/7/5.
//
//

#import "ChangePhoneNumDataParse.h"
#import "AFHttpTool.h"

@implementation ChangePhoneNumDataParse

- (void)changePhoneNumWithNewPhoneNum:(NSString *)newphoneNum vertificationCode:(NSString *)code {
    [AFHttpTool changePhoneNum:newphoneNum
              verificationCode:code
                       success:^(id response) {
                           ;
                       } failure:^(NSError *err) {
                           ;
                       }];
}

@end
