//
//  ESTaskComment.h
//  MyRill
//
//  Created by Siyuan Wang on 15/8/9.
//
//

#import <Foundation/Foundation.h>
@class ESContactor;

@interface ESTaskComment : NSObject

@property (nonatomic, strong) NSNumber *commentID;
@property (nonatomic, copy) NSString *createDate;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, strong) ESContactor *user;

//designed initilize
- (instancetype)initWithDic:(NSDictionary *)dic;

@end
