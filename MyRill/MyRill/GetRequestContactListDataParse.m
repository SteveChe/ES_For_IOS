//
//  GetRequestContactListDataParse.m
//  MyRill
//
//  Created by Steve on 15/7/2.
//
//

#import "GetRequestContactListDataParse.h"
#import "AFHttpTool.h"
#import "DataParseDefine.h"
#import "ESUserInfo.h"
#import "ESEnterpriseInfo.h"

@implementation GetRequestContactListDataParse
//获取已经请求添加自己的联系人列表
-(void)getRequestedContactList

{
    [AFHttpTool getContactRequestSuccess:^(id response)
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
                 NSArray* listArray = [dataDic valueForKey:NETWORK_DATA_LIST];
                 if (listArray == nil || [listArray isEqual:[NSNull null]]
                     || [listArray count] <= 0)
                 {
                     if (self.delegate!= nil && [self.delegate respondsToSelector:@selector(getRequestedContactList:)])
                     {
                         [self.delegate getRequestedContactList:nil];
                     }
                     break;
                 }
                 NSMutableArray* userInfoArray = [NSMutableArray array];
                 for (NSDictionary* temDic in listArray)
                 {
                     NSDictionary* userDic = [temDic valueForKey:@"user"];
                     if (userDic == nil || [userDic isEqual:[NSNull null]])
                     {
                         if (self.delegate!= nil && [self.delegate respondsToSelector:@selector(getRequestedContactList:)])
                         {
                             [self.delegate getRequestedContactList:nil];
                         }
                     }
                     
                     ESUserInfo* userInfo = [[ESUserInfo alloc] init];
                     NSNumber* userId = [userDic valueForKey:@"id"];
                     if (userId != nil && ![userId isEqual:[NSNull null]])
                     {
                         userInfo.userId = [NSString stringWithFormat:@"%d",[userId intValue]];
                     }
                     
                     NSString* userName = [userDic valueForKey:@"name"];
                     if (userName != nil && ![userName isEqual:[NSNull null]])
                     {
                         userInfo.userName = userName;
                     }
                     NSString* userPhoneNum = [userDic valueForKey:@"phone_number"];
                     if (userPhoneNum != nil && ![userPhoneNum isEqual:[NSNull null]])
                     {
                         userInfo.phoneNumber = userPhoneNum;
                     }

                     NSDictionary* userEnterpriseDic = [temDic valueForKey:@"enterprise"];
                     if (userEnterpriseDic != nil && [userEnterpriseDic isKindOfClass:[NSDictionary class]])
                     {
                         ESEnterpriseInfo* enterpriseInfo = [[ESEnterpriseInfo alloc] initWithDic:userEnterpriseDic];
                         userInfo.enterprise = enterpriseInfo;
                     }

                     
                     NSString* userPortraitUri = [userDic valueForKey:@"avatar"];
                     if (userPortraitUri != nil && ![userPortraitUri isEqual:[NSNull null]])
                     {
                         userInfo.portraitUri = userPortraitUri;
                     }
                     
                     [userInfoArray addObject:userInfo];
                     
                 }
                 
                 if (self.delegate!= nil && [self.delegate respondsToSelector:@selector(getRequestedContactList:)])
                 {
                     [self.delegate getRequestedContactList:userInfoArray];
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
                 if (self.delegate!= nil &&[self.delegate respondsToSelector:@selector(getRequestedContactListFailed:)])
                 {
                     [self.delegate getRequestedContactListFailed:errorMessage];
                 }
             }
                 break;
         }
     }failure:^(NSError* err)
     {
         NSLog(@"%@",err);
         if (self.delegate!= nil &&[self.delegate respondsToSelector:@selector(getRequestedContactListFailed:)])
         {
             [self.delegate getRequestedContactListFailed:@"网络请求失败"];
         }
     }];
}

@end
