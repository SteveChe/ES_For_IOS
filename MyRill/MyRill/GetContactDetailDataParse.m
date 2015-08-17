//
//  GetContactDetailDataParse.m
//  MyRill
//
//  Created by Steve on 15/7/15.
//
//

#import "GetContactDetailDataParse.h"
#import "ESUserDetailInfo.h"
#import "AFHttpTool.h"
#import "DataParseDefine.h"
#import "ESUserDetailInfo.h"
#import "UserInfoDataSource.h"
#import "ESEnterpriseInfo.h"

@implementation GetContactDetailDataParse
//获取联系人的详细信息
-(void) getContactDetail:(NSString*)userID
{
    [AFHttpTool getContactDetail:userID success:^(id response)
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
                 NSDictionary* temDic = [reponseDic valueForKey:NETWORK_OK_DATA];
                 if (temDic == nil || [temDic isEqual:[NSNull null]])
                 {
                     break;
                 }
                     
                     ESUserDetailInfo* userDetailInfo = [[ESUserDetailInfo alloc] init];
                     NSNumber* userId = [temDic valueForKey:@"id"];
                     if (userId != nil && ![userId isEqual:[NSNull null]])
                     {
                         userDetailInfo.userId = [NSString stringWithFormat:@"%d",[userId intValue]];
                     }
                     
                     NSString* userName = [temDic valueForKey:@"name"];
                     if (userName != nil && ![userName isEqual:[NSNull null]])
                     {
                         userDetailInfo.userName = userName;
                     }
                     NSString* userPhoneNum = [temDic valueForKey:@"phone_number"];
                     if (userPhoneNum != nil && ![userPhoneNum isEqual:[NSNull null]])
                     {
                         userDetailInfo.phoneNumber = userPhoneNum;
                     }
                     NSDictionary* userEnterpriseDic = [temDic valueForKey:@"enterprise"];
                     if (userEnterpriseDic != nil && ![userEnterpriseDic isEqual:[NSNull null]] )//&& [userEnterpriseDic isKindOfClass:[NSDictionary class]]
                     {
                         ESEnterpriseInfo* userEnterprise = [[ESEnterpriseInfo alloc] init];
                         NSNumber* enterPriseIdNum = [userEnterpriseDic valueForKey:@"id"];
                         if (enterPriseIdNum!=nil && ![enterPriseIdNum isEqual:[NSNull null]]) {
                             userEnterprise.enterpriseId = [NSString stringWithFormat:@"%d",[enterPriseIdNum intValue]];
                         }
                         
                         NSString* enterPriseName = [userEnterpriseDic valueForKey:@"name"];
                         if (enterPriseName!=nil && ![enterPriseName isEqual:[NSNull null]] && [enterPriseName length] > 0) {
                             userEnterprise.enterpriseName = enterPriseName;
                         }
                         
                         NSString* enterPriseCategory = [userEnterpriseDic valueForKey:@"category"];
                         if (enterPriseCategory!=nil && ![enterPriseCategory isEqual:[NSNull null]] && [enterPriseCategory length]>0) {
                             userEnterprise.enterpriseCategory = enterPriseCategory;
                         }
                         
                         NSString* enterPriseDes = [userEnterpriseDic valueForKey:@"description"];
                         if(enterPriseDes!=nil && ![enterPriseDes isEqual:[NSNull null] ] && [enterPriseDes length] >0 )
                         {
                             userEnterprise.enterpriseDescription = enterPriseDes;
                         }
                         
                         NSString* enterPriseQRCode = [userEnterpriseDic valueForKey:@"qrcode"];
                         if(enterPriseQRCode!=nil && ![enterPriseQRCode isEqual:[NSNull null]] && [enterPriseQRCode length] >0 ){
                             userEnterprise.enterpriseQRCode = enterPriseQRCode;
                         }
                         
                         NSNumber* enterPriseVerified = [userEnterpriseDic valueForKey:@"verified"];
                         if (enterPriseVerified!=nil && ![enterPriseVerified isEqual:[NSNull null]]) {
                             userEnterprise.bVerified = [enterPriseVerified boolValue];
                         }
                                                  
                         userDetailInfo.enterprise = userEnterprise;
                     }
                     
                     NSString* userPortraitUri = [temDic valueForKey:@"avatar"];
                     if (userPortraitUri != nil && ![userPortraitUri isEqual:[NSNull null]])
                     {
                         userDetailInfo.portraitUri = userPortraitUri;
                     }
                     
                     NSString* userPosition = [temDic valueForKey:@"position"];
                     if (userPosition != nil && ![userPosition isEqual:[NSNull null]])
                     {
                         userDetailInfo.position = userPosition;
                     }
                     NSString* gender = [temDic valueForKey:@"gender"];
                     if (gender != nil && ![gender isEqual:[NSNull null]])
                     {
                         userDetailInfo.gender = gender;
                     }

                     NSString* email = [temDic valueForKey:@"email"];
                     if (email != nil && ![email isEqual:[NSNull null]])
                     {
                         userDetailInfo.email = email;
                     }

                     NSString* qrcode = [temDic valueForKey:@"qrcode"];
                     if (qrcode != nil && ![qrcode isEqual:[NSNull null]])
                     {
                         userDetailInfo.qrcode = qrcode;
                     }
                 
                     NSString* enterprise_qrcode = [temDic valueForKey:@"enterprise_qrcode"];
                     if (enterprise_qrcode != nil && ![enterprise_qrcode isEqual:[NSNull null]])
                     {
                         userDetailInfo.enterprise_qrcode = enterprise_qrcode;
                     }
                 
                     NSMutableArray* tag_data = [temDic valueForKey:@"tag_data"];
                     if (tag_data != nil && ![tag_data isEqual:[NSNull null]])
                     {
                         userDetailInfo.tagDataArray = tag_data;
                     }
                     
                     NSNumber* is_member = [temDic valueForKey:@"is_member"];
                     if (is_member != nil && ![is_member isEqual:[NSNull null]])
                     {
                         userDetailInfo.bMember = [is_member boolValue];
                     }
                     NSNumber* is_contact = [temDic valueForKey:@"is_contact"];
                     if (is_contact != nil && ![is_contact isEqual:[NSNull null]])
                     {
                         userDetailInfo.bContact = [is_contact boolValue];
                     }
                 
                 if (self.delegate!= nil && [self.delegate respondsToSelector:@selector(getContactDetail:)])
                 {
                     [self.delegate getContactDetail:userDetailInfo];
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
                 if (self.delegate!= nil &&[self.delegate respondsToSelector:@selector(getContactDetailFailed:)])
                 {
                     [self.delegate getContactDetailFailed:errorMessage];
                 }
             }
                 break;
         }
     }failure:^(NSError* err)
     {
         NSLog(@"%@",err);
         if (self.delegate!= nil &&[self.delegate respondsToSelector:@selector(getContactDetailFailed:)])
         {
             [self.delegate getContactDetailFailed:@"网络请求失败"];
         }
     }];
}
@end
