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
#import "TaskViewController.h"
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
    NSDictionary* paramsDic = [pushDic objectForKey:PUSH_CATEGORY_PARAMS];
    
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
        [ESPushManager changeToPageWithType:categoryType Dic:paramsDic];
    }
    
    [ESPushManager postNotificationMessage:notificationMessage];
}
+(void)postNotificationMessage:(NSString*)notificationMessage
{
    [[NSNotificationCenter defaultCenter] postNotificationName:notificationMessage object:nil];
}

+(void)changeToPageWithType:(E_PUSH_CATEGORY_TYPE)categoryType  Dic:(NSDictionary*) paramsDic
{
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    NSUInteger selectIndex = 0;
    ESMenuViewController* rootViewCtrl = (ESMenuViewController*)appDelegate.window.rootViewController;
    [rootViewCtrl.navigationController popToRootViewControllerAnimated:NO];

    switch (categoryType)
    {
        case e_Push_Category_Contact_Request:
        {
            selectIndex = 2;
            RCDAcceptContactViewController* targetVC = [[RCDAcceptContactViewController alloc] init];
            [rootViewCtrl setSelectedIndex:selectIndex];
            UINavigationController* topViewCtrl = rootViewCtrl.viewControllers[selectIndex];
            
            if (targetVC != nil && topViewCtrl != nil)
            {
                [topViewCtrl pushViewController:targetVC animated:NO];
            }

        }
            break;
        case e_Push_Category_Enterprise_Request:
        {
            selectIndex = 2;
            RCDApprovedJoinEnterpriseViewController* targetVC = [[RCDApprovedJoinEnterpriseViewController alloc] init ];
            [rootViewCtrl setSelectedIndex:selectIndex];
            UINavigationController* topViewCtrl = rootViewCtrl.viewControllers[selectIndex];
            
            if (targetVC != nil && topViewCtrl != nil)
            {
                [topViewCtrl pushViewController:targetVC animated:NO];
            }

        }
            break;
        case e_Push_Category_Enterprise_Accept:
        case e_Push_Category_Contact_Accept:
        {
            selectIndex = 2;
            RCDAddressBookViewController* targetVC = [[RCDAddressBookViewController alloc] init];
            [rootViewCtrl setSelectedIndex:selectIndex];
            UINavigationController* topViewCtrl = rootViewCtrl.viewControllers[selectIndex];
            
            if (targetVC != nil && topViewCtrl != nil)
            {
                [topViewCtrl pushViewController:targetVC animated:NO];
            }

        }
            break;
        case e_Push_Category_Enterprise_Message:
        case e_Push_Category_Riil_Message:
        {
            ChatListViewController* targetVC = [[ChatListViewController alloc] init];
            selectIndex = 1;
            [rootViewCtrl setSelectedIndex:selectIndex];
            UINavigationController* topViewCtrl = rootViewCtrl.viewControllers[selectIndex];
            
            if (targetVC != nil && topViewCtrl != nil)
            {
                [topViewCtrl pushViewController:targetVC animated:NO];
            }

        }
            break;
        case e_Push_Category_Assignment:
        {
            NSString* taskId = [paramsDic objectForKey:PUSH_CATEGORY_ASSIGNMENT_ID];
            TaskViewController* targetVC = [[TaskViewController alloc]init];
            targetVC.requestTaskID = taskId;
            selectIndex = 3;
            [rootViewCtrl setSelectedIndex:selectIndex];
            UINavigationController* topViewCtrl = rootViewCtrl.viewControllers[selectIndex];
            
            if (targetVC != nil && topViewCtrl != nil)
            {
                [topViewCtrl pushViewController:targetVC animated:NO];
            }
            
        }
            break;
        
        case e_Push_Category_Profession_Apply:
        {
//            ProfessionViewController* targetVC = [[ProfessionViewController alloc] init];
            selectIndex = 0;
            [rootViewCtrl setSelectedIndex:selectIndex];
//            UINavigationController* topViewCtrl = rootViewCtrl.viewControllers[selectIndex];
//            
//            if (targetVC != nil && topViewCtrl != nil)
//            {
//                [topViewCtrl pushViewController:targetVC animated:NO];
//            }

        }
            break;
        case e_Push_Category_Profession:
        {
            NSNumber* professionIdNum = [paramsDic objectForKey:PUSH_CATEGORY_PROFESSION_ID];
            
            NSString* professionId = nil;
            if (professionIdNum!= nil)
            {
                professionId = [professionIdNum stringValue];
            }

            selectIndex = 0;
            [rootViewCtrl setSelectedIndex:selectIndex];
            
            if (professionId!=nil)
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_PUSH_PROFESSION object:professionId];
            }


        }
            break;
            
        default:
            break;
    }
}

@end
