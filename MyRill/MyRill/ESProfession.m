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
        if ([ColorHandler isNullOrNilNumber:dic[@"order"]]) {
            self.order = [NSNumber numberWithInt:-1];
        } else {
            self.order = dic[@"order"];
        }
        
//        if ([ColorHandler isNullOrNilNumber:dic[@""]]) {
//            <#statements#>
//        }
        self.isSystem = dic[@"is_system"];
        
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
    }
    
    return self;
}

@end
