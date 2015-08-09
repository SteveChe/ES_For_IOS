//
//  ESTaskMask.h
//  MyRill
//
//  Created by Siyuan Wang on 15/8/8.
//
//

#import <Foundation/Foundation.h>

@interface ESTaskMask : NSObject

@property (nonatomic, strong) NSNumber *num;
@property (nonatomic, assign) BOOL isUpdate;

- (instancetype)initWithDic:(NSDictionary *)dic;

@end
