//
//  ChangePwdDataParse.h
//  MyRill
//
//  Created by Steve on 15/6/14.
//
//

#import <Foundation/Foundation.h>
@protocol ChangePwdDataDelegate <NSObject>

-(void)changePasswordSucceed;
-(void)changePasswordFailed:(NSString *)errorMsg;

@end

@interface ChangePwdDataParse : NSObject

@property (nonatomic,assign) id<ChangePwdDataDelegate> delegate;
//changePassword
- (void)changePassword:(NSString *)oldPassword  newPassword:(NSString *)newPassword;

@end
