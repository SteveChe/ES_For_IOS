//
//  ESUserInfo.m
//  MyRill
//
//  Created by Steve on 15/6/24.
//
//

#import "ESUserInfo.h"
#import "ColorHandler.h"

@implementation ESUserInfo
@synthesize userName;

- (instancetype)initWithDic:(NSDictionary *)dic {
    self = [super init];
    
    if (self) {
        
        if ([ColorHandler isNullOrNilNumber:dic[@"id"]]) {
            self.userId = @"";
        } else {
            self.userId = [dic[@"id"] stringValue];
        }
        
        if ([ColorHandler isNullOrEmptyString:dic[@"name"]]) {
            self.userName = @"";
        } else {
            self.userName = dic[@"name"];
        }
        
        if ([ColorHandler isNullOrEmptyString:dic[@"avatar"]]) {
            self.portraitUri = @"";
        } else {
            self.portraitUri = dic[@"avatar"];
        }
        
        if ([ColorHandler isNullOrEmptyString:dic[@"phoneNumber"]]) {
            self.phoneNumber = @"";
        } else {
            self.phoneNumber = dic[@"phoneNumber"];
        }
        
        if ([ColorHandler isNullOrEmptyString:dic[@"enterprise"]]) {
            self.enterprise = @"";
        } else {
            self.enterprise = dic[@"enterprise"];
        }
        
        if ([ColorHandler isNullOrEmptyString:dic[@"position"]]) {
            self.position = @"";
        } else {
            self.position = dic[@"position"];
        }
    }
    
    return self;
}

@end
