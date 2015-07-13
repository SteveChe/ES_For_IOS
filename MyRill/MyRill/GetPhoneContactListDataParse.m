//
//  GetPhoneContactListDataParse.m
//  MyRill
//
//  Created by Steve on 15/7/10.
//
//

#import "GetPhoneContactListDataParse.h"
#import "AFHttpTool.h"
#import "ESUserInfo.h"
#import "DataParseDefine.h"
@implementation GetPhoneContactListDataParse
//获取手机通讯录中的ES联系人
-(void) getPhoneContactList:(NSMutableArray*)phoneContactList
{
    [AFHttpTool getPhoneContactList:phoneContactList success:^(id response)
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
                 NSDictionary* responseData = [reponseDic valueForKey:NETWORK_OK_DATA];
                 if (responseData == nil || [responseData isEqual:[NSNull null]])
                 {
                     break;
                 }
                 NSArray* listArray = [responseData valueForKey:NETWORK_DATA_LIST];
                 if (listArray == nil || [listArray isEqual:[NSNull null]]
                     || [listArray count] <= 0)
                 {
                     break;
                 }
                 NSMutableArray* userInfoArray = [NSMutableArray array];
                 for (NSDictionary* temDic in listArray)
                 {
//                     NSDictionary* userDic = [temDic valueForKey:@"user"];
                     if (temDic == nil || [temDic isEqual:[NSNull null]])
                     {
                         break;
                     }
                     
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
                     NSString* userEnterprise = [temDic valueForKey:@"enterprise"];
                     if (userEnterprise != nil && ![userEnterprise isEqual:[NSNull null]])
                     {
                         userInfo.enterprise = userEnterprise;
                     }
                     
                     NSString* userPortraitUri = [temDic valueForKey:@"avatar"];
                     if (userPortraitUri != nil && ![userPortraitUri isEqual:[NSNull null]])
                     {
                         userInfo.portraitUri = userPortraitUri;
                     }
                     
                     NSString* userPosition = [temDic valueForKey:@"position"];
                     if (userPosition != nil && ![userPosition isEqual:[NSNull null]])
                     {
                         userInfo.position = userPosition;
                     }
                     NSString* type = [temDic valueForKey:@"type"];
                     if (userPosition != nil && ![userPosition isEqual:[NSNull null]])
                     {
                         userInfo.type = type;
                     }
                     
                     [userInfoArray addObject:userInfo];
                 }
                 
                 if (self.delegate!= nil && [self.delegate respondsToSelector:@selector(getPhoneContactList:)])
                 {
                     [self.delegate getPhoneContactList:userInfoArray];
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
                 if (self.delegate!= nil &&[self.delegate respondsToSelector:@selector(getPhoneContactListFailed:)])
                 {
                     [self.delegate getPhoneContactListFailed:errorMessage];
                 }
             }
                 break;
         }
     }failure:^(NSError* err)
     {
         NSLog(@"%@",err);
         if (self.delegate!= nil &&[self.delegate respondsToSelector:@selector(getPhoneContactListFailed:)])
         {
             [self.delegate getPhoneContactListFailed:@"网络请求失败"];
         }
     }];
}

@end
