//
//  ESProfession.m
//  MyRill
//
//  Created by Siyuan Wang on 15/7/6.
//
//

#import "ESProfession.h"
#import "ColorHandler.h"

@implementation ESProfession

- (instancetype)initWithDic:(NSDictionary *)dic {
    self = [super init];
    
    if (self) {
        
        if ([ColorHandler isNullOrNilNumber:dic[@"id"]]) {
            self.professionId = [NSNumber numberWithInt:-1];
        } else {
            self.professionId = dic[@"id"];
        }
        if ([ColorHandler isNullOrNilNumber:dic[@"sub_id"]]) {
            self.sub_id = [NSNumber numberWithInt:-1];
        } else {
            self.sub_id = dic[@"sub_id"];
        }
        
        if ([ColorHandler isNullOrNilNumber:dic[@"order"]]) {
            self.order = [NSNumber numberWithInt:-1];
        } else {
            self.order = dic[@"order"];
        }
        
        self.isSystem = [dic[@"is_system"] boolValue];
//        self.isSystem = YES;
        
        if ([ColorHandler isNullOrEmptyString:dic[@"name"]]) {
            self.name = @"";
        } else {
            self.name = dic[@"name"];
        }
        
        if ([ColorHandler isNullOrEmptyString:dic[@"url"]]) {
            self.url = @"";
        } else {
            self.url = dic[@"url"];
        }
        
        if ([ColorHandler isNullOrEmptyString:dic[@"icon_url"]]) {
            self.icon_url = @"";
        } else {
            self.icon_url = dic[@"icon_url"];
        }
        
        if ([ColorHandler isNullOrEmptyString:dic[@"profession_type"]]) {
            self.professionType = @"";
        } else {
            self.professionType = dic[@"profession_type"];
        }
    }
    
    return self;
}

@end
