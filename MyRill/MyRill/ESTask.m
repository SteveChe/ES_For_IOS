//
//  ESTask.m
//  MyRill
//
//  Created by Siyuan Wang on 15/8/2.
//
//

#import "ESTask.h"
#import "ColorHandler.h"
#import "ESUserInfo.h"
#import "ESTaskComment.h"

@implementation ESTask

- (instancetype)initWithDic:(NSDictionary *)dic {
    self = [super init];
    
    if (self) {
        
        if ([ColorHandler isNullOrNilNumber:dic[@"id"]]) {
            self.taskID = [NSNumber numberWithInt:-1];
        } else {
            self.taskID = dic[@"id"];
        }
        
        NSDictionary *initiatorDic = (NSDictionary *)dic[@"initiator"];
        if (initiatorDic != nil && ![initiatorDic isKindOfClass:[NSNull class]]) {
            self.initiator = [[ESUserInfo alloc] initWithDic:initiatorDic];
        } else {
            self.initiator = nil;
        }
        
        if ([ColorHandler isNullOrEmptyString:dic[@"title"]]) {
            self.title = @"";
        } else {
            self.title = dic[@"title"];
        }
        
        if ([ColorHandler isNullOrEmptyString:dic[@"description"]]) {
            self.taskDescription = @"";
        } else {
            self.taskDescription = dic[@"description"];
        }
        
        if ([ColorHandler isNullOrEmptyString:dic[@"status"]]) {
            self.status = @"";
        } else {
            self.status = dic[@"status"];
        }
        
        if ([ColorHandler isNullOrEmptyString:dic[@"chat_id"]]) {
            self.chatID = @"";
        } else {
            self.chatID = dic[@"chat_id"];
        }
        
        if ([ColorHandler isNullOrEmptyString:dic[@"created_at"]]) {
            self.startDate = @"";
        } else {
            self.startDate = dic[@"created_at"];
        }
        
        if ([ColorHandler isNullOrEmptyString:dic[@"due_date"]]) {
            self.endDate = @"";
        } else {
            self.endDate = dic[@"due_date"];
        }
        
        NSArray *array = (NSArray *)dic[@"observers"];
        if (array != nil && ![array isKindOfClass:[NSNull class]] && array.count != 0) {
            
            NSMutableArray *temp = [[NSMutableArray alloc] initWithCapacity:array.count];
            
            for (NSDictionary *dic1 in array) {
                ESUserInfo *contactor = [[ESUserInfo alloc] initWithDic:dic1];
                [temp addObject:contactor];
            }
            self.observers = [NSArray arrayWithArray:temp];
        } else {
            self.observers = nil;
        }
        
        NSDictionary *picDic = (NSDictionary *)dic[@"person_in_charge"];
        if (picDic != nil && ![picDic isKindOfClass:[NSNull class]]) {
            self.personInCharge = [[ESUserInfo alloc] initWithDic:picDic];
        } else {
            self.personInCharge = nil;
        }

        self.isUpdate = [dic[@"has_update"] boolValue];
        
        if (dic[@"comment"] != nil && ![dic[@"comment"] isKindOfClass:[NSNull class]]) {
            self.comments = [[ESTaskComment alloc] initWithDic:dic[@"comment"]];
        } else {
            self.comments = nil;
        }
    }
    
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@ %@ %@",self.title, self.personInCharge.userName, self.personInCharge.enterprise];
}

@end
