//
//  UpdateProfessionListOrderDataParse.m
//  MyRill
//
//  Created by Siyuan Wang on 15/9/10.
//
//

#import "UpdateProfessionListOrderDataParse.h"
#import "AFHttpTool.h"
#import "DataParseDefine.h"

@implementation UpdateProfessionListOrderDataParse

- (void)updateProfessionListOrderWith:(NSArray *)professioinArray {
    [AFHttpTool updateProfessioinListOrderWith:professioinArray
                                       success:^(id response) {
                                           NSDictionary *responseDic = (NSDictionary *)response;
                                           NSNumber *errorCodeNum = responseDic[NETWORK_ERROR_CODE];
                                           
                                           if (errorCodeNum == nil || [errorCodeNum isEqual:[NSNull null]]) {
                                               NSLog(@"请求有误！");
                                               return;
                                           }
                                           
                                           NSInteger errorCode = [errorCodeNum integerValue];
                                           if (errorCode == 0) {
                                               [self.delegate orderProfessionListSuccess:@YES];
                                           }
                                       } failure:^(NSError *err) {
                                           [self.delegate orderProfessionListFailure:nil];
                                           //NSLog(@"%@",[err debugDescription]);
                                       }];
}

@end
