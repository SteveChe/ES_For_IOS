//
//  RCDAddressBookViewController.h
//  RongCloud
//
//  Created by Liv on 14/11/11.
//  Copyright (c) 2014年 胡利武. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "RCSelectPersonViewController.h"
#import "GetContactListDataParse.h"
@interface RCDAddressBookViewController : UIViewController<GetContactListDelegate,UITableViewDataSource,UITableViewDelegate>


@property (nonatomic, strong) NSArray *keys;
@property (nonatomic, strong) NSMutableDictionary *allFriends;
@property (nonatomic,strong) NSArray *allKeys;
@property (nonatomic,strong) NSArray *seletedUsers;
@property (nonatomic,assign) BOOL hideSectionHeader;
@property (nonatomic,strong) NSMutableArray *friends;
@property (nonatomic,strong) NSMutableArray *enterprises;
@property (strong, nonatomic) NSMutableArray *searchResult;
@property (strong, nonatomic) UISearchDisplayController* searchDisplayController1;
@property (nonatomic,strong)UITableView* tableView;


-(void) getAllData;

@end
