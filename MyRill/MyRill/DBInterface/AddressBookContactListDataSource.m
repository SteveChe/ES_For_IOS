//
//  AddressBookContactListDataSource.m
//  MyRill
//
//  Created by Steve on 15/7/18.
//
//

#import "AddressBookContactListDataSource.h"
#import "ESContactList.h"
#import "UserInfoDataSource.h"


@interface AddressBookContactListDataSource ()
-(void)createAddressBookContactTable;
@end

@implementation AddressBookContactListDataSource
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self createAddressBookContactTable];
    }
    return self;
}

+ (AddressBookContactListDataSource*)shareInstance
{
    static AddressBookContactListDataSource* instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        instance = [[[self class] alloc] init];
        
    });
    return instance;
}


-(void)createAddressBookContactTable
{
    
}


@end
