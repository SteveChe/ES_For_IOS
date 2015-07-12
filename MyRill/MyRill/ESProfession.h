//
//  ESProfession.h
//  MyRill
//
//  Created by Siyuan Wang on 15/7/6.
//
//

#import <Foundation/Foundation.h>

@interface ESProfession : NSObject

@property (nonatomic, assign) NSNumber *order;
@property (nonatomic, assign) BOOL isSystem;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *icon_url;

- (instancetype)initWithDic:(NSDictionary *)dic;

@end
