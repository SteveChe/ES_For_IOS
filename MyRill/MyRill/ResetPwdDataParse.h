//
//  ResetPwdDataParse.h
//  MyRill
//
//  Created by Siyuan Wang on 15/9/29.
//
//

#import <Foundation/Foundation.h>

@protocol ResetPwdDelegate <NSObject>

- (void)resetPwdSucceed;
- (void)resetPwdFailed:(NSString *)errorMessage;

@end

@interface ResetPwdDataParse : NSObject

@property (nonatomic, weak) id<ResetPwdDelegate> delegate;

- (void)resetPwdWithPhoneNum:(NSString *)phoneNum
                    password:(NSString *)password
            verificationCode:(NSString *)verificationCode;

@end
