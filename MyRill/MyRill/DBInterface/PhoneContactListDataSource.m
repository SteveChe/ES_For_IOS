//
//  PhoneContactListDataSource.m
//  MyRill
//
//  Created by Steve on 15/7/19.
//
//

#import "PhoneContactListDataSource.h"
#import "UserInfoDataSource.h"

@implementation PhoneContactListDataSource
- (instancetype)init
{
    self = [super init];
    if (self) {
        //        [self createAddressBookContactTable];
    }
    return self;
}

+ (PhoneContactListDataSource*)shareInstance
{
    static PhoneContactListDataSource* instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        instance = [[[self class] alloc] init];
        
    });
    return instance;
}

-(NSArray*)getPhoneContactListFromDB
{
    NSArray* phoneContactList = [[UserInfoDataSource shareInstance] getPhoneAddressBookContactList];
    if (phoneContactList == nil || [phoneContactList isEqual:[NSNull null]]
        || [phoneContactList count] <= 0)
    {
        return nil;
    }
    return phoneContactList;
}

-(void)updatePhoneContactList:(NSArray*)phoneContactList
{
    if (phoneContactList == nil || [phoneContactList isEqual:[NSNull null]] || [phoneContactList count] <= 0)
    {
        return;
    }
    [[UserInfoDataSource shareInstance] insertContactList:phoneContactList];
}

@end
