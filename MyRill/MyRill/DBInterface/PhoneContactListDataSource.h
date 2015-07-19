//
//  PhoneContactListDataSource.h
//  MyRill
//
//  Created by Steve on 15/7/19.
//
//

#import <Foundation/Foundation.h>

@interface PhoneContactListDataSource : NSObject
+(PhoneContactListDataSource *) shareInstance;
-(NSArray*)getPhoneContactListFromDB;
-(void)updatePhoneContactList:(NSArray*)phoneContactList;

@end
