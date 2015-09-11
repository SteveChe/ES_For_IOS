//
//  GetProfessionListDataParse.m
//  MyRill
//
//  Created by Siyuan Wang on 15/9/10.
//
//

#import "GetProfessionListDataParse.h"
#import "AFHttpTool.h"
#import "DataParseDefine.h"
#import "ESProfession.h"

@implementation GetProfessionListDataParse

- (void)getProfessionList {
    [AFHttpTool getProfessionSuccess:^(id response) {
        NSDictionary *responseDic = (NSDictionary *)response;
        NSNumber *errorCodeNum = responseDic[NETWORK_ERROR_CODE];
        
        if (errorCodeNum == nil || [errorCodeNum isEqual:[NSNull null]]) {
            NSLog(@"请求有误！");
            [self.delegate getProfessionListFailure:@"请求有误!获取业务失败！"];
            return;
        }
        
        NSInteger errorCode = [errorCodeNum integerValue];
        if (errorCode == 0) {
            NSDictionary *dataDic = (NSDictionary *)responseDic[NETWORK_OK_DATA];
            NSArray *dataList = (NSArray *)dataDic[NETWORK_DATA_LIST];
            NSMutableArray *resultList = [[NSMutableArray alloc] initWithCapacity:dataList.count];
            
            for (NSDictionary *temp in dataList) {
                ESProfession *profession = [[ESProfession alloc] initWithDic:temp];
                [resultList addObject:profession];
            }
            
            [self.delegate getProfessionListSuccess:resultList];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",[error debugDescription]);
        [self.delegate getProfessionListFailure:@"请求失败!获取业务失败!"];
    }];
}

@end
