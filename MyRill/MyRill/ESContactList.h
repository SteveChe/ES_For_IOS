//
//  ESContactList.h
//  MyRill
//
//  Created by Steve on 15/7/3.
//
//

#import <Foundation/Foundation.h>
@interface ESContactList : NSObject
/** 用户ID */
@property(nonatomic, strong) NSString* enterpriseName;
/** 用户名*/
@property(nonatomic, strong) NSMutableArray* contactList;
@end
