//
//  ESTaskComment.h
//  MyRill
//
//  Created by Siyuan Wang on 15/8/9.
//
//

#import <Foundation/Foundation.h>
@class ESUserInfo;
@class ESImage;

@interface ESTaskComment : NSObject

@property (nonatomic, strong) NSNumber *commentID;
@property (nonatomic, copy) NSString *createDate;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, strong) ESUserInfo *user;
@property (nonatomic, strong) NSMutableArray *images;

//designed initilize
- (instancetype)initWithDic:(NSDictionary *)dic;

@end
