//
//  GetEnterpriseMessageDataParse.m
//  MyRill
//
//  Created by Steve on 15/8/8.
//
//

#import "GetEnterpriseMessageDataParse.h"
#import "AFHttpTool.h"
#import "DataParseDefine.h"
#import "ESEnterpriseMessage.h"
#import "ESEnterpriseInfo.h"
#import "ESEnterpriseMessageContent.h"
#import "ESUserInfo.h"

@interface GetEnterpriseMessageDataParse()

-(ESEnterpriseMessage*)parseEnterpriseMessage:(NSDictionary*)messageDic;
@end

@implementation GetEnterpriseMessageDataParse

//获取最新消息
-(void)getLastestMessage
{
    [AFHttpTool getLastestMessageSucess:^(id response)
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
                NSMutableDictionary* enterpriseMessageDicList = [[NSMutableDictionary alloc] init];
                NSDictionary* rillMessageDic = [temDic objectForKey:@"riil"];
                if (rillMessageDic != nil && [rillMessageDic isKindOfClass:[NSDictionary class]]  )
                {
                    ESEnterpriseMessage* rillMessage = [self parseEnterpriseMessage:rillMessageDic];
                    if (rillMessage != nil)
                    {
                        [enterpriseMessageDicList setObject:rillMessage forKey:@"riil"];
                    }
                }
                
                NSDictionary* enterpriseMessageDic = [temDic objectForKey:@"enterprise"];
                if (enterpriseMessageDic != nil && [enterpriseMessageDic isKindOfClass:[NSDictionary class]] )
                {
                    ESEnterpriseMessage* enterpriseMessage = [self parseEnterpriseMessage:enterpriseMessageDic];
                    if (enterpriseMessage != nil)
                    {
                        [enterpriseMessageDicList setObject:enterpriseMessage forKey:@"enterprise"];
                    }
                }
                
                if (self.getLastestMessageDelegate!= nil &&[self.getLastestMessageDelegate respondsToSelector:@selector(getLastestMessageSucceed:)])
                {
                    [self.getLastestMessageDelegate getLastestMessageSucceed:enterpriseMessageDicList];
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
                if (self.getLastestMessageDelegate!= nil &&[self.getLastestMessageDelegate respondsToSelector:@selector(getLastestMessageFailed:)])
                {
                    [self.getLastestMessageDelegate getLastestMessageFailed:errorMessage];
                }
            }
                break;
        }
    }failure:^(NSError* err)
    {
        NSLog(@"%@",err);
        if (self.getLastestMessageDelegate!= nil &&[self.getLastestMessageDelegate respondsToSelector:@selector(getLastestMessageFailed:)])
        {
            [self.getLastestMessageDelegate getLastestMessageFailed:@"网络请求失败"];
        }
    }];

}

-(void)getRillMessageList
{
    [AFHttpTool getRillMessageListSucess:^(id response)
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
                 NSArray* listArray = [temDic valueForKey:NETWORK_DATA_LIST];
                 if (listArray == nil || [listArray isEqual:[NSNull null]]
                     || [listArray count] <= 0)
                 {
                     if (self.getRillMessageListDelegate!= nil && [self.getRillMessageListDelegate respondsToSelector:@selector(getRILLMessageSucceed:)])
                     {
                         [self.getRillMessageListDelegate getRILLMessageSucceed:nil];
                     }
                     break;
                 }
                 NSMutableArray* enterpriseMessageList = [[NSMutableArray alloc] init];
                 
                 for(NSDictionary * enterpriseMessageDic in listArray)
                 {
                     if (enterpriseMessageDic == nil || ![enterpriseMessageDic isKindOfClass:[NSDictionary class]])
                     {
                         continue;
                     }
                     ESEnterpriseMessage* enterpriseMessage = [self parseEnterpriseMessage:enterpriseMessageDic];
                     if (enterpriseMessage!= nil)
                     {
                         [enterpriseMessageList addObject:enterpriseMessage];
                     }
                 }
                 
                
                 if (self.getRillMessageListDelegate!= nil &&[self.getRillMessageListDelegate respondsToSelector:@selector(getRILLMessageSucceed:)])
                 {
                     [self.getRillMessageListDelegate getRILLMessageSucceed:enterpriseMessageList];
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
                 if (self.getRillMessageListDelegate!= nil &&[self.getRillMessageListDelegate respondsToSelector:@selector(getRILLMessageFailed:)])
                 {
                     [self.getRillMessageListDelegate getRILLMessageFailed:errorMessage];
                 }
             }
                 break;
         }
     }failure:^(NSError* err)
     {
         NSLog(@"%@",err);
         if (self.getRillMessageListDelegate!= nil &&[self.getRillMessageListDelegate respondsToSelector:@selector(getRILLMessageFailed:)])
         {
             [self.getRillMessageListDelegate getRILLMessageFailed:@"网络请求失败"];
         }
     }];
}
-(void)replyToRillMessage:(NSString*)content
{
    [AFHttpTool replyToRillMessage:content sucess:^(id response)
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
                 
                 if (self.replyToRillMessageDelegate!= nil &&[self.replyToRillMessageDelegate respondsToSelector:@selector(replyToRillMessageSucceed)])
                 {
                     [self.replyToRillMessageDelegate replyToRillMessageSucceed];
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
                 if (self.replyToRillMessageDelegate!= nil &&[self.replyToRillMessageDelegate respondsToSelector:@selector(replyToRillMessageFailed:)])
                 {
                     [self.replyToRillMessageDelegate replyToRillMessageFailed:errorMessage];
                 }
             }
                 break;
         }
     }failure:^(NSError* err)
     {
         NSLog(@"%@",err);
         if (self.replyToRillMessageDelegate!= nil &&[self.replyToRillMessageDelegate respondsToSelector:@selector(getLastestMessageFailed:)])
         {
             [self.replyToRillMessageDelegate replyToRillMessageFailed:@"网络请求失败"];
         }
     }];
}

