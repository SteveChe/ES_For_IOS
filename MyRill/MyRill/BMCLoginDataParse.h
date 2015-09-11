//
//  BMCLoginDataParse.h
//  MyRill
//
//  Created by Siyuan Wang on 15/9/9.
//
//

#import <Foundation/Foundation.h>

@protocol BMCLoginDelegate <NSObject>

-(void)loginSucceed:(NSDictionary *)loginDic;
-(void)loginFailed:(NSString*)errorMessage;

@end

@interface BMCLoginDataParse : NSObject

@property (nonatomic,weak) id<BMCLoginDelegate> delegate;

- (void)loginBMCWithUserName:(NSString *)userName
                    password:(NSString *)password;

@end
