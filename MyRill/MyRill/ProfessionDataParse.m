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
            
            [self.delegate professionOperationSuccess:resultList];
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
                                      NSDictionary *modelDic = (NSDictionary *)responseDic[NETWORK_OK_DATA];
                                      ESProfession *profession = [[ESProfession alloc] initWithDic:modelDic];
                                      [self.delegate professionOperationSuccess:profession];
                                  }
                              }
                              failure:^(NSError *error) {
                                  NSLog(@"%@",[error debugDescription]);
                                  ;
                              }];
}

- (void)deleteProfessionWithId:(NSString *)professionId {
    [AFHttpTool deleteProfessionWithId:professionId
                               success:^(id response) {
                                   NSDictionary *responseDic = (NSDictionary *)response;
                                   NSNumber *errorCodeNum = responseDic[NETWORK_ERROR_CODE];
                            
                                   if (errorCodeNum == nil || [errorCodeNum isEqual:[NSNull null]]) {
                                       NSLog(@"请求有误！");
                                       return;
                                   }
                                   
                                   NSInteger errorCode = [errorCodeNum integerValue];
                                   if (errorCode == 0) {
                                       [self.delegate professionOperationSuccess:nil];
                                   }
                               }
                               failure:^(NSError *error) {
                                   [self.delegate professionOperationFailure:nil];
                                   //NSLog(@"%@",[error debugDescription]);
                               }];
}

- (void)updateProfessionWithId:(NSString *)professionId
                          name:(NSString *)name
                           url:(NSString *)url {
    [AFHttpTool updateProfessioinWithId:professionId
                                   name:name
                                    url:url
                                success:^(id response) {
                                    NSDictionary *responseDic = (NSDictionary *)response;
                                    NSLog(@"%@",responseDic);
                                } failure:^(NSError *err) {
                                    ;
                                }];
}

- (void)updateProfessionListOrderWith:(NSArray *)professioinArray {
    [AFHttpTool updateProfessioinListOrderWith:professioinArray
                                       success:^(id response) {
                                           NSDictionary *dic = (NSDictionary *)response;
                                           NSLog(@"%@",dic);
                                       } failure:^(NSError *err) {
                                           NSLog(@"%@",[err debugDescription]);
                                       }];
}

@end
