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

@implementation GetEnterpriseMessageDataParse

-(void)getLastestRillMessage
{
    [AFHttpTool getLastestRillMessageSucess:^(id response)
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
                 
                 
//                 if (self.getLastestRillMessageDelegate!= nil &&[self.getLastestRillMessageDelegate respondsToSelector:@selector(getLastestRILLMessageSucceed:)])
//                 {
//                     [self.getLastestRillMessageDelegate getLastestRILLMessageSucceed:enterpriseMessage];
//                 }
                 
             }
                 break;
             default:
             {
//                 NSString* errorMessage = [reponseDic valueForKey:NETWORK_ERROR_MESSAGE];
//                 if(errorMessage==nil)
//                     return;
//                 errorMessage= [errorMessage stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//                 NSLog(@"%@",errorMessage);
//                 if (self.followEnterPriseDelegate!= nil &&[self.followEnterPriseDelegate respondsToSelector:@selector(followEnterpriseFailed:)])
//                 {
//                     [self.followEnterPriseDelegate followEnterpriseFailed:errorMessage];
//                 }
             }
                 break;
         }
     }failure:^(NSError* err)
     {
         NSLog(@"%@",err);
//         if (self.followEnterPriseDelegate!= nil &&[self.followEnterPriseDelegate respondsToSelector:@selector(followEnterpriseFailed:)])
//         {
//             [self.followEnterPriseDelegate followEnterpriseFailed:@"网络请求失败"];
//         }
     }];

}
-(void)getRillMessageList
{
    
}
-(void)replyToRillMessage:(NSString*)content
{
    
}

-(void)getLastestEnterpriseMessage
{
    
}
-(void)getAllEnterpriseLastestMessageList
{
    
}
-(void)getOneEnterpriseMessage:(NSString*)enterpriseId
{
    
}
-(void)replyToOneEnterpriseMessage:(NSString*)enterpriseId content:(NSString*)content
{
    
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
        enterpriseMessage.bRead = [bReadNum boolValue];
    }
    
    NSNumber* bSuggestion = [messageDic objectForKey:@"is_suggestion"];
    if (bSuggestion != nil && ![bSuggestion isEqual:[NSNull null]])
    {
        enterpriseMessage.bSuggestion = [bReadNum boolValue];
    }
    
    NSString* suggestion = [messageDic objectForKey:@"suggestion"];
    if (suggestion != nil && ![suggestion isEqual:[NSNull null]]
        && [suggestion length]>0)
    {
        enterpriseMessage.suggetstionText = suggestion;
    }
    
    NSDate* message_time = [messageDic objectForKey:@"timestamp"];
    if (message_time != nil && ![message_time isEqual:[NSNull null]])
    {
        enterpriseMessage.message_time = message_time;
    }
    
    return enterpriseMessage;
}

@end
