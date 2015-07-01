//
//  SearchContactDataParse.m
//  MyRill
//
//  Created by Steve on 15/6/28.
//
//

#import "SearchContactDataParse.h"
#import "AFHttpTool.h"
#import "DataParseDefine.h"
#import "ESUserInfo.h"

@implementation SearchContactDataParse

-(void) searchContacts:(NSString *)searchText
{
    [AFHttpTool searchContacts:searchText  success:^(id response)
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

                 if (self.delegate!= nil && [self.delegate respondsToSelector:@selector(searchContactResult:)])
                 {
                     [self.delegate searchContactResult:userInfoArray];
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
                 if (self.delegate!= nil &&[self.delegate respondsToSelector:@selector(searchContactFailed:)])
                 {
                     [self.delegate searchContactFailed:errorMessage];
                 }
             }
                 break;
         }
     }
                       failure:^(NSError* err) {
                           if (self.delegate!= nil &&[self.delegate respondsToSelector:@selector(searchContactFailed:)])
                           {
                               [self.delegate searchContactFailed:@"网络连接失败"];
                           }
                       }];
}

@end
