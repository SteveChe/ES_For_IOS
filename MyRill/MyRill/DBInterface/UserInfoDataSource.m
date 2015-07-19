//
//  UserInfoDataSource.m
//  MyRill
//
//  Created by Steve on 15/7/18.
//
//

#import "UserInfoDataSource.h"
#import "ESUserInfo.h"
#import "DBHelper.h"

@interface UserInfoDataSource ()
-(void)createUserInfoTable;
@end

@implementation UserInfoDataSource
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self createUserInfoTable];
    }
    return self;
}

+(UserInfoDataSource *) shareInstance
{
    static UserInfoDataSource* instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        instance = [[[self class] alloc] init];
        
    });
    return instance;
}

static NSString * const userTableName = @"USERINFO_TABLE";

//创建用户存储表
-(void)createUserInfoTable
{
    FMDatabaseQueue *queue = [DBHelper getDatabaseQueue];
    [queue inDatabase:^(FMDatabase *db) {
        if (![DBHelper isTableOK: userTableName withDB:db]) {
            NSString *createTableSQL = @"CREATE TABLE USERINFO_TABLE (user_id text not null PRIMARY KEY,name text, portrait_uri text, phone_number text, enterprise text, position text, type text, status integer)";
            [db executeUpdate:createTableSQL];
//            NSString *createIndexSQL = @"CREATE INDEX idx_userid ON USERINFO_TABLE(user_id);";
//            [db executeUpdate:createIndexSQL];
        }
        
    }];
}

//存储用户信息
-(void)insertUserToDB:(ESUserInfo*)user
{
    NSString *insertSql = @"REPLACE INTO USERINFO_TABLE (user_id, name, portrait_uri,phone_number,enterprise,position,type,status) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
    FMDatabaseQueue *queue = [DBHelper getDatabaseQueue];
    [queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:insertSql,user.userId,user.userName,user.portraitUri,user.phoneNumber,user.enterprise,user.position,user.type,user.status];
    }];
}

//从表中获取用户信息
-(ESUserInfo*) getUserByUserId:(NSString*)userId
{
    __block ESUserInfo *userInfo = nil;
    FMDatabaseQueue *queue = [DBHelper getDatabaseQueue];
    [queue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:@"SELECT * FROM USERINFO_TABLE where user_id = ?",userId];
        while ([rs next]) {
            userInfo = [[ESUserInfo alloc] init];
            userInfo.userId = [rs stringForColumn:@"user_id"];
            userInfo.userName = [rs stringForColumn:@"name"];
            userInfo.portraitUri = [rs stringForColumn:@"portrait_uri"];
            userInfo.phoneNumber = [rs stringForColumn:@"phone_number"];
            userInfo.enterprise = [rs stringForColumn:@"enterprise"];
            userInfo.position = [rs stringForColumn:@"position"];
            userInfo.type = [rs stringForColumn:@"type"];
            userInfo.status = [rs intForColumn:@"status"];            
        }
        [rs close];
    }];
    return userInfo;
}

//从表中获取所有联系人的信息
-(NSArray*) getAddressBookContactList
{
    
    __block NSMutableArray *contactList = nil;
    FMDatabaseQueue *queue = [DBHelper getDatabaseQueue];
    [queue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:@"SELECT * FROM USERINFO_TABLE where type = 'contact'"];//
        contactList = [[NSMutableArray alloc] init];
        while ([rs next]) {
            ESUserInfo* userInfo = [[ESUserInfo alloc] init];
            userInfo.userId = [rs stringForColumn:@"user_id"];
            userInfo.userName = [rs stringForColumn:@"name"];
            userInfo.portraitUri = [rs stringForColumn:@"portrait_uri"];
            userInfo.phoneNumber = [rs stringForColumn:@"phone_number"];
            userInfo.enterprise = [rs stringForColumn:@"enterprise"];
            userInfo.position = [rs stringForColumn:@"position"];
            userInfo.type = [rs stringForColumn:@"type"];
            userInfo.status = [rs intForColumn:@"status"];
            [contactList addObject:userInfo];
        }
        [rs close];
    }];
    return contactList;
}

-(void) insertContactList:(NSArray*)contactList
{
    if (contactList == nil || [contactList isEqual:[NSNull null] ]
                               || [contactList count]<=0 )
    {
        return;
    }
    for ( ESUserInfo* userInfo in contactList)
    {
        [self insertUserToDB:userInfo];
    }
}
@end
