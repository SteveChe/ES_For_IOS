//
//  GetContactListDataParse.h
//  MyRill
//
//  Created by Steve on 15/7/2.
//
//

#import <Foundation/Foundation.h>
@protocol GetContactListDelegate <NSObject>
-(void)getContactList:(NSArray*)contactList;
-(void)getContactListFailed:(NSString*)errorMessage;
@end


@interface GetContactListDataParse : NSObject
@property (nonatomic,weak)id<GetContactListDelegate>delegate;

/******** 联系人列表******
 请求方式：GET
 参数：无
 备注：该接口返回当前用户所有的联系人信息
 **/
-(void) getContactList;

@end
