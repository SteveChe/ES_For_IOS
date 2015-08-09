//
//  ESTaskMask.m
//  MyRill
//
//  Created by Siyuan Wang on 15/8/8.
//
//

#import "ESTaskMask.h"
#import "ColorHandler.h"

@implementation ESTaskMask

- (instancetype)initWithDic:(NSDictionary *)dic {
    self = [super init];
    
    if (self) {
        if ([ColorHandler isNullOrNilNumber:dic[@"num"]]) {
            self.num = [NSNumber numberWithInt:-1];
        } else {
            self.num = dic[@"num"];
        }
        
        if (dic[@"isUpdate"] == nil ) {
            self.isUpdate = NO;
        } else {
            self.isUpdate = YES;
        }
    }
    
    return self;
}

@end
