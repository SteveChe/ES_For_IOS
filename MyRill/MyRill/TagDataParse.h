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

@end
@interface TagDataParse : NSObject
@property (nonatomic,weak)id<TagDataDelegate>delegate;

//获取人的标签
-(void) getUserTag:(NSString*)userId;

@end
