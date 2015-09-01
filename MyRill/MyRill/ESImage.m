//
//  ESImage.m
//  MyRill
//
//  Created by Siyuan Wang on 15/9/1.
//
//

#import "ESImage.h"
#import "ColorHandler.h"

@implementation ESImage

- (instancetype)initWithDic:(NSDictionary *)dic {
    self = [super init];
    
    if (self) {
        if ([ColorHandler isNullOrNilNumber:dic[@"id"]]) {
            self.imageID = [NSNumber numberWithInt:-1];
        } else {
            self.imageID = dic[@"id"];
        }
        
        if ([ColorHandler isNullOrEmptyString:dic[@"image"]]) {
            self.imgURL = @"";
        } else {
            self.imgURL = dic[@"image"];
        }
        
        if ([ColorHandler isNullOrNilNumber:dic[@"user"]]) {
            self.imgUserID = @"";
        } else {
            self.imgUserID = [dic[@"user"] stringValue];
        }
    }
    
    return self;
}

@end
