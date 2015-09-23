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
-(void)signUpFailed:(NSString *)errorMessage;

@end

@interface SignUpDataParse : NSObject
@property (nonatomic,weak)id<SignUpDataDelegate>delegate;

//sign up
-(void) signUpWithPhoneNum:(NSString *)phoneNum name:(NSString*)name password:(NSString *)password verificationCode:(NSString*) verificationCode;

@end
