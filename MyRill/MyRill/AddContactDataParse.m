//
//  AddContactDataParse.m
//  MyRill
//
//  Created by Steve on 15/6/30.
//
//

#import "AddContactDataParse.h"
#import "AFHttpTool.h"
#import "DataParseDefine.h"
#import "ESUserInfo.h"

@implementation AddContactDataParse
//add Contacts
-(void) addContact:(NSString *)userId
{
    [AFHttpTool addContacts:userId success:^(id response)
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
                 if (self.delegate!= nil && [self.delegate respondsToSelector:@selector(addContactSucceed)])
                 {
                     [self.delegate addContactSucceed];
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
                 if (self.delegate!= nil &&[self.delegate respondsToSelector:@selector(addContactFailed:)])
                 {
                     [self.delegate addContactFailed:errorMessage];
                 }
             }
                 break;
         }
     }
    failure:^(NSError* err)
    {
        NSLog(@"%@",err);
        if (self.delegate!= nil &&[self.delegate respondsToSelector:@selector(addContactFailed:)])
        {
            [self.delegate addContactFailed:@"网络请求失败"];
        }
        
    }];
}

//acceptContacts
-(void) acceptContact:(NSString *)userId
{
    [AFHttpTool acceptContacts:userId success:^(id response)
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
                 if (self.delegate!= nil && [self.delegate respondsToSelector:@selector(acceptContactSucceed)])
                 {
                     [self.delegate acceptContactSucceed];
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
                 if (self.delegate!= nil &&[self.delegate respondsToSelector:@selector(acceptContactFailed:)])
                 {
                     [self.delegate acceptContactFailed:errorMessage];
                 }
             }
                 break;
         }
     }

    failure:^(NSError* err)
     {
         NSLog(@"%@",err);
         if (self.delegate!= nil &&[self.delegate respondsToSelector:@selector(acceptContactFailed:)])
         {
             [self.delegate acceptContactFailed:@"网络请求失败"];
         }
     }];
}

//获取已经请求添加自己的联系人列表
-(void) getRequestedContacts
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
                     break;
                 }
                 NSMutableArray* userInfoArray = [NSMutableArray array];
                 for (NSDictionary* temDic in listArray)
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
