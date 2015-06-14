//
//  SignUpDataParse.m
//  MyRill
//
//  Created by Steve on 15/6/14.
//
//

#import "SignUpDataParse.h"
#import "AFHttpTool.h"

@interface SignUpDataParse()
@property (nonatomic,assign)id<SignUpDataDelegate>delegate;

@end
@implementation SignUpDataParse
-(void) signUpWithPhoneNum:(NSString *)phoneNum  password:(NSString *)password verificationCode:(NSString*) verificationCode
{
    [AFHttpTool signUpWithPhoneNum:phoneNum password:password verificationCode:verificationCode success:^(id response)
     {
         
     }
                           failure:^(NSError* err)
     {
         
     }];
}

//get verificiation Code
-(void) getVerificationCode:(NSString *)phoneNum
{
    [AFHttpTool getVerificationCode:phoneNum];
}
@end
