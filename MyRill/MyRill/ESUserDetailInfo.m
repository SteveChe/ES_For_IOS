//
//  ESUserDetailInfo.m
//  MyRill
//
//  Created by Steve on 15/7/15.
//
//

#import "ESUserDetailInfo.h"
#import "ColorHandler.h"

@implementation ESUserDetailInfo

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
        
        if ([ColorHandler isNullOrEmptyString:dic[@"position"]]) {
            self.position = @"";
        } else {
            self.position = dic[@"position"];
        }
        
        if ([ColorHandler isNullOrEmptyString:dic[@"gender"]]) {
            self.gender = @"";
        } else {
            self.gender = dic[@"gender"];
        }
        
        if ([ColorHandler isNullOrEmptyString:dic[@"email"]]) {
            self.email = @"";
        } else {
            self.email = dic[@"email"];
        }
        
        if ([ColorHandler isNullOrEmptyString:dic[@"qrcode"]]) {
            self.qrcode = @"";
        } else {
            self.qrcode = dic[@"qrcode"];
        }
        
        if ([ColorHandler isNullOrEmptyString:dic[@"enterprise_qrcode"]]) {
            self.enterprise_qrcode = @"";
        } else {
            self.enterprise_qrcode = dic[@"enterprise_qrcode"];
        }
        
        if ([ColorHandler isNullOrEmptyString:dic[@"description"]]) {
            self.contactDescription = @"";
        } else {
            self.contactDescription = dic[@"description"];
        }
        
        NSDictionary *tempDic = (NSDictionary *)dic[@"enterprise"];
        if (tempDic == nil || [tempDic isKindOfClass:[NSNull class]] || tempDic.count == 0) {
            self.enterprise = nil;
        } else {
            self.enterprise = [[ESEnterpriseInfo alloc] initWithDic:dic[@"enterprise"]];
        }
    }
    
    return self;
}

@end
