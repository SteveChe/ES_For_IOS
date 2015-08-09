//
//  ESTaskComment.m
//  MyRill
//
//  Created by Siyuan Wang on 15/8/9.
//
//

#import "ESTaskComment.h"
#import "ColorHandler.h"
#import "ESContactor.h"

@implementation ESTaskComment

- (instancetype)initWithDic:(NSDictionary *)dic {
    self = [super init];
    
    if (self) {
        
        if ([ColorHandler isNullOrNilNumber:dic[@"id"]]) {
            self.commentID = [NSNumber numberWithInt:-1];
        } else {
            self.commentID = dic[@"id"];
        }
        
        if ([ColorHandler isNullOrEmptyString:dic[@"created_at"]]) {
            self.createDate = @"";
        } else {
            self.createDate = dic[@"created_at"];
        }
        
        if ([ColorHandler isNullOrEmptyString:dic[@"entercontentprise"]]) {
            self.content = @"";
        } else {
            self.content = dic[@"content"];
        }
        
        NSDictionary *userDic = (NSDictionary *)dic[@"user"];
        if (userDic != nil && ![userDic isKindOfClass:[NSNull class]]) {
            self.user = nil;
        } else {
            self.user = [[ESContactor alloc] initWithDic:dic[@"user"]];
        }
    }
    
    return self;
}

@end
