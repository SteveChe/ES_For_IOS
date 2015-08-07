//
//  EnterPriseRequestDataParse.m
//  MyRill
//
//  Created by Steve on 15/8/1.
//
//

#import "EnterPriseRequestDataParse.h"
#import "AFHttpTool.h"
#import "DataParseDefine.h"
#import "ESUserInfo.h"
#import "ESEnterPriseRequestInfo.h"

@implementation EnterPriseRequestDataParse
-(void)requestJoinEnterPriseWithUserId:(NSString*)userId
{
    [AFHttpTool requestJoinEnterPriseWithUserId:userId success:^(id response)
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
                 if (self.joinEnterPriseDelegate!= nil &&[self.joinEnterPriseDelegate respondsToSelector:@selector(requestJoinEnterPriseSucceed)])
                 {
                     [self.joinEnterPriseDelegate requestJoinEnterPriseSucceed];
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
                 if (self.joinEnterPriseDelegate!= nil &&[self.joinEnterPriseDelegate respondsToSelector:@selector(requestJoinEnterPriseFailed:)])
                 {
                     [self.joinEnterPriseDelegate requestJoinEnterPriseFailed:errorMessage];
                 }
             }
                 break;
         }
     }failure:^(NSError* err)
     {
         NSLog(@"%@",err);
         if (self.joinEnterPriseDelegate!= nil &&[self.joinEnterPriseDelegate respondsToSelector:@selector(requestJoinEnterPriseFailed:)])
         {
             [self.joinEnterPriseDelegate requestJoinEnterPriseFailed:@"网络请求失败"];
         }
     }];

}
     
