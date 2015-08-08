//
//  ESEnterpriseMessageContent.h
//  MyRill
//
//  Created by Steve on 15/8/8.
//
//

#import <Foundation/Foundation.h>

@interface ESEnterpriseMessageContent : NSObject
@property(nonatomic,strong) NSString* title;
@property(nonatomic,strong) NSString* imageUrl;
@property(nonatomic,strong) NSString* content;
@property(nonatomic,assign) BOOL bLink;
@property(nonatomic,strong) NSString* linkUrl;
@end
