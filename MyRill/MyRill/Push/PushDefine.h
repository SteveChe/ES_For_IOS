//
//  PushDefine.h
//  MyRill
//
//  Created by Steve on 15/8/29.
//
//

#ifndef MyRill_PushDefine_h
#define MyRill_PushDefine_h

//
//{"category": "contact_request"}
//
//同意／拒绝添加联系人：
//{"category": "contact_accept"}
//
//请求加入企业：
//{"category": "enterprise_request"}
//
//同意／拒绝加入企业：
//{"category": "enterprise_accept"}
//
//企业消息：
//{"category": "enterprise_message"}
//
//任务：
//{"category": "assignment"}
//
//业务-系统消息：
//{"category": "profession"}
//
//业务下发：
//{"category": "profession_apply"}

typedef enum E_PUSH_CATEGORY_TYPE
{
    e_Push_Category_Contact_None = -1,
    e_Push_Category_Contact_Request = 0, //请求添加联系人
    e_Push_Category_Contact_Accept = 1, //同意／拒绝添加联系人
    e_Push_Category_Enterprise_Request = 2, //请求加入企业
    e_Push_Category_Enterprise_Accept = 3, //同意／拒绝加入企业
    e_Push_Category_Enterprise_Message = 4, //企业消息
    e_Push_Category_Riil_Message = 5, //riil消息
    e_Push_Category_Assignment = 6,  //任务
    e_Push_Category_Profession = 7,  //业务-系统消息
    e_Push_Category_Profession_Apply = 8, //业务下发
}E_PUSH_CATEGORY_TYPE;

#define PUSH_CATEGORY   @"category"
#define PUSH_CATEGORY_CONTACT_REQUEST @"contact_request"
#define PUSH_CATEGORY_CONTACT_ACCEPT @"contact_accept"
#define PUSH_CATEGORY_ENTERPRISE_REQUEST @"enterprise_request"
#define PUSH_CATEGORY_ENTERPRISE_ACCEPT @"enterprise_accept"
#define PUSH_CATEGORY_ENTERPRISE_MESSAGE @"enterprise_message"
#define PUSH_CATEGORY_RIIL_MESSAGE @"riil_message"
#define PUSH_CATEGORY_ASSIGNMENT @"assignment"
#define PUSH_CATEGOTY_PROFESSION @"profession"
#define PUSH_CATEGORY_PROFESSION_APPLY @"profession_apply"
#define PUSH_CATEGORY_PARAMS @"params"
#define PUSH_CATEGORY_ASSIGNMENT_ID @"assignment_id"
#define PUSH_CATEGORY_PROFESSION_ID @"profession_id"


#define NOTIFICATION_PUSH_CONTACT_REQUEST @"notification_contact_request"
#define NOTIFICATION_PUSH_CONTACT_ACCEPT @"notification_contact_accept"
#define NOTIFICATION_PUSH_ENTERPRISE_REQUEST @"notification_enterprise_request"
#define NOTIFICATION_PUSH_ENTERPRISE_ACCEPT @"notification_enterprise_accept"
#define NOTIFICATION_PUSH_ENTERPRISE_MESSAGE @"notification_enterprise_message"
#define NOTIFIACATION_PUSH_RIIL_MESSAGE @"notification_riil_message"
#define NOTIFICATION_PUSH_ASSIGNMENT @"notification_assignment"
#define NOTIFICATION_PUSH_PROFESSION @"notification_profession"
#define NOTIFICATION_PUSH_PROFESSION1 @"notification_profession1"

#define NOTIFICATION_PUSH_PROFESSION_APPLY @"notification_profession_apply"

#define NOTIFICATION_STATUS_UPDATE @"notification_status_update"

#define NOTIFICATION_ENTER_FOREGROUD @"notification_enter_foregroud"

#endif
