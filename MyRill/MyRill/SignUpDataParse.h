//
//  SignUpDataParse.h
//  MyRill
//
//  Created by Steve on 15/6/14.
//
//

#import <Foundation/Foundation.h>
@protocol SignUpDataDelegate <NSObject>

-(void)signUpSucceed;
-(void)signUpFailed;

@end


@interface SignUpDataParse : NSObject
//sign up
-(void) signUpWithPhoneNum:(NSString *)phoneNum  password:(NSString *)password verificationCode:(NSString*) verificationCode;

//get verificiation Code
-(void) getVerificationCode:(NSString *)phoneNum;


@end
