//
//  ChangeUserMsgDataParse.h
//  MyRill
//
//  Created by Siyuan Wang on 15/8/16.
//
//

#import <Foundation/Foundation.h>
#import "AFHttpTool.h"

@protocol ChangeUserMsgDelegate <NSObject>

- (void)changeUserMsgSuccess;

@end

@interface ChangeUserMsgDataParse : NSObject

@property (nonatomic, weak) id<ChangeUserMsgDelegate> delegate;

- (void)changeUserMsgWithUserID:(NSString *)userID
                           type:(ESUserMsgType)type
                        content:(NSString *)content;

@end
