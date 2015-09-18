//
//  SendTaskImageDataParse.m
//  MyRill
//
//  Created by Siyuan Wang on 15/8/30.
//
//

#import "SendTaskImageDataParse.h"
#import "AFHttpTool.h"
#import "DataParseDefine.h"
#import "ESImage.h"

@implementation SendTaskImageDataParse

- (void)sendTaskCommentWithTaskID:(NSString *)taskID
                          comment:(ESTaskComment *)taskComment
                        imageData:(NSData *)imageData {
    [AFHttpTool sendTaskImageWithTaskId:taskID
                                comment:taskComment
                                imageData:imageData
                                success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                    NSDictionary *reponseDic = (NSDictionary *)responseObject;
                                    NSNumber* errorCodeNum = [reponseDic valueForKey:NETWORK_ERROR_CODE];
                                    if (errorCodeNum == nil || [errorCodeNum isEqual:[NSNull null]]) {
                                        [self.delegate sendTaskImageFailure:nil];
                                        return ;
                                    }
                                    
                                    NSInteger errorCode = [errorCodeNum integerValue];
                                    if (errorCode == 0) {
                                        NSDictionary *dataDic = reponseDic[NETWORK_OK_DATA];
                                        ESImage *image = [[ESImage alloc] initWithDic:dataDic];
                                        [self.delegate sendTaskImageSuccess:image];
                                    } else {
                                        [self.delegate sendTaskImageFailure:nil];
                                    }
                                    
                                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                    [self.delegate sendTaskImageFailure:nil];
                                    NSLog(@"Error: %@", error);
                                }];
}

@end
