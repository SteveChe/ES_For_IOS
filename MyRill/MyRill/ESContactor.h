//
//  ESContactor.h
//  MyRill
//
//  Created by Siyuan Wang on 15/8/2.
//
//

#import <Foundation/Foundation.h>

@interface ESContactor : NSObject

@property (nonatomic, strong) NSNumber *useID;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *enterprise;
@property (nonatomic, copy) NSString *imgURLstr;

//designed initilize
- (instancetype)initWithDic:(NSDictionary *)dic;

@end