//获取所有企业的最后一条消息列表
-(void)getAllEnterpriseLastestMessageList
{
    [AFHttpTool getAllEnterpriseLastestMessageListSucess:^(id response)
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
                 NSArray* listArray = [temDic valueForKey:NETWORK_DATA_LIST];
                 if (listArray == nil || [listArray isEqual:[NSNull null]]
                     || [listArray count] <= 0)
                 {
                     if (self.getAllEnterpriseLastestMessageListDelegate!= nil && [self.getAllEnterpriseLastestMessageListDelegate respondsToSelector:@selector(getALLEnterpriseLastestMessageListSucceed:)])
                     {
                         [self.getAllEnterpriseLastestMessageListDelegate getALLEnterpriseLastestMessageListSucceed:nil];
                     }
                     break;
                 }
                 NSMutableArray* enterpriseMessageList = [[NSMutableArray alloc] init];
                 
                 for(NSDictionary * enterpriseMessageDic in listArray)
                 {
                     if (enterpriseMessageDic == nil || ![enterpriseMessageDic isKindOfClass:[NSDictionary class]])
                     {
                         continue;
                     }
                     ESEnterpriseMessage* enterpriseMessage = [self parseEnterpriseMessage:enterpriseMessageDic];
                     if (enterpriseMessage!= nil)
                     {
                         [enterpriseMessageList addObject:enterpriseMessage];
                     }
                 }
                 
                 
                 if (self.getAllEnterpriseLastestMessageListDelegate!= nil &&[self.getAllEnterpriseLastestMessageListDelegate respondsToSelector:@selector(getALLEnterpriseLastestMessageListSucceed:)])
                 {
                     [self.getAllEnterpriseLastestMessageListDelegate getALLEnterpriseLastestMessageListSucceed:enterpriseMessageList];
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
                 if (self.getAllEnterpriseLastestMessageListDelegate!= nil &&[self.getAllEnterpriseLastestMessageListDelegate respondsToSelector:@selector(getALLEnterpriseLastestMessageListFailed:)])
                 {
                     [self.getAllEnterpriseLastestMessageListDelegate getALLEnterpriseLastestMessageListFailed:errorMessage];
                 }
             }
                 break;
         }
     }failure:^(NSError* err)
     {
         NSLog(@"%@",err);
         if (self.getAllEnterpriseLastestMessageListDelegate!= nil &&[self.getAllEnterpriseLastestMessageListDelegate respondsToSelector:@selector(getALLEnterpriseLastestMessageListFailed:)])
         {
             [self.getAllEnterpriseLastestMessageListDelegate getALLEnterpriseLastestMessageListFailed:@"网络请求失败"];
         }
     }];

}