-(void)getEnterPriseRequestList
{
    [AFHttpTool getEnterPriseRequestList:^(id response)
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
                     if (self.getEnterPriseRequestListDelegate!= nil && [self.getEnterPriseRequestListDelegate respondsToSelector:@selector(getEnterPriseRequestListSucceed:)])
                     {
                         [self.getEnterPriseRequestListDelegate getEnterPriseRequestListSucceed:nil];
                     }
                     break;
                 }
                 NSMutableArray* requestIdArray = [NSMutableArray array];
                 for (NSDictionary* temDic in listArray) {
                     ESEnterPriseRequestInfo* enterpriseRequestInfo = [[ESEnterPriseRequestInfo alloc] init];
                     NSNumber* requestIdNum = [temDic objectForKey:@"id"];
                     if (requestIdNum != nil && ![requestIdNum isEqual:[NSNull null]]) {
                         enterpriseRequestInfo.requestId = [NSString stringWithFormat:@"%d",[requestIdNum intValue] ];
                     }
                     NSNumber* requestReceiverIdNum = [temDic objectForKey:@"receiver"];
                     if (requestReceiverIdNum != nil && ![requestReceiverIdNum isEqual:[NSNull null]]) {
                         enterpriseRequestInfo.receiverId  = [NSString stringWithFormat:@"%d",[requestReceiverIdNum intValue] ];
                     }
                     NSNumber* requestEnterPriseIdNum = [temDic objectForKey:@"enterprise"];
                     if (requestEnterPriseIdNum != nil && ![requestEnterPriseIdNum isEqual:[NSNull null]] ) {
                         enterpriseRequestInfo.enterPriseId  = [NSString stringWithFormat:@"%d",[requestEnterPriseIdNum intValue] ];
                     }
                     enterpriseRequestInfo.bApproved = NO;
                     
                     ESUserInfo* senderUserInfo = [[ESUserInfo alloc] init];
                     NSDictionary* senderDic = [temDic objectForKey:@"sender"];
                     NSNumber* senderUserIdNum = [senderDic objectForKey:@"id"];
                     if (senderUserIdNum!=nil && ![senderUserIdNum isEqual:[NSNull null]] ) {
                         senderUserInfo.userId = [NSString stringWithFormat:@"%d",[senderUserIdNum intValue]];
                     }
                     
                     NSString* senderUserName = [senderDic objectForKey:@"name"];
                     if (senderUserName!=nil && ![senderUserName isEqual:[NSNull null]] && [senderUserName length] > 0) {
                         senderUserInfo.userName = senderUserName;
                     }
                     
                     NSString* senderPhoneNumber = [senderDic objectForKey:@"phone_number"];
                     if (senderPhoneNumber!=nil && ![senderPhoneNumber isEqual:[NSNull null]] && [senderPhoneNumber length] > 0) {
                         senderUserInfo.phoneNumber = senderPhoneNumber;
                     }
                     
                     NSString* senderEnterPrise = [senderDic objectForKey:@"enterprise"];
                     if (senderEnterPrise!=nil && ![senderEnterPrise isEqual:[NSNull null]] && [senderEnterPrise length]>0) {
                         senderUserInfo.enterprise = senderEnterPrise;
                     }
                     
                     NSString* senderPosition = [senderDic objectForKey:@"position"];
                     if (senderPosition!=nil && ![senderPosition isEqual:[NSNull null]] && [senderPosition length]>0) {
                         senderUserInfo.position = senderPosition;
                     }
                     
                     NSString* senderAvatar = [senderDic objectForKey:@"avatar"];
                     if (senderAvatar!=nil && ![senderAvatar isEqual:[NSNull null]] && [senderAvatar length]>0) {
                         senderUserInfo.portraitUri = senderAvatar;
                     }
                     enterpriseRequestInfo.sender = senderUserInfo;
                     [requestIdArray addObject:enterpriseRequestInfo];
                 }
                 
                 if (self.getEnterPriseRequestListDelegate!= nil &&[self.getEnterPriseRequestListDelegate respondsToSelector:@selector(getEnterPriseRequestListSucceed:)])
                 {
                     [self.getEnterPriseRequestListDelegate getEnterPriseRequestListSucceed:requestIdArray];
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
                 if (self.getEnterPriseRequestListDelegate!= nil &&[self.getEnterPriseRequestListDelegate respondsToSelector:@selector(getEnterPriseRequestListFailed:)])
                 {
                     [self.getEnterPriseRequestListDelegate getEnterPriseRequestListFailed:errorMessage];
                 }
             }
                 break;
         }
     }failure:^(NSError* err)
     {
         NSLog(@"%@",err);
         if (self.getEnterPriseRequestListDelegate!= nil &&[self.getEnterPriseRequestListDelegate respondsToSelector:@selector(getEnterPriseRequestListFailed:)])
         {
             [self.getEnterPriseRequestListDelegate getEnterPriseRequestListFailed:@"网络请求失败"];
         }
     }];

}
-(void)approvedEnterPriseRequest:(NSString*)requestId bApproved:(BOOL)bApproved
{
    [AFHttpTool approvedEnterPriseRequestId:requestId approved:bApproved success:^(id response)
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
                 
                 NSNumber* bApproved = [temDic objectForKey:@"approved"];
                 if (bApproved == nil || [bApproved isEqual:[NSNull null]] )
                 {
                     break;
                 }
                 
                 if ([bApproved boolValue])
                 {
                     if (self.approvedEnterPriseRequestDelegate!= nil &&[self.approvedEnterPriseRequestDelegate respondsToSelector:@selector(approvedEnterPriseRequestSucceed)])
                     {
                         [self.approvedEnterPriseRequestDelegate approvedEnterPriseRequestSucceed];
                     }
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
                 if (self.approvedEnterPriseRequestDelegate!= nil &&[self.approvedEnterPriseRequestDelegate respondsToSelector:@selector(approvedEnterPriseRequestFailed:)])
                 {
                     [self.approvedEnterPriseRequestDelegate approvedEnterPriseRequestFailed:errorMessage];
                 }
             }
                 break;
         }
     }failure:^(NSError* err)
     {
         NSLog(@"%@",err);
         if (self.joinEnterPriseDelegate!= nil &&[self.joinEnterPriseDelegate respondsToSelector:@selector(requestJoinEnterPriseFailed:)])
         {
             [self.joinEnterPriseDelegate requestJoinEnterPriseFailed:@"网络请求失败"];
         }
     }];
}
@end
