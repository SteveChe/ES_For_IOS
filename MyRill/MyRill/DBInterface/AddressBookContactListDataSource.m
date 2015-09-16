//
//  AddressBookContactListDataSource.m
//  MyRill
//
//  Created by Steve on 15/7/18.
//
//

#import "AddressBookContactListDataSource.h"
#import "ESUserInfo.h"
#import "ESContactList.h"
#import "UserInfoDataSource.h"
#import "ESEnterpriseInfo.h"


@interface AddressBookContactListDataSource ()
@end

@implementation AddressBookContactListDataSource
- (instancetype)init
{
    self = [super init];
    if (self) {
//        [self createAddressBookContactTable];
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


//-(void)createAddressBookContactTable
//{
//    
//}


-(NSArray*)getContactListFromDB
{
    NSArray* contactList = [[UserInfoDataSource shareInstance] getAddressBookContactList];
    if (contactList == nil || [contactList isEqual:[NSNull null]]
        || [contactList count] <= 0)
    {
        return nil;
    }
    
    NSMutableArray* enterpriseContactList = [[NSMutableArray alloc] init ];
    for (ESUserInfo* userInfo in contactList)
    {
        BOOL bFindEnterprise = FALSE;
        for (ESContactList* temContactList in enterpriseContactList)
        {
            if ([userInfo.enterprise.enterpriseName isEqual:temContactList.enterpriseName])
            {
                bFindEnterprise = true;
                [temContactList.contactList addObject:userInfo ];
                break;
            }
        }
        if (!bFindEnterprise)
        {
            ESContactList* newContactList = [[ESContactList alloc] init];
            NSMutableArray* temContactList = [[NSMutableArray alloc] init];
            [temContactList addObject:userInfo];
            newContactList.enterpriseName = userInfo.enterprise.enterpriseName;
            newContactList.contactList = temContactList;
            
            [enterpriseContactList addObject:newContactList];
        }
    }
    
    return enterpriseContactList;
}
-(void)updateContactList:(NSArray*)enterpriseContactList
{
    if (enterpriseContactList == nil || [enterpriseContactList isEqual:[NSNull null]] || [enterpriseContactList count] <= 0)
    {
        return;
    }
    NSMutableArray* userInfoArray = [[NSMutableArray alloc] init];
    for (ESContactList* contactList in enterpriseContactList)
    {
        for (ESUserInfo* userInfo in contactList.contactList)
        {
            [userInfoArray addObject:userInfo];
        }
    }
//数据库
    //    if ([userInfoArray count]>0)
//    {
//        [[UserInfoDataSource shareInstance] insertContactList:userInfoArray];
//    }
}

@end