//获取一个企业的所有消息
-(void)getOneEnterpriseMessage:(NSString*)enterpriseId
{
    [AFHttpTool getOneEnterpriseMessage:enterpriseId sucess:^(id response)
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
                 NSArray* listArray = [temDic valueForKey:NETWORK_DATA_LIST];
                 if (listArray == nil || [listArray isEqual:[NSNull null]]
                     || [listArray count] <= 0)
                 {
                     if (self.getOneEnterpriseMessageListDelegate!= nil && [self.getOneEnterpriseMessageListDelegate respondsToSelector:@selector(getOneEnterpriseMessageListSucceed:)])
                     {
                         [self.getOneEnterpriseMessageListDelegate getOneEnterpriseMessageListSucceed:nil];
                     }
                     break;
                 }
                 NSMutableArray* enterpriseMessageList = [[NSMutableArray alloc] init];
                 
                 for(NSDictionary * enterpriseMessageDic in listArray)
                 {
                     if (enterpriseMessageDic == nil || ![enterpriseMessageDic isKindOfClass:[NSDictionary class]])
                     {
                         continue;
                     }
                     
                     ESEnterpriseMessage* enterpriseMessage = [self parseEnterpriseMessage:enterpriseMessageDic];
                     if (enterpriseMessage!= nil)
                     {
                         [enterpriseMessageList addObject:enterpriseMessage];
                     }
                 }
                 
                 
                 if (self.getOneEnterpriseMessageListDelegate!= nil &&[self.getOneEnterpriseMessageListDelegate respondsToSelector:@selector(getOneEnterpriseMessageListSucceed:)])
                 {
                     [self.getOneEnterpriseMessageListDelegate getOneEnterpriseMessageListSucceed:enterpriseMessageList];
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
                 if (self.getOneEnterpriseMessageListDelegate!= nil &&[self.getOneEnterpriseMessageListDelegate respondsToSelector:@selector(getOneEnterpriseMessageListFailed:)])
                 {
                     [self.getOneEnterpriseMessageListDelegate getOneEnterpriseMessageListFailed:errorMessage];
                 }
             }
                 break;
         }
     }failure:^(NSError* err)
     {
         NSLog(@"%@",err);
         if (self.getOneEnterpriseMessageListDelegate!= nil &&[self.getOneEnterpriseMessageListDelegate respondsToSelector:@selector(getOneEnterpriseMessageListFailed:)])
         {
             [self.getOneEnterpriseMessageListDelegate getOneEnterpriseMessageListFailed:@"网络请求失败"];
         }
     }];
}

//向企业发送消息
-(void)replyToOneEnterpriseMessage:(NSString*)enterpriseId content:(NSString*)content
{
    [AFHttpTool replyToOneEnterpriseMessage:enterpriseId content:content sucess:^(id response)
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
                 
                 if (self.replyToOneEnterpriseMessageDelegate!= nil &&[self.replyToOneEnterpriseMessageDelegate respondsToSelector:@selector(replyOneEnterpriseMessageSucceed)])
                 {
                     [self.replyToOneEnterpriseMessageDelegate replyOneEnterpriseMessageSucceed];
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
                 if (self.replyToOneEnterpriseMessageDelegate!= nil &&[self.replyToOneEnterpriseMessageDelegate respondsToSelector:@selector(replyOneEnterpriseMessageFailed:)])
                 {
                     [self.replyToOneEnterpriseMessageDelegate replyOneEnterpriseMessageFailed:errorMessage];
                 }
             }
             break;
         }
     }failure:^(NSError* err)
     {
         NSLog(@"%@",err);
         if (self.replyToOneEnterpriseMessageDelegate!= nil &&[self.replyToOneEnterpriseMessageDelegate respondsToSelector:@selector(replyOneEnterpriseMessageFailed:)])
         {
             [self.replyToOneEnterpriseMessageDelegate replyOneEnterpriseMessageFailed:@"网络请求失败"];
         }
     }];
}

