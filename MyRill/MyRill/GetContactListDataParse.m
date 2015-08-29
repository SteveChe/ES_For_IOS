//
//  GetContactListDataParse.m
//  MyRill
//
//  Created by Steve on 15/7/2.
//
//

#import "GetContactListDataParse.h"
#import "AFHttpTool.h"
#import "DataParseDefine.h"
#import "ESUserInfo.h"
#import "ESContactList.h"
#import "AddressBookContactListDataSource.h"
#import "ESEnterpriseInfo.h"

@implementation GetContactListDataParse

/******** 联系人列表******
 请求方式：GET
 参数：无
 备注：该接口返回当前用户所有的联系人信息
 **/
-(void) getContactList
{
//  NSArray* enterpriseContactListFromDB = [[AddressBookContactListDataSource shareInstance] getContactListFromDB];
//    if (enterpriseContactListFromDB!=nil && ! [enterpriseContactListFromDB isEqual:[NSNull null]]&& [enterpriseContactListFromDB count]>0)
//    {
//        if (self.delegate!= nil && [self.delegate respondsToSelector:@selector(getContactList:)])
//        {
//            [self.delegate getContactList:enterpriseContactListFromDB];
//        }
//    }
    [AFHttpTool getContactListSuccess:^(id response)
     {
         NSDictionary* reponseDic = (NSDictionary*)response;
         NSNumber* errorCodeNum = [reponseDic valueForKey:NETWORK_ERROR_CODE];
         if (errorCodeNum == nil || [errorCodeNum isEqual:[NSNull null]] )
         {
             return ;
         }
         
         int errorCode = [errorCodeNum intValue];
         switch (errorCode)
         {
             case 0:
             {
                 NSDictionary* dataDic = [reponseDic valueForKey:NETWORK_OK_DATA];
                 if (dataDic == nil || [dataDic isEqual:[NSNull null]])
                 {
                     break;
                 }
                 //     ['企业1', [成员1， 成员2，成员3...]
                 //     ['企业2', [成员1，成员2，...]
                 NSArray* dataListArray = [dataDic valueForKey:NETWORK_DATA_LIST];
                 if (dataListArray == nil || [dataListArray isEqual:[NSNull null]]
                     || [dataListArray count] <= 0)
                 {
                     break;
                 }
                 NSMutableArray* enterpriseList = [NSMutableArray array];
                 
                 for (NSDictionary* temArrayDic in dataListArray)
                 {
                     NSString* enterpriseName = [temArrayDic valueForKey:NETWORK_DATA_GROUP_TITLE];
                     NSArray* temContactArray = [temArrayDic valueForKey:NETWORK_DATA_GROUP_LIST];
                     if (temContactArray == nil || [temContactArray isEqual:[NSNull null]]
                         || enterpriseName == nil || [enterpriseName isEqual:[NSNull null]])
                     {
                         break;
                     }
                     if ([enterpriseName length] <=0)
                     {
                         enterpriseName = @"默认";
                     }
                     NSMutableArray* userInfoArray = [NSMutableArray array];
                     ESContactList* contactList = [[ESContactList alloc]init];
                     contactList.enterpriseName = enterpriseName;
                     contactList.contactList = userInfoArray;
                     for (NSDictionary* temDic in temContactArray)
                     {
                         ESUserInfo* userInfo = [[ESUserInfo alloc] init];
                         NSNumber* userId = [temDic valueForKey:@"id"];
                         if (userId != nil && ![userId isEqual:[NSNull null]])
                         {
                             userInfo.userId = [NSString stringWithFormat:@"%d",[userId intValue]];
                         }
                         
                         NSString* userName = [temDic valueForKey:@"name"];
                         if (userName != nil && ![userName isEqual:[NSNull null]])
                         {
                             userInfo.userName = userName;
                         }
                         NSString* userPhoneNum = [temDic valueForKey:@"phone_number"];
                         if (userPhoneNum != nil && ![userPhoneNum isEqual:[NSNull null]])
                         {
                             userInfo.phoneNumber = userPhoneNum;
                         }
                         NSDictionary* userEnterpriseDic = [temDic valueForKey:@"enterprise"];
                         if (userEnterpriseDic != nil && ![userEnterpriseDic isEqual:[NSNull null]])
                         {
                             ESEnterpriseInfo* enterpriseInfo = [[ESEnterpriseInfo alloc] initWithDic:userEnterpriseDic];
//                             if ([enterpriseInfo.enterpriseName length ]<=0)
//                             {
//                                 userEnterprise = @"默认";
//                             }
                             userInfo.enterprise = enterpriseInfo;
                         }
                         
                         NSString* userPortraitUri = [temDic valueForKey:@"avatar"];
                         if (userPortraitUri != nil && ![userPortraitUri isEqual:[NSNull null]])
                         {
                             userInfo.portraitUri = userPortraitUri;
                         }

                         userInfo.type = @"contact";
                         
                         [userInfoArray addObject:userInfo];
                     
                     }
                     
                     [enterpriseList addObject:contactList];
                 }
                 if (enterpriseList != nil && ![enterpriseList isEqual:[NSNull null]] && [enterpriseList count]>0)
                 {
//                     if (![enterpriseList isEqualToArray:enterpriseContactListFromDB])
//                     {
                         [[AddressBookContactListDataSource shareInstance] updateContactList:enterpriseList];
                         if (self.delegate!= nil && [self.delegate respondsToSelector:@selector(getContactList:)])
                         {
                             [self.delegate getContactList:enterpriseList];
                         }
//                     }

                 }

             }
                 break;
             default:
             {
                 NSString* errorMessage = [reponseDic valueForKey:NETWORK_ERROR_MESSAGE];
                 if(errorMessage==nil)
                     return;
                 
                 errorMessage= [errorMessage stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                 NSLog(@"%@",errorMessage);
                 if (self.delegate!= nil &&[self.delegate respondsToSelector:@selector(getContactListFailed:)])
                 {
                     [self.delegate getContactListFailed:errorMessage];
                 }
             }
                 break;
         }

     }failure:^(NSError* err)
     {
         NSLog(@"%@",err);
         if (self.delegate!= nil &&[self.delegate respondsToSelector:@selector(getContactListFailed:)])
         {
             [self.delegate getContactListFailed:@"网络请求失败"];
         }
     }];
}
@end
