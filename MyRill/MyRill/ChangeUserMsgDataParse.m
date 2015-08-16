//
//  ChangeUserMsgDataParse.m
//  MyRill
//
//  Created by Siyuan Wang on 15/8/16.
//
//

#import "ChangeUserMsgDataParse.h"

@implementation ChangeUserMsgDataParse

- (void)changeUserMsgWithUserID:(NSString *)userID
                           type:(ESUserMsgType)type
                        content:(NSString *)content {
    [AFHttpTool changeUserMsgWithUserID:userID
                                   type:type
                                content:content
                                success:^(id response) {
                                    NSDictionary *responseDic = (NSDictionary *)response;
                                    [self.delegate changeUserMsgSuccess];
                                } failure:^(NSError *err) {
                                    NSLog(@"%@", [err debugDescription]);
                                }];
}

@end