-(ESEnterpriseMessage*)parseEnterpriseMessage:(NSDictionary*)messageDic
{
    if (messageDic == nil || ![messageDic isKindOfClass:[NSDictionary class]])
    {
        return  nil;
    }
    ESEnterpriseMessage* enterpriseMessage = [[ESEnterpriseMessage alloc] init];
    NSNumber* message_idNum = [messageDic objectForKey:@"id"];
    if (message_idNum != nil && ![message_idNum isEqual:[NSNull null]])
    {
        enterpriseMessage.message_id = [NSString stringWithFormat:@"%d",[message_idNum intValue]];
    }
    NSDictionary* entetpriseDic = [messageDic objectForKey:@"enterprise"];
    if (entetpriseDic != nil && ![entetpriseDic isEqual:[NSNull null]])
    {
        ESEnterpriseInfo* enterpriseInfo = [[ESEnterpriseInfo alloc] init];

        NSNumber* enter_idNum = [entetpriseDic objectForKey:@"id"];
        if (enter_idNum != nil && ![enter_idNum isEqual:[NSNull null]])
        {
            enterpriseInfo.enterpriseId = [NSString stringWithFormat:@"%d",[enter_idNum intValue]];
        }
        
        NSString* enterpriseName = [entetpriseDic objectForKey:@"name"];
        if (enterpriseName!= nil && ![enterpriseName isEqual:[NSNull null]] &&  [enterpriseName length] > 0)
        {
            enterpriseInfo.enterpriseName = enterpriseName;
        }
        
        NSString* enterprisePortraitUrl = [entetpriseDic objectForKey:@"avatar"];
        if (enterprisePortraitUrl != nil && ![enterprisePortraitUrl isEqual:[NSNull null]] && [enterprisePortraitUrl length] >0 )
        {
            enterpriseInfo.portraitUri = enterprisePortraitUrl;
        }
        enterpriseMessage.send_enterprise = enterpriseInfo;
    }

    NSDictionary* receiverDic = [messageDic objectForKey:@"receiver"];
    if (receiverDic!=nil && ![receiverDic isEqual:[NSNull null]])
    {
        ESUserInfo* receiverUserInfo = [[ESUserInfo alloc] init];
        NSNumber* userIdNum = [receiverDic objectForKey:@"id"];
        if (userIdNum != nil && ![userIdNum isEqual:[NSNull null]])
        {
            receiverUserInfo.userId = [NSString stringWithFormat:@"%d",[userIdNum intValue]];
        }
        NSString* userName = [receiverDic objectForKey:@"name"];
        if (userName != nil && ![userName isEqual:[NSNull null]])
        {
            receiverUserInfo.userName = userName;
        }
        NSString* userPortraitUrl = [receiverDic objectForKey:@"avatar"];
        if (userPortraitUrl != nil && ![userPortraitUrl isEqual:[NSNull null]]&& [userPortraitUrl length] > 0)
        {
            receiverUserInfo.portraitUri = userPortraitUrl;
        }
        enterpriseMessage.receiver_userInfo = receiverUserInfo;
    }
    
    NSDictionary* messageContentDic = [messageDic objectForKey:@"enterprise_message"];
    if (messageContentDic != nil && ![messageContentDic isEqual:[NSNull null]])
    {
        ESEnterpriseMessageContent* enterpriseMessageContent = [[ESEnterpriseMessageContent alloc] init];
        NSString* title = [messageContentDic objectForKey:@"title"];
        if (title != nil && ![title isEqual:[NSNull null]] && [title length]>0)
        {
            enterpriseMessageContent.title = title;
        }
        
        NSString* imageUrl = [messageContentDic objectForKey:@"image"];
        if (imageUrl != nil && ![imageUrl isEqual:[NSNull null]] && [imageUrl length] > 0)
        {
            enterpriseMessageContent.imageUrl = imageUrl;
        }
        
        NSString* content = [messageContentDic objectForKey:@"content"];
        if (content != nil && ![content isEqual:[NSNull null]] && [content length] > 0)
        {
            enterpriseMessageContent.content = content;
        }
        
        NSNumber* bLinkNum = [messageContentDic objectForKey:@"is_link_content"];
        if (bLinkNum != nil && ![bLinkNum isEqual:[NSNull null]])
        {
            enterpriseMessageContent.bLink = [bLinkNum boolValue];
        }
        
        NSString* linkUrl = [messageContentDic objectForKey:@"link"];
        if (linkUrl != nil && ![linkUrl isEqual:[NSNull null]] && [linkUrl length] > 0)
        {
            enterpriseMessageContent.linkUrl = linkUrl;
        }
        enterpriseMessage.enterprise_messageContent = enterpriseMessageContent;
    }
    
    NSNumber* bReadNum = [messageDic objectForKey:@"is_read"];
    if (bReadNum != nil && ![bReadNum isEqual:[NSNull null]])
    {
        enterpriseMessage.bRead = NO;

//        enterpriseMessage.bRead = [bReadNum boolValue];
    }
    
    NSNumber* bSuggestion = [messageDic objectForKey:@"is_suggestion"];
    if (bSuggestion != nil && ![bSuggestion isEqual:[NSNull null]])
    {
        enterpriseMessage.bSuggestion = [bSuggestion boolValue];
    }
    
    NSString* suggestion = [messageDic objectForKey:@"suggestion"];
    if (suggestion != nil && ![suggestion isEqual:[NSNull null]]
        && [suggestion length]>0)
    {
        enterpriseMessage.suggetstionText = suggestion;
    }
    
    NSString* message_time = [messageDic objectForKey:@"timestamp"];
    if (message_time != nil && ![message_time isEqual:[NSNull null]])
    {
        enterpriseMessage.message_time = [self dateFromString:message_time];
    }
    
    return enterpriseMessage;
}

- (NSDate *)dateFromString:(NSString *)dateString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    return destDate;
}

#pragma mark -- 接口废弃
-(void)getLastestRillMessage
{
}
-(void)getLastestEnterpriseMessage
{
}
@end
