//
//  UpdateObserverAndChatidDataParse.m
//  MyRill
//
//  Created by Siyuan Wang on 15/9/5.
//
//

#import "UpdateObserverAndChatidDataParse.h"
#import "AFHttpTool.h"

@implementation UpdateObserverAndChatidDataParse

-(void)updateObserverAndChatidWith:(ESTask *)task {
    [AFHttpTool updateObserverAndChatidWith:task
                                    success:^(id response) {
                                        NSDictionary *reponseDic = (NSDictionary *)response;
                                    } failure:^(NSError *error) {
                                        NSLog(@"%@",[error debugDescription]);
                                    }];
}

@end
