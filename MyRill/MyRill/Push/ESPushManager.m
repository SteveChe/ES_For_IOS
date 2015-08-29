//
//  ESPushManager.m
//  MyRill
//
//  Created by Steve on 15/8/29.
//
//

#import "ESPushManager.h"
#import "PushDefine.h"

@implementation ESPushManager

+(void)parsePushJsonDic:(NSDictionary*)pushDic
{
    NSString* category = [pushDic objectForKey:PUSH_CATEGORY];
    if (category == nil || [category isEqual:[NSNull null]] || [category length] <=0 )
    {
        return;
    }
    
    if ([category isEqualToString:PUSH_CATEGORY_CONTACT_REQUEST])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_PUSH_CONTACT_REQUEST object:nil];
    }
    
    if([category isEqualToString:PUSH_CATEGORY_CONTACT_ACCEPT])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_PUSH_CONTACT_ACCEPT object:nil];
    }
    
    if([category isEqualToString:PUSH_CATEGORY_ENTERPRISE_REQUEST])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_PUSH_ENTERPRISE_REQUEST object:nil];
    }
    
    if ([category isEqualToString:PUSH_CATEGORY_ENTERPRISE_ACCEPT])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_PUSH_ENTERPRISE_ACCEPT object:nil];
    }
    
    if ([category isEqualToString:PUSH_CATEGORY_ASSIGNMENT])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_PUSH_ASSIGNMENT object:nil];
    }
    
    if ([category isEqualToString:PUSH_CATEGOTY_PROFESSION])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_PUSH_PROFESSION object:nil];
    }
    
    if ([category isEqualToString:PUSH_CATEGORY_PROFESSION_APPLY])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_PUSH_PROFESSION_APPLY object:nil];
    }
}
@end
