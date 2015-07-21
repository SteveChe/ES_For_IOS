//
//  ChangeUserImageDataParse.m
//  MyRill
//
//  Created by Siyuan Wang on 15/7/19.
//
//

#import "ChangeUserImageDataParse.h"
#import "AFHttpTool.h"

@implementation ChangeUserImageDataParse

- (void)changeUseImageWithId:(NSString *)UserId
                        data:(NSData *)imageData {
    [AFHttpTool changeUserImageWithId:UserId
                                 data:imageData
                              success:^(id response) {
                                  
                                  NSLog(@"%@",response);
                              } failure:^(NSError *err) {
                                  
                                  NSLog(@"ASDFASDF");
                              }];
}

@end
