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


@end
