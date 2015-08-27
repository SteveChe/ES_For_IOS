//
//  ESEnterpriseInfo.m
//  MyRill
//
//  Created by Steve on 15/7/19.
//
//

#import "ESEnterpriseInfo.h"
#import "ColorHandler.h"

@implementation ESEnterpriseInfo

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
        self.bIsFollowed = [dic[@"is_following"] boolValue];
    }
    
    return self;
}

@end
