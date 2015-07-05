//
//  SignOutDataParse.h
//  MyRill
//
//  Created by Siyuan Wang on 15/7/2.
//
//

#import <Foundation/Foundation.h>

@protocol LogoutDataDelegate <NSObject>

- (void)logoutSuccess;
- (void)logoutFail;

@end

@interface SignOutDataParse : NSObject

@property (nonatomic,weak) id<LogoutDataDelegate> delegate;

- (void)logout;

@end
