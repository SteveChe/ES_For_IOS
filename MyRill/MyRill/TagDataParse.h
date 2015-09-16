//
//  TagDataParse.h
//  MyRill
//
//  Created by Steve on 15/7/29.
//
//

#import <Foundation/Foundation.h>
@class ESTag;
@protocol TagDataDelegate <NSObject>

- (void)getTag:(NSMutableArray *)tagInfoArray;
- (void)getTagFailed:(NSString*)errorMessage;

- (void)setTagSucceed:(NSMutableArray *)tagInfoArray;
- (void)setTagFailed:(NSString*)errorMessage;

@end
@interface TagDataParse : NSObject
@property (nonatomic,weak)id<TagDataDelegate>delegate;

//获取人的标签
-(void) getUserTag:(NSString*)userId;
//设置人的标签
//-(void) setUserTag:(NSString*)userId TagId:(NSString*)tagId tagItemId:(NSString*)tagItemId;
//设置人的标签
-(void) setUserTag:(NSString*)userId TagParams:(NSDictionary*)tagDics;


//获取企业的标签
-(void) getEnterpriseTag:(NSString*)enterpriseId;
//设置企业的标签
//-(void) setEnterpriseTag:(NSString*)enterpriseId TagId:(NSString*)tagId tagItemId:(NSString*)tagItemId;
-(void) setEnterpriseTag:(NSString*)enterpriseId TagParam:(NSDictionary*)tagDics;


//获取任务的标签
-(void) getTaskTag:(NSString*)taskTag;
//设置任务的标签
//-(void) setTaskTag:(NSString*)taskId TagId:(NSString*)tagId tagItemId:(NSString*)tagItemId;
-(void) setTaskTag:(NSString*)taskId TagParam:(NSDictionary*)tagDics;

@end
