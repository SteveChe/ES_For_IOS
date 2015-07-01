//
//  AddContactDataParse.h
//  MyRill
//
//  Created by Steve on 15/6/30.
//
//

#import <Foundation/Foundation.h>

@protocol AddContactDelegate <NSObject>
-(void)addContactSucceed;
-(void)addContactFailed:(NSString*)errorMessage;

-(void)acceptContactSucceed;
-(void)acceptContactFailed:(NSString*)errorMessage;

-(void)getRequestedContactList:(NSArray*)contactList;
-(void)getRequestedContactListFailed:(NSString*)errorMessage;

@end

@interface AddContactDataParse : NSObject

@property (nonatomic,weak)id<AddContactDelegate>delegate;

//add Contacts
-(void) addContact:(NSString *)userId;

//acceptContacts
-(void) acceptContact:(NSString *)userId ;

//获取已经请求添加自己的联系人列表
-(void) getRequestedContacts;

@end
