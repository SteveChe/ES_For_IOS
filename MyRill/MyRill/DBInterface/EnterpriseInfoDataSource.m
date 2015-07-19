//
//  EnterpriseInfoDataSource.m
//  MyRill
//
//  Created by Steve on 15/7/19.
//
//

#import "EnterpriseInfoDataSource.h"
#import "DBHelper.h"
#import "ESEnterpriseInfo.h"

@interface EnterpriseInfoDataSource ()
-(void)createEnterpriseInfoTable;
@end
@implementation EnterpriseInfoDataSource
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self createEnterpriseInfoTable];
    }
    return self;
}

+(EnterpriseInfoDataSource *) shareInstance
{
    static EnterpriseInfoDataSource* instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        instance = [[[self class] alloc] init];
        
    });
    return instance;

}
static NSString * const enterTableName = @"ENTERPRISEINFO_TABLE";
-(void)createEnterpriseInfoTable
{
    FMDatabaseQueue *queue = [DBHelper getDatabaseQueue];
    [queue inDatabase:^(FMDatabase *db) {
        if (![DBHelper isTableOK: enterTableName withDB:db]) {
            NSString *createTableSQL = @"CREATE TABLE ENTERPRISEINFO_TABLE (id integer PRIMARY KEY autoincrement, enterprise_id text,name text, description text, qrcode text, verified integer)";
            [db executeUpdate:createTableSQL];
            NSString *createIndexSQL = @"CREATE INDEX idx_enterpriseid ON ENTERPRISEINFO_TABLE(enterprise_id);";
            [db executeUpdate:createIndexSQL];
        }
        
    }];
}

//存储企业信息
-(void)insertUserToDB:(ESEnterpriseInfo*)enterprise
{
    NSString *insertSql = @"REPLACE INTO ENTERPRISEINFO_TABLE (enterprise_id, name, description,qrcode,verified) VALUES (?, ?, ?, ?, ?, ?)";
    FMDatabaseQueue *queue = [DBHelper getDatabaseQueue];
    [queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:insertSql,enterprise.enterpriseId,enterprise.enterpriseName,enterprise.enterpriseDescription,enterprise.enterpriseQRCode,enterprise.bVerified];
    }];
}


//从表中获取企业信息
-(ESEnterpriseInfo*) getEnterpriseById:(NSString*)enterpriseId
{
    __block ESEnterpriseInfo *enterpriseInfo = nil;
    FMDatabaseQueue *queue = [DBHelper getDatabaseQueue];
    [queue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:@"SELECT * FROM ENTERPRISEINFO_TABLE where userid = ?",enterpriseId];
        while ([rs next]) {
            enterpriseInfo = [[ESEnterpriseInfo alloc] init];
            enterpriseInfo.enterpriseId = [rs stringForColumn:@"enterprise_id"];
            enterpriseInfo.enterpriseName = [rs stringForColumn:@"name"];
            enterpriseInfo.enterpriseDescription = [rs stringForColumn:@"description"];
            enterpriseInfo.enterpriseQRCode = [rs stringForColumn:@"qrcode"];
            enterpriseInfo.bVerified  = [rs intForColumn:@"verified"];
        }
        [rs close];
    }];
    return enterpriseInfo;
}




@end
