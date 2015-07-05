//
//  SignOutDataParse.m
//  MyRill
//
//  Created by Siyuan Wang on 15/7/2.
//
//

#import "SignOutDataParse.h"
#import "AFHttpTool.h"
#import "DataParseDefine.h"

@implementation SignOutDataParse

- (void)logout {
    [AFHttpTool signOutSuccess:^(id response) {
        NSDictionary *resultDic = (NSDictionary *)response;
        NSNumber *errorCodeNum = resultDic[NETWORK_ERROR_CODE];
        if (errorCodeNum == nil || [errorCodeNum isEqual:[NSNull null]]) {
            return;
        }
        
        NSInteger errorCode = [errorCodeNum integerValue];
        
        if (errorCode == 0) {
            if (self.delegate != nil && [self.delegate respondsToSelector:@selector(logoutSuccess)]) {
                [self.delegate logoutSuccess];
            }
        } else {
            
        }
        
        NSLog(@"!!!!!! %@",resultDic[NETWORK_ERROR_MESSAGE]);
    } failure:^(NSError *err) {
        ;
    }];
}

@end
