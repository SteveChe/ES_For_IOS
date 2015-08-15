//
//  TaskListViewController.h
//  MyRill
//
//  Created by Siyuan Wang on 15/7/26.
//
//

#import <UIKit/UIKit.h>
#import "ESViewController.h"
#import "GetTaskListDataParse.h"

@interface TaskListViewController : ESViewController

/*******检索方式ESTaskListType
ESTaskListWithChatId - 通过对话发起任务的chat_id方式
ESTaskListWithInitiatorId - 通过发起人查询任务的initiator_id方式
ESTaskListWithPersonInChargeId - 通过负责人查询任务的person_in_charge_id方式
ESTaskListStatus,
ESTaskOverdue,
ESTaskListQ
*******/
@property (nonatomic, assign) ESTaskListType type;
//查询字段:chat_id,initiator_id,person_in_charge_id等值在此设置
@property (nonatomic, copy) NSString *identity;

@end
