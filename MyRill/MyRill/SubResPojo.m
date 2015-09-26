//
//  SubResPojo.m
//  MyRill
//
//  Created by Siyuan Wang on 15/9/26.
//
//

#import "SubResPojo.h"
#import "ColorHandler.h"

@implementation SubResPojo

- (instancetype)initWithDic:(NSDictionary *)dic {
    self = [super init];
    
    if (self) {
        if ([ColorHandler isNullOrEmptyString:dic[@"subResId"]]) {
            self.subResId = @"";
        } else {
            self.subResId = dic[@"subResId"];
        }
        
        if ([ColorHandler isNullOrEmptyString:dic[@"resName"]]) {
            self.resName = @"";
        } else {
            self.resName = dic[@"resName"];
        }
        
        if ([ColorHandler isNullOrEmptyString:dic[@"resId"]]) {
            self.resId = @"";
        } else {
            self.resId = dic[@"resId"];
        }
        
        if ([ColorHandler isNullOrEmptyString:dic[@"subName"]]) {
            self.subName = @"";
        } else {
            self.subName = dic[@"subName"];
        }
        
        if ([ColorHandler isNullOrEmptyString:dic[@"subResType"]]) {
            self.subResType = @"";
        } else {
            self.subResType = dic[@"subResType"];
        }
    }
    
    return self;
}

@end
