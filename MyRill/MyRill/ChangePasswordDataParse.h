//
//  ChangePasswordDataParse.h
//  MyRill
//
//  Created by Steve on 15/6/14.
//
//

#import <Foundation/Foundation.h>
@protocol ChangePasswordDataDelegate <NSObject>

-(void)changePasswordSucceed;
-(void)changePasswordFailed;

@end

@interface ChangePasswordDataParse : NSObject
//changePassword
-(void) changePassword:(NSString *)oldPassword  newPassword:(NSString *)newPassword;

@end
