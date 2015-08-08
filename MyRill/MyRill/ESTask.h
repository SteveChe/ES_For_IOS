//
//  ESTask.h
//  MyRill
//
//  Created by Siyuan Wang on 15/8/2.
//
//

#import <Foundation/Foundation.h>
@class ESContactor;

@interface ESTask : NSObject

@property (nonatomic, strong) NSNumber *taskID;
@property (nonatomic, strong) ESContactor *initiator;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *taskDescription;
@property (nonatomic, strong) NSNumber *status;
@property (nonatomic, strong) NSNumber *chatID;
@property (nonatomic, copy) NSString *startDate;
@property (nonatomic, copy) NSString *endDate;
@property (nonatomic, strong) NSArray *observers;
@property (nonatomic, strong) ESContactor *personInCharge;
//"comment": {}

//designed initilize
- (instancetype)initWithDic:(NSDictionary *)dic;

@end
