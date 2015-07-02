//
//  GetRequestContactListDataParse.h
//  MyRill
//
//  Created by Steve on 15/7/2.
//
//

#import <Foundation/Foundation.h>
@protocol GetRequestContactListDelegate <NSObject>
-(void)getRequestedContactList:(NSArray*)contactList;
-(void)getRequestedContactListFailed:(NSString*)errorMessage;
@end

@interface GetRequestContactListDataParse : NSObject

@property (nonatomic,weak)id<GetRequestContactListDelegate>delegate;

//获取已经请求添加自己的联系人列表
-(void) getRequestedContactList;

@end
