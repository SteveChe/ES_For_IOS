//
//  LogSummaryEventAlarmPojo.m
//  MyRill
//
//  Created by Siyuan Wang on 15/9/19.
//
//

#import "LogSummaryEventAlarmPojo.h"
#import "ColorHandler.h"

@implementation LogSummaryEventAlarmPojo

- (instancetype)initWithDic:(NSDictionary *)dic {
    self = [super init];
    
    if (self) {
        if ([ColorHandler isNullOrEmptyString:dic[@"resId"]]) {
            self.resId = @"";
        } else {
            self.resId = dic[@"resId"];
        }
        
        if ([ColorHandler isNullOrEmptyString:dic[@"subResId"]]) {
            self.subResId = @"";
        } else {
            self.subResId = dic[@"subResId"];
        }
        
        if ([ColorHandler isNullOrEmptyString:dic[@"metricId"]]) {
            self.metricId = @"";
        } else {
            self.metricId = dic[@"metricId"];
        }
        
        if ([ColorHandler isNullOrEmptyString:dic[@"metricName"]]) {
            self.metricName = @"";
        } else {
            self.metricName = dic[@"metricName"];
        }
        
        if ([ColorHandler isNullOrEmptyString:dic[@"metricUnit"]]) {
            self.metricUnit = @"";
        } else {
            self.metricUnit = dic[@"metricUnit"];
        }
        
        if ([ColorHandler isNullOrEmptyString:dic[@"metricValue"]]) {
            self.metricValue = @"";
        } else {
            self.metricValue = dic[@"metricValue"];
        }
        
        if ([ColorHandler isNullOrEmptyString:dic[@"metricType"]]) {
            self.metricType = @"";
        } else {
            self.metricType = dic[@"metricType"];
        }
    }
    
    return self;
}

@end
