//
//  GetEnterpriseListDataParse.m
//  MyRill
//
//  Created by Steve on 15/8/3.
//
//

#import "GetEnterpriseListDataParse.h"
#import "AFHttpTool.h"
#import "ESEnterpriseInfo.h"
#import "DataParseDefine.h"

@implementation GetEnterpriseListDataParse

/******** 获取企业联系人列表******
 请求方式：GET
 参数：无
 备注：该接口返回当前用户所有的联系人信息
 **/
-(void) getFollowedEnterpriseList
{
    [AFHttpTool getFollowedEnterpriseListSuccess:^(id response)
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
                 NSMutableArray* enterpriseInfoArray = [NSMutableArray array];
                 for (NSDictionary* temDic in listArray)
                 {
                     ESEnterpriseInfo* enterpriseInfo = [[ESEnterpriseInfo alloc] init];
                     NSNumber* enterpriseId = [temDic valueForKey:@"id"];
                     if (enterpriseId != nil && ![enterpriseId isEqual:[NSNull null]])
                     {
                         enterpriseInfo.enterpriseId = [NSString stringWithFormat:@"%d",[enterpriseId intValue]];
                     }
                     
                     NSString* enterpriseName = [temDic valueForKey:@"name"];
                     if (enterpriseName != nil && ![enterpriseName isEqual:[NSNull null]])
                     {
                         enterpriseInfo.enterpriseName = enterpriseName;
                     }
                     NSString* enterpriseCategory = [temDic valueForKey:@"category"];
                     if (enterpriseCategory != nil && ![enterpriseCategory isEqual:[NSNull null]])
                     {
                         enterpriseInfo.enterpriseCategory = enterpriseCategory;
                     }
                     NSString* enterpriseDes = [temDic valueForKey:@"description"];
                     if (enterpriseDes != nil && ![enterpriseDes isEqual:[NSNull null]])
                     {
                         enterpriseInfo.enterpriseDescription = enterpriseDes;
                     }
                     
                     NSString* enterpriseQRCode = [temDic valueForKey:@"qrcode"];
                     if (enterpriseQRCode != nil && ![enterpriseQRCode isEqual:[NSNull null]])
                     {
                         enterpriseInfo.enterpriseQRCode = enterpriseQRCode;
                     }
                     
                     NSNumber* bVerifiedNum = [temDic valueForKey:@"verified"];
                     if (bVerifiedNum != nil && [bVerifiedNum isEqual:[NSNull null]])
                     {
                         enterpriseInfo.bVerified = [bVerifiedNum boolValue];
                     }
                     
                     
                     [enterpriseInfoArray addObject:enterpriseInfo];
                     
                 }
                 
                 if (self.getFollowedEnterPriseListDelegate!= nil && [self.getFollowedEnterPriseListDelegate respondsToSelector:@selector(getFollowedEnterpriseListSucceed:)])
                 {
                     [self.getFollowedEnterPriseListDelegate getFollowedEnterpriseListSucceed:enterpriseInfoArray];
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
                 if (self.getFollowedEnterPriseListDelegate!= nil &&[self.getFollowedEnterPriseListDelegate respondsToSelector:@selector(getFollowedEnterpriseListFailed:)])
                 {
                     [self.getFollowedEnterPriseListDelegate getFollowedEnterpriseListFailed:errorMessage];
                 }
             }
                 break;
         }

     }failure:^(NSError* err)
     {
         NSLog(@"%@",err);
         if (self.getFollowedEnterPriseListDelegate!= nil &&[self.getFollowedEnterPriseListDelegate respondsToSelector:@selector(getFollowedEnterpriseListFailed:)])
         {
             [self.getFollowedEnterPriseListDelegate getFollowedEnterpriseListFailed:@"网络请求失败"];
         }
     }];
}

//搜索企业联系人
-(void) searchEnterprise:(NSString*)searchText
{
    [AFHttpTool searchEnterprises:searchText success:^(id response)
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
                 NSMutableArray* enterpriseInfoArray = [NSMutableArray array];
                 for (NSDictionary* temDic in listArray)
                 {
                     ESEnterpriseInfo* enterpriseInfo = [[ESEnterpriseInfo alloc] init];
                     NSNumber* enterpriseId = [temDic valueForKey:@"id"];
                     if (enterpriseId != nil && ![enterpriseId isEqual:[NSNull null]])
                     {
                         enterpriseInfo.enterpriseId = [NSString stringWithFormat:@"%d",[enterpriseId intValue]];
                     }
                     
                     NSString* enterpriseName = [temDic valueForKey:@"name"];
                     if (enterpriseName != nil && ![enterpriseName isEqual:[NSNull null]])
                     {
                         enterpriseInfo.enterpriseName = enterpriseName;
                     }
                     NSString* enterpriseCategory = [temDic valueForKey:@"category"];
                     if (enterpriseCategory != nil && ![enterpriseCategory isEqual:[NSNull null]])
                     {
                         enterpriseInfo.enterpriseCategory = enterpriseCategory;
                     }
                     NSString* enterpriseDes = [temDic valueForKey:@"description"];
                     if (enterpriseDes != nil && ![enterpriseDes isEqual:[NSNull null]])
                     {
                         enterpriseInfo.enterpriseDescription = enterpriseDes;
                     }
                     
                     NSString* enterpriseQRCode = [temDic valueForKey:@"qrcode"];
                     if (enterpriseQRCode != nil && ![enterpriseQRCode isEqual:[NSNull null]])
                     {
                         enterpriseInfo.enterpriseQRCode = enterpriseQRCode;
                     }
                     
                     NSNumber* bVerifiedNum = [temDic valueForKey:@"verified"];
                     if (bVerifiedNum != nil && [bVerifiedNum isEqual:[NSNull null]])
                     {
                         enterpriseInfo.bVerified = [bVerifiedNum boolValue];
                     }
                     
                     
                     [enterpriseInfoArray addObject:enterpriseInfo];
                     
                 }
                 
                 if (self.getSearchEnterpriseListDelegate!= nil && [self.getSearchEnterpriseListDelegate respondsToSelector:@selector(getSearchEnterpriseListSucceed:)])
                 {
                     [self.getSearchEnterpriseListDelegate getSearchEnterpriseListSucceed:enterpriseInfoArray];
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
                 if (self.getSearchEnterpriseListDelegate!= nil &&[self.getSearchEnterpriseListDelegate respondsToSelector:@selector(getSearchEnterpriseListFailed:)])
                 {
                     [self.getSearchEnterpriseListDelegate getSearchEnterpriseListFailed:errorMessage];
                 }
             }
                 break;
         }
     }failure:^(NSError* err)
     {
         NSLog(@"%@",err);
         if (self.getSearchEnterpriseListDelegate!= nil &&[self.getSearchEnterpriseListDelegate respondsToSelector:@selector(getSearchEnterpriseListFailed:)])
         {
             [self.getSearchEnterpriseListDelegate getSearchEnterpriseListFailed:@"网络请求失败"];
         }
     }];

}

@end
