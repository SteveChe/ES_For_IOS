//
//  ESContactor.m
//  MyRill
//
//  Created by Siyuan Wang on 15/8/2.
//
//

#import "ESContactor.h"
#import "ColorHandler.h"

@implementation ESContactor

- (instancetype)initWithDic:(NSDictionary *)dic {
    self = [super init];
    
    if (self) {
        
        if ([ColorHandler isNullOrNilNumber:dic[@"id"]]) {
            self.useID = [NSNumber numberWithInt:-1];
        } else {
            self.useID = dic[@"id"];
        }
        
        if ([ColorHandler isNullOrEmptyString:dic[@"name"]]) {
            self.name = @"";
        } else {
            self.name = dic[@"name"];
        }
        
        if ([ColorHandler isNullOrEmptyString:dic[@"enterprise"]]) {
            self.enterprise = @"";
        } else {
            self.enterprise = dic[@"enterprise"];
        }
        
        if ([ColorHandler isNullOrEmptyString:dic[@"avatar"]]) {
            self.imgURLstr = @"";
        } else {
            self.imgURLstr = dic[@"avatar"];
        }
    }
    
    return self;
}

@end
