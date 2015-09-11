//
//  ResVO.h
//  MyRill
//
//  Created by Siyuan Wang on 15/9/10.
//
//

#import <Foundation/Foundation.h>

@interface ResVO : NSObject

@property (nonatomic, copy) NSString *resId;        //资源id
@property (nonatomic, copy) NSString *name;         //资源名称
@property (nonatomic, copy) NSString *state;        //资源状态(1 可用,-1 不可用,-2 未知)
@property (nonatomic, copy) NSString *type;         //资源类型
@property (nonatomic, copy) NSString *ip;           //ip地址
@property (nonatomic, copy) NSString *policyName;   //策略名称
@property (nonatomic, copy) NSString *venderName;   //厂商
@property (nonatomic, copy) NSString *busy;         //繁忙度
@property (nonatomic, copy) NSString *usability;    //可用率
@property (nonatomic, copy) NSString *memRate;      //内存利用率
@property (nonatomic, copy) NSString *cpuRate;      //cpu利用率

//designed initilize
- (instancetype)initWithDic:(NSDictionary *)dic;

@end
