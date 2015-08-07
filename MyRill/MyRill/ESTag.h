//
//  ESTag.h
//  MyRill
//
//  Created by Steve on 15/7/28.
//
//

#import <Foundation/Foundation.h>
@interface ESTagItem : NSObject
@property (nonatomic,strong) NSString* tagItemId;
@property (nonatomic,strong) NSString* tagItemName;
@end

@interface ESTag : NSObject
@property (nonatomic,strong) NSString* tagId;
@property (nonatomic,strong) NSString* tagName;
@property (nonatomic,strong) NSMutableArray* tagItemList;
@property (nonatomic,strong) NSString* selectedTagItemId;
@property (nonatomic,assign) BOOL bIs_locked;
@end
