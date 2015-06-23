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
