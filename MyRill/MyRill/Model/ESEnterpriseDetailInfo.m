//
//  ESEnterpriseDetailInfo.m
//  MyRill
//
//  Created by Steve on 15/8/3.
//
//

#import "ESEnterpriseDetailInfo.h"
#import "ColorHandler.h"

@implementation ESEnterpriseDetailInfo

- (instancetype)initWithDic:(NSDictionary *)dic {
    self = [super init];
    
    if (self) {
        if ([ColorHandler isNullOrNilNumber:dic[@"id"]]) {
            self.enterpriseId = @"";
        } else {
            self.enterpriseId = [dic[@"id"] stringValue];
        }
        
        if ([ColorHandler isNullOrEmptyString:dic[@"name"]]) {
            self.enterpriseName = @"";
        } else {
            self.enterpriseName = dic[@"name"];
        }
        
        if ([ColorHandler isNullOrEmptyString:dic[@"category"]]) {
            self.enterpriseCategory = @"";
        } else {
            self.enterpriseCategory = dic[@"category"];
        }
        
        if ([ColorHandler isNullOrEmptyString:dic[@"description"]]) {
            self.enterpriseDescription = @"";
        } else {
            self.enterpriseDescription = dic[@"description"];
        }
        
        if ([ColorHandler isNullOrEmptyString:dic[@"qrcode"]]) {
            self.enterpriseQRCode = @"";
        } else {
            self.enterpriseQRCode = dic[@"qrcode"];
        }
        
        if ([ColorHandler isNullOrEmptyString:dic[@"avatar"]]) {
            self.portraitUri = @"";
        } else {
            self.portraitUri = dic[@"avatar"];
        }
        
        self.bVerified = [dic[@"verified"] boolValue];
        self.bFollowed = [dic[@"is_following"] boolValue];
    }
    
    return self;
}

@end
