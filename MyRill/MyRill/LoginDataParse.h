//
//  LoginDataParse.h
//  MyRill
//
//  Created by Siyuan Wang on 15/6/7.
//
//

#import <Foundation/Foundation.h>

@protocol LoginDataDelegate <NSObject>

-(void)loginSucceed;
-(void)loninFailed;

@end

@interface LoginDataParse : NSObject

//login
-(void) loginWithUserName:(NSString *) userName  password:(NSString *) password;

@end
