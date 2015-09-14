//
//  EventVO.h
//  MyRill
//
//  Created by Siyuan Wang on 15/9/14.
//
//

#import <Foundation/Foundation.h>

@interface EventVO : NSObject

@property (nonatomic, copy) NSString *eventId;      //事件ID
@property (nonatomic, copy) NSString *name;         //时间名称
@property (nonatomic, copy) NSString *level;        //事件级别(1-6):1-信息,2-未知,3-警告,4-次要,5-主要,6-严重
@property (nonatomic, copy) NSString *ip;           //资源IP地址
@property (nonatomic, copy) NSString *resName;      //资源名称
@property (nonatomic, copy) NSString *resType;      //资源类型
@property (nonatomic, copy) NSString *createTime;   //产生时间
@property (nonatomic, copy) NSString *collectType;  //采集类型（获取事件详细信息时需要）
@property (nonatomic, copy) NSString *resId;        //资源ID
@property (nonatomic, copy) NSString *policyId;     //策略ID
@property (nonatomic, copy) NSString *resTempId;    //模板ID
@property (nonatomic, copy) NSString *isApp;        //1:基础应用，0：非基础应用
@property (nonatomic, strong) NSNumber *time;         //事件产生时间
@property (nonatomic, copy) NSString *eventState;   //事件状态
@property (nonatomic, copy) NSString *eventType;    //事件类型:可用性事件-AVAIL_EVENT,配置事件-CONF_EVENT,性能事件-PERF_EVENT
@property (nonatomic, copy) NSString *viewType;     //unaccepted_event_view-未受理,accepted_event_view-已受理

//designed initilize
- (instancetype)initWithDic:(NSDictionary *)dic;

@end
