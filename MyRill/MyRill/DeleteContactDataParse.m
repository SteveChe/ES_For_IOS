//
//  DeleteContactDataParse.m
//  MyRill
//
//  Created by Steve on 15/8/20.
//
//

#import "DeleteContactDataParse.h"
#import "AFHttpTool.h"
#import "DataParseDefine.h"

@implementation DeleteContactDataParse
-(void) deleteContact:(NSString *)userId
{
    [AFHttpTool deleteContact:userId success:^(id response)
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
                 if (self.delegate!= nil && [self.delegate respondsToSelector:@selector(deleteContactSucceed)])
                 {
                     [self.delegate deleteContactSucceed];
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
                 if (self.delegate!= nil &&[self.delegate respondsToSelector:@selector(deleteContactFailed:)])
                 {
                     [self.delegate deleteContactFailed:errorMessage];
                 }
             }
                 break;
         }
     }
                      failure:^(NSError* err)
     {
         NSLog(@"%@",err);
         if (self.delegate!= nil &&[self.delegate respondsToSelector:@selector(deleteContactFailed:)])
         {
             [self.delegate deleteContactFailed:@"网络请求失败"];
         }
         
     }];
}

@end
