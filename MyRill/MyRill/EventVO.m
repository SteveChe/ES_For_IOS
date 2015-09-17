//
//  EventVO.m
//  MyRill
//
//  Created by Siyuan Wang on 15/9/14.
//
//

#import "EventVO.h"
#import "ColorHandler.h"

@implementation EventVO

- (instancetype)initWithDic:(NSDictionary *)dic {
    self = [super init];
    
    if (self) {
        if ([ColorHandler isNullOrEmptyString:dic[@"eventId"]]) {
            self.eventId = @"";
        } else {
            self.eventId = dic[@"eventId"];
        }
        
        if ([ColorHandler isNullOrEmptyString:dic[@"name"]]) {
            self.name = @"";
        } else {
            self.name = dic[@"name"];
        }
        
        if ([ColorHandler isNullOrEmptyString:dic[@"level"]]) {
            self.level = @"";
        } else {
            NSInteger levelInt = [dic[@"level"] integerValue];
            switch (levelInt) {
                case 1:
                    self.level = @"信息";
                    break;
                case 2:
                    self.level = @"未知";
                    break;
                case 3:
                    self.level = @"警告";
                    break;
                case 4:
                    self.level = @"次要";
                    break;
                case 5:
                    self.level = @"主要";
                    break;
                case 6:
                    self.level = @"严重";
                    break;
                default:
                    self.level = @"--";
                    break;
            }
            
        }
        
        if ([ColorHandler isNullOrEmptyString:dic[@"ip"]]) {
            self.ip = @"";
        } else {
            self.ip = dic[@"ip"];
        }
        
        if ([ColorHandler isNullOrEmptyString:dic[@"resName"]]) {
            self.resName = @"";
        } else {
            self.resName = dic[@"resName"];
        }
        
        if ([ColorHandler isNullOrEmptyString:dic[@"resType"]]) {
            self.resType = @"";
        } else {
            self.resType = dic[@"resType"];
        }
        
        if ([ColorHandler isNullOrEmptyString:dic[@"createTime"]]) {
            self.createTime = @"";
        } else {
            self.createTime = dic[@"createTime"];
        }
        
        if ([ColorHandler isNullOrEmptyString:dic[@"collectType"]]) {
            self.collectType = @"";
        } else {
            self.collectType = dic[@"collectType"];
        }
        
        if ([ColorHandler isNullOrEmptyString:dic[@"resId"]]) {
            self.resId = @"";
        } else {
            self.resId = dic[@"resId"];
        }
        
        if ([ColorHandler isNullOrEmptyString:dic[@"policyId"]]) {
            self.policyId = @"";
        } else {
            self.policyId = dic[@"policyId"];
        }
        
        if ([ColorHandler isNullOrEmptyString:dic[@"resTempId"]]) {
            self.resTempId = @"";
        } else {
            self.resTempId = dic[@"resTempId"];
        }
        
        if ([ColorHandler isNullOrEmptyString:dic[@"isApp"]]) {
            self.isApp = @"";
        } else {
            NSInteger index = [dic[@"isApp"] integerValue];
            switch (index) {
                case 0:
                    self.isApp = @"非基础应用";
                    break;
                case 1:
                    self.isApp = @"基础应用";
                    break;
                default:
                    self.isApp = @"——";
                    break;
            }
        }
        
        if ([ColorHandler isNullOrNilNumber:dic[@"time"]]) {
            self.time = @"——";
        } else {
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:[dic[@"time"] integerValue]];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSString *dateStr = [formatter stringFromDate:date];
            self.time = dateStr;
        }
        
        if ([ColorHandler isNullOrEmptyString:dic[@"eventState"]]) {
            self.eventState = @"";
        } else {
            self.eventState = dic[@"eventState"];
        }
        
        if ([ColorHandler isNullOrEmptyString:dic[@"eventType"]]) {
            self.eventType = @"";
        } else {
            if ([dic[@"eventType"] isEqualToString:@"AVAIL_EVENT"]) {
                self.eventType = @"可用事件";
            } else if ([dic[@"eventType"] isEqualToString:@"CONF_EVENT"]) {
                self.eventType = @"配置事件";
            } else if ([dic[@"eventType"] isEqualToString:@"PERF_EVENT"]) {
                self.eventType = @"性能事件";
            } else {
                self.eventType = @"——";
            }
        }
        
        if ([ColorHandler isNullOrEmptyString:dic[@"viewType"]]) {
            self.viewType = @"";
        } else {
            if ([dic[@"viewType"] isEqualToString:@"unaccepted_event_view"]) {
                self.viewType = @"未受理";
            } else if ([dic[@"viewType"] isEqualToString:@"accepted_event_view"]) {
                self.viewType = @"已受理";
            } else {
                self.viewType = @"——";
            }
            
        }
    }
    
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@ %@ %@",self.resName, self.ip, self.name];
}

@end
