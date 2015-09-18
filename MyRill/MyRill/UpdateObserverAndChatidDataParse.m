//
//  UpdateObserverAndChatidDataParse.m
//  MyRill
//
//  Created by Siyuan Wang on 15/9/5.
//
//

#import "UpdateObserverAndChatidDataParse.h"
#import "AFHttpTool.h"
#import "DataParseDefine.h"

@implementation UpdateObserverAndChatidDataParse

-(void)updateObserverAndChatidWith:(ESTask *)task {
    [AFHttpTool updateObserverAndChatidWith:task
                                    success:^(id response) {
                                        NSDictionary *responseDic = (NSDictionary *)response;
                                        NSNumber* errorCodeNum = [responseDic valueForKey:NETWORK_ERROR_CODE];
                                        if (errorCodeNum == nil || [errorCodeNum isEqual:[NSNull null]]) {
                                            [self.delegate updateObserverAndChatidFailed:nil];
                                            return;
                                        }
                                        
                                        NSInteger errorCode = [errorCodeNum integerValue];
                                        if (errorCode == 0) {
                                            [self.delegate updateObserverAndChatidSuccess];
                                        } else {
                                            [self.delegate updateObserverAndChatidFailed:nil];
                                        }
                                    } failure:^(NSError *error) {
                                        [self.delegate updateObserverAndChatidFailed:nil];
                                        NSLog(@"%@",[error debugDescription]);
                                    }];
}

@end
