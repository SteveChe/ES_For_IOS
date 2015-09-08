//
//  ESPushManager.m
//  MyRill
//
//  Created by Steve on 15/8/29.
//
//

#import "ESPushManager.h"
#import "AppDelegate.h"
#import "RCDAddressBookViewController.h"
#import "ChatListViewController.h"
#import "TaskOverviewViewController.h"
#import "ProfessionViewController.h"
#import "ESMenuViewController.h"
#import "RCDAcceptContactViewController.h"
#import "RCDApprovedJoinEnterpriseViewController.h"

@implementation ESPushManager

+(void)parsePushJsonDic:(NSDictionary*)pushDic applicationState:(UIApplicationState) applicationState
{
    NSString* category = [pushDic objectForKey:PUSH_CATEGORY];
    if (category == nil || [category isEqual:[NSNull null]] || [category length] <=0 )
    {
        return;
    }
    NSString* notificationMessage = nil;
    E_PUSH_CATEGORY_TYPE categoryType = e_Push_Category_Contact_None ;
    
    if ([category isEqualToString:PUSH_CATEGORY_CONTACT_REQUEST])
    {
        notificationMessage = NOTIFICATION_PUSH_CONTACT_REQUEST;
        categoryType = e_Push_Category_Contact_Request;
    }
    
    if([category isEqualToString:PUSH_CATEGORY_CONTACT_ACCEPT])
    {
        notificationMessage = NOTIFICATION_PUSH_CONTACT_ACCEPT;
        categoryType = e_Push_Category_Contact_Accept;
    }
    
    if([category isEqualToString:PUSH_CATEGORY_ENTERPRISE_REQUEST])
    {
        notificationMessage = NOTIFICATION_PUSH_ENTERPRISE_REQUEST;
        categoryType = e_Push_Category_Enterprise_Request;
    }
    
    if ([category isEqualToString:PUSH_CATEGORY_ENTERPRISE_ACCEPT])
    {
        notificationMessage = NOTIFICATION_PUSH_ENTERPRISE_ACCEPT;
        categoryType = e_Push_Category_Enterprise_Accept;
    }
    
    if ([category isEqualToString:PUSH_CATEGORY_ASSIGNMENT])
    {
        notificationMessage = NOTIFICATION_PUSH_ASSIGNMENT;
        categoryType = e_Push_Category_Assignment;
    }
    if ([category isEqualToString:PUSH_CATEGORY_ENTERPRISE_MESSAGE])
    {
        notificationMessage = NOTIFICATION_PUSH_ENTERPRISE_MESSAGE;
        categoryType = e_Push_Category_Enterprise_Message;
    }
    
    if ([category isEqualToString:PUSH_CATEGORY_RIIL_MESSAGE])
    {
        notificationMessage = NOTIFIACATION_PUSH_RIIL_MESSAGE;
        categoryType = e_Push_Category_Riil_Message;
    }

    if ([category isEqualToString:PUSH_CATEGOTY_PROFESSION])
    {
        notificationMessage = NOTIFICATION_PUSH_PROFESSION;
        categoryType = e_Push_Category_Profession;
    }
    
    if ([category isEqualToString:PUSH_CATEGORY_PROFESSION_APPLY])
    {
        notificationMessage = NOTIFICATION_PUSH_PROFESSION_APPLY;
        categoryType = e_Push_Category_Profession_Apply;
    }
    
    if (applicationState == UIApplicationStateInactive)
    {
        [ESPushManager changeToPageWithType:categoryType];
    }
    
    [ESPushManager postNotificationMessage:notificationMessage];
}
+(void)postNotificationMessage:(NSString*)notificationMessage
{
    [[NSNotificationCenter defaultCenter] postNotificationName:notificationMessage object:nil];
}

+(void)changeToPageWithType:(E_PUSH_CATEGORY_TYPE)categoryType
{
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    UIViewController* targetVC = nil;
    NSUInteger selectIndex = 0;
    switch (categoryType)
    {
        case e_Push_Category_Contact_Request:
        {
            selectIndex = 2;
            targetVC = [[RCDAcceptContactViewController alloc] init];
        }
            break;
        case e_Push_Category_Enterprise_Request:
        {
            selectIndex = 2;
            targetVC = [[RCDApprovedJoinEnterpriseViewController alloc] init ];
        }
            break;
        case e_Push_Category_Enterprise_Accept:
        case e_Push_Category_Contact_Accept:
        {
            selectIndex = 2;
//            targetVC = [[RCDAddressBookViewController alloc] init];
        }
            break;
        case e_Push_Category_Enterprise_Message:
        case e_Push_Category_Riil_Message:
        {
//            targetVC = [[ChatListViewController alloc] init];
            selectIndex = 1;
        }
            break;
        case e_Push_Category_Assignment:
        {
//            targetVC = [[TaskOverviewViewController alloc]init];
            selectIndex = 3;
        }
            break;
        
        case e_Push_Category_Profession:
        case e_Push_Category_Profession_Apply:
        {
//            targetVC = [[ProfessionViewController alloc] init];
            selectIndex = 0;
        }
            break;
            
        default:
            break;
    }
    ESMenuViewController* rootViewCtrl = (ESMenuViewController*)appDelegate.window.rootViewController;
    [rootViewCtrl.navigationController popToRootViewControllerAnimated:NO];
    [rootViewCtrl setSelectedIndex:selectIndex];
}

@end
