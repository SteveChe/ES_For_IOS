//
//  LoginDataParse.h
//  MyRill
//
//  Created by Siyuan Wang on 15/6/7.
//
//

#import <Foundation/Foundation.h>
@class ESUserInfo;

@protocol LoginDataDelegate <NSObject>

-(void)loginSucceed:(ESUserInfo *)userInfo;
-(void)loginFailed:(NSString*)errorMessage;
-(void)rongCloudToken:(NSString*)rongCloudToken ;
@end

@interface LoginDataParse : NSObject
@property (nonatomic,weak)id<LoginDataDelegate>delegate;

//login
-(void) loginWithUserName:(NSString *)userName  password:(NSString *)password;

-(void) setJpushAlias;

-(void) getRongCloudToken;

@end
