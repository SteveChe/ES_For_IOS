//
//  ResMetricPojo.h
//  MyRill
//
//  Created by Siyuan Wang on 15/9/19.
//
//

#import <Foundation/Foundation.h>

@interface ResMetricPojo : NSObject

@property (nonatomic, copy) NSString *resId;        //主资源ID
@property (nonatomic, copy) NSString *subResId;     //子资源ID
@property (nonatomic, copy) NSString *metricId;     //指标ID
@property (nonatomic, copy) NSString *metricName;   //指标名称
@property (nonatomic, copy) NSString *metricUnit;   //单位
@property (nonatomic, copy) NSString *metricValue;  //值
@property (nonatomic, copy) NSString *metricType;   //指标类型
@property (nonatomic, copy) NSString *metricStatus;
@property (nonatomic, copy) NSString *metricStatus4Display;
@property (nonatomic, copy) NSString *metricValue4Display;

//designed initilize
- (instancetype)initWithDic:(NSDictionary *)dic;

@end
