//
//  ESTask.m
//  MyRill
//
//  Created by Siyuan Wang on 15/8/2.
//
//

#import "ESTask.h"
#import "ColorHandler.h"
#import "ESContactor.h"

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
            self.initiator = [[ESContactor alloc] initWithDic:initiatorDic];
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
        
        if ([ColorHandler isNullOrNilNumber:dic[@"status"]]) {
            self.status = [NSNumber numberWithInt:-1];
        } else {
            self.status = dic[@"status"];
        }
        
        if ([ColorHandler isNullOrNilNumber:dic[@"chat_id"]]) {
            self.chatID = [NSNumber numberWithInt:-1];
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
                ESContactor *contactor = [[ESContactor alloc] initWithDic:dic1];
                [temp addObject:contactor];
            }
            self.observers = [NSArray arrayWithArray:temp];
        } else {
            self.observers = nil;
        }
        
        NSDictionary *picDic = (NSDictionary *)dic[@"person_in_charge"];
        if (picDic != nil && ![picDic isKindOfClass:[NSNull class]]) {
            self.personInCharge = [[ESContactor alloc] initWithDic:picDic];
        } else {
            self.personInCharge = nil;
        }
    }
    
    return self;
}

@end