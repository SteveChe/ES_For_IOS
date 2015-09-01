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
                                    if (errorCodeNum == nil || [errorCodeNum isEqual:[NSNull null]] )
                                    {
                                        return ;
                                    }
                                    
                                    NSDictionary *dataDic = reponseDic[NETWORK_OK_DATA];
                                    [self.delegate sendTaskImageSuccess:dataDic[@"image"]];
                                    NSString* errorMessage = [reponseDic valueForKey:NETWORK_ERROR_MESSAGE];
                                    if(errorMessage==nil)
                                        return;
                                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                    NSLog(@"Error: %@", error);
                                }];
}

@end
