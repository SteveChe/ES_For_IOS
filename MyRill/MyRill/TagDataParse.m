//
//  TagDataParse.m
//  MyRill
//
//  Created by Steve on 15/7/29.
//
//

#import "TagDataParse.h"
#import "ESTag.h"
#import "AFHttpTool.h"
#import "DataParseDefine.h"

@implementation TagDataParse

//获取人的标签
-(void) getUserTag:(NSString*)userId
{
    [AFHttpTool getTagByUserid:userId success:^(id response)
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
                 NSMutableArray* userTagArray = [NSMutableArray array];
                 for (NSDictionary* temDic in listArray)
                 {
                     if (temDic == nil || [temDic isEqual:[NSNull null]])
                     {
                         break;
                     }
                     ESTag* userTag = [self parseTagJson:temDic];

                     [userTagArray addObject:userTag];
                 }
                 
                 if (userTagArray != nil && ![userTagArray isEqual:[NSNull null]] && [userTagArray count]>0){
                     if (self.delegate!= nil && [self.delegate respondsToSelector:@selector(getTag:)]){
                         [self.delegate getTag:userTagArray];
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
                 if (self.delegate!= nil &&[self.delegate respondsToSelector:@selector(getTagFailed:)])
                 {
                     [self.delegate getTagFailed:errorMessage];
                 }
             }
                 break;
         }
     }
                       failure:^(NSError* err)
     {
         NSLog(@"%@",err);
         if (self.delegate!= nil &&[self.delegate respondsToSelector:@selector(getTagFailed:)])
         {
             [self.delegate getTagFailed:@"标签获取失败"];
         }
         
     }];
}


//获取企业的标签
-(void) getEnterpriseTag:(NSString*)enterpriseId
{
    [AFHttpTool getTagByEnterpriseId:enterpriseId success:^(id response)
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
                 NSMutableArray* enterpriseTagArray = [NSMutableArray array];
                 for (NSDictionary* temDic in listArray)
                 {
                     if (temDic == nil || [temDic isEqual:[NSNull null]])
                     {
                         break;
                     }
                     ESTag* enterpriseTag = [self parseTagJson:temDic];
                     
                     [enterpriseTagArray addObject:enterpriseTag];
                 }
                 
                 if (enterpriseTagArray != nil && ![enterpriseTagArray isEqual:[NSNull null]] && [enterpriseTagArray count]>0){
                     if (self.delegate!= nil && [self.delegate respondsToSelector:@selector(getTag:)]){
                         [self.delegate getTag:enterpriseTagArray];
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
                 if (self.delegate!= nil &&[self.delegate respondsToSelector:@selector(getTagFailed:)])
                 {
                     [self.delegate getTagFailed:errorMessage];
                 }
             }
                 break;
         }
     }
                       failure:^(NSError* err)
     {
         NSLog(@"%@",err);
         if (self.delegate!= nil &&[self.delegate respondsToSelector:@selector(getTagFailed:)])
         {
             [self.delegate getTagFailed:@"标签获取失败"];
         }
         
     }];

}

//获取任务的标签
-(void) getTaskTag:(NSString*)taskTag
{
    [AFHttpTool getTagByTaskId:taskTag success:^(id response)
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
                 NSMutableArray* taskTagArray = [NSMutableArray array];
                 for (NSDictionary* temDic in listArray)
                 {
                     if (temDic == nil || [temDic isEqual:[NSNull null]])
                     {
                         break;
                     }
                     ESTag* taskTag = [self parseTagJson:temDic];
                     
                     [taskTagArray addObject:taskTag];
                 }
                 
                 if (taskTagArray != nil && ![taskTagArray isEqual:[NSNull null]] && [taskTagArray count]>0){
                     if (self.delegate!= nil && [self.delegate respondsToSelector:@selector(getTag:)]){
                         [self.delegate getTag:taskTagArray];
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
                 if (self.delegate!= nil &&[self.delegate respondsToSelector:@selector(getTagFailed:)])
                 {
                     [self.delegate getTagFailed:errorMessage];
                 }
             }
                 break;
         }
     }
                             failure:^(NSError* err)
     {
         NSLog(@"%@",err);
         if (self.delegate!= nil &&[self.delegate respondsToSelector:@selector(getTagFailed:)])
         {
             [self.delegate getTagFailed:@"标签获取失败"];
         }
         
     }];
}

-(ESTag*) parseTagJson:(NSDictionary* )tagDic
{
    ESTag* userTag = [[ESTag alloc] init];
    NSNumber* tagId = [tagDic valueForKey:@"id"];
    if (tagId != nil && ![tagId isEqual:[NSNull null]])
    {
        userTag.tagId = [NSString stringWithFormat:@"%d",[tagId intValue]];
    }
    
    NSString* tagName = [tagDic valueForKey:@"name"];
    if (tagName != nil && ![tagName isEqual:[NSNull null]])
    {
        userTag.tagName = tagName;
    }
    
    NSString* tagSelectedOptionId = [tagDic valueForKey:@"selected_option_id"];
    if (tagSelectedOptionId != nil && ![tagSelectedOptionId isEqual:[NSNull null]])
    {
        userTag.selectedTagItemId = [NSString stringWithFormat:@"%d",[tagSelectedOptionId intValue]];
    }
    
    NSNumber* isLocked = [tagDic valueForKey:@"is_locked"];
    if (tagSelectedOptionId != nil && ![tagSelectedOptionId isEqual:[NSNull null]])
    {
        userTag.bIs_locked = [isLocked boolValue];
    }
    
    NSMutableArray* userTagItemArray = [NSMutableArray array];
    NSArray* userTagItemJsonArray = [tagDic valueForKey:@"options"];
    if (userTagItemJsonArray != nil && ![userTagItemJsonArray isEqual:[NSNull null]] && [userTagItemJsonArray count] > 0)
    {
        for (NSDictionary* userTagItemDic in userTagItemJsonArray)
        {
            ESTagItem* tagItem = [[ESTagItem alloc] init];
            NSNumber* tagItemId = [userTagItemDic valueForKey:@"id"];
            if (tagItemId != nil && ![tagItemId isEqual:[NSNull null]])
            {
                tagItem.tagItemId = [NSString stringWithFormat:@"%d",[tagItemId intValue]];
            }
            NSString* tagItemName = [userTagItemDic valueForKey:@"name"];
            if (tagItemName != nil && ![tagItemName isEqual:[NSNull null]])
            {
                tagItem.tagItemName = tagItemName;
            }
            [userTagItemArray addObject:tagItem];
        }
    }
    userTag.tagItemList = userTagItemArray;
    return userTag;
}
@end
