//
//  ChangeUserImageDataParse.m
//  MyRill
//
//  Created by Siyuan Wang on 15/7/19.
//
//

#import "ChangeUserImageDataParse.h"
#import "AFHttpTool.h"
#import "DataParseDefine.h"

@implementation ChangeUserImageDataParse

- (void)changeUseImageWithId:(NSString *)UserId
                        data:(NSData *)imageData {
    [AFHttpTool changeUserImageWithId:UserId
                                 data:imageData
                              success:^(AFHTTPRequestOperation *operation,id responseObject) {
                                  NSDictionary *reponseDic = (NSDictionary *)responseObject;
                                  NSNumber* errorCodeNum = [reponseDic valueForKey:NETWORK_ERROR_CODE];
                                  if (errorCodeNum == nil || [errorCodeNum isEqual:[NSNull null]] )
                                  {
                                      return ;
                                  }
                                  
                                  NSDictionary *dataDic = reponseDic[NETWORK_OK_DATA];
                                  NSString *avatar = dataDic[@"avatar"];
                                  [self.delegate changeUserImageSuccess:avatar];
                                  
                                  NSString* errorMessage = [reponseDic valueForKey:NETWORK_ERROR_MESSAGE];
                                  if(errorMessage==nil)
                                      return;
                                  
//                                  errorMessage= [errorMessage stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//                                  NSLog(@"%@",errorMessage);
//                                  if (self.delegate!= nil &&[self.delegate respondsToSelector:@selector(getContactDetailFailed:)])
//                                  {
//                                      [self.delegate getContactDetailFailed:errorMessage];
//                                  }
                              } failure:^(AFHTTPRequestOperation *operation,NSError *error) {
                                  
                                  NSLog(@"Error: %@", error);
                              }];
}

@end
