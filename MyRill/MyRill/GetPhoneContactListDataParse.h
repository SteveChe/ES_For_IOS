//
//  GetPhoneContactListDataParse.h
//  MyRill
//
//  Created by Steve on 15/7/10.
//
//

#import <Foundation/Foundation.h>
@protocol GetPhoneContactListDelegate <NSObject>
-(void)getPhoneContactList:(NSArray*)contactList;
-(void)getPhoneContactListFailed:(NSString*)errorMessage;
@end


@interface GetPhoneContactListDataParse : NSObject
@property (nonatomic,weak)id<GetPhoneContactListDelegate>delegate;

//获取手机通讯录中的ES联系人
-(void) getPhoneContactList:(NSMutableArray*)phoneContactList ;


@end
