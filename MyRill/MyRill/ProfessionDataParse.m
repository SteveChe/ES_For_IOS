//
//  ProfessionDataParse.m
//  MyRill
//
//  Created by Siyuan Wang on 15/7/6.
//
//

#import "ProfessionDataParse.h"
#import "AFHttpTool.h"
#import "DataParseDefine.h"
#import "ESProfession.h"

@implementation ProfessionDataParse

- (void)getProfessionList {
    [AFHttpTool getProfessionSuccess:^(id response) {
        NSDictionary *responseDic = (NSDictionary *)response;
        NSNumber *errorCodeNum = responseDic[NETWORK_ERROR_CODE];
        
        if (errorCodeNum == nil || [errorCodeNum isEqual:[NSNull null]]) {
            NSLog(@"请求有误！");
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
            
            [self.delegate loadProfessionList:resultList];
        }
    } failure:^(NSError *error) {
        ;
    }];
}

- (void)addProfessionWithName:(NSString *)name url:(NSString *)url {
    [AFHttpTool addProfessionWithName:name
                                  url:url
                              success:^(id response) {
                                  NSDictionary *responseDic = (NSDictionary *)response;
                                  NSNumber *errorCodeNum = responseDic[NETWORK_ERROR_CODE];
                                  
                                  if (errorCodeNum == nil || [errorCodeNum isEqual:[NSNull null]]) {
                                      NSLog(@"请求有误！");
                                      return;
                                  }
                                  
                                  NSInteger errorCode = [errorCodeNum integerValue];
                                  if (errorCode == 0) {
                                      NSDictionary *dataDic = (NSDictionary *)responseDic[NETWORK_OK_DATA];
                                      
                                      [self.delegate addProfessionSuccess];
                                  }
                              }
                              failure:^(NSError *error) {
                                  NSLog(@"%@",[error debugDescription]);
                                  ;
                              }];
}

- (void)deleteProfessionWithName:(NSString *)name
                             url:(NSString *)url {
    [AFHttpTool deleteProfessionWithName:name
                                     url:url
                                 success:^(id response) {
                                     NSDictionary *responseDic = (NSDictionary *)response;
                                     NSNumber *errorCodeNum = responseDic[NETWORK_ERROR_CODE];
                                     
                                     if (errorCodeNum == nil || [errorCodeNum isEqual:[NSNull null]]) {
                                         NSLog(@"请求有误！");
                                         return;
                                     }
                                     
                                     NSInteger errorCode = [errorCodeNum integerValue];
                                     if (errorCode == 0) {
                                         NSDictionary *dataDic = (NSDictionary *)responseDic[NETWORK_OK_DATA];
                                         
                                         [self.delegate addProfessionSuccess];
                                     }
                                 }
                                 failure:^(NSError *error) {
                                     NSLog(@"%@",[error debugDescription]);
                                     ;
                                 }];
}

@end
