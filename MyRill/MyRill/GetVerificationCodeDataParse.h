//
//  GetVerificationCodeDataParse.h
//  MyRill
//
//  Created by Siyuan Wang on 15/9/23.
//
//

#import <Foundation/Foundation.h>

@protocol GetVerificationCodeDelegate <NSObject>

- (void)getVerificationCodeSucceed;
- (void)getVerificationCodeFailed:(NSString *)errorMessage;

@end

@interface GetVerificationCodeDataParse : NSObject

@property (nonatomic, weak) id<GetVerificationCodeDelegate> delegate;
//get verificiation Code
-(void) getVerificationCode:(NSString *)phoneNum;

@end
