//
//  ResVO.m
//  MyRill
//
//  Created by Siyuan Wang on 15/9/10.
//
//

#import "ResVO.h"
#import "ColorHandler.h"

@implementation ResVO

- (instancetype)initWithDic:(NSDictionary *)dic {
    self = [super init];
    
    if (self) {
        if ([ColorHandler isNullOrEmptyString:dic[@"resId"]]) {
            self.resId = @"";
        } else {
            self.resId = dic[@"resId"];
        }
        
        if ([ColorHandler isNullOrEmptyString:dic[@"name"]]) {
            self.name = @"";
        } else {
            self.name = dic[@"name"];
        }
        
        if ([ColorHandler isNullOrEmptyString:dic[@"state"]]) {
            self.state = @"";
        } else {
            self.state = dic[@"state"];
        }
        
        if ([ColorHandler isNullOrEmptyString:dic[@"type"]]) {
            self.type = @"";
        } else {
            self.type = dic[@"type"];
        }
        
        if ([ColorHandler isNullOrEmptyString:dic[@"ip"]]) {
            self.ip = @"";
        } else {
            self.ip = dic[@"ip"];
        }
        
        if ([ColorHandler isNullOrEmptyString:dic[@"policyName"]]) {
            self.policyName = @"";
        } else {
            self.policyName = dic[@"policyName"];
        }
        
        if ([ColorHandler isNullOrEmptyString:dic[@"venderName"]]) {
            self.venderName = @"";
        } else {
            self.venderName = dic[@"venderName"];
        }
        
        if ([ColorHandler isNullOrEmptyString:dic[@"busy"]]) {
            self.busy = @"";
        } else {
            self.busy = dic[@"busy"];
        }
        
        if ([ColorHandler isNullOrEmptyString:dic[@"usability"]]) {
            self.usability = @"";
        } else {
            self.usability = dic[@"usability"];
        }
        
        if ([ColorHandler isNullOrEmptyString:dic[@"memRate"]]) {
            self.memRate = @"";
        } else {
            self.memRate = dic[@"memRate"];
        }
        
        if ([ColorHandler isNullOrEmptyString:dic[@"cpuRate"]]) {
            self.cpuRate = @"";
        } else {
            self.cpuRate = dic[@"cpuRate"];
        }
    }
    
    return self;
}

@end
