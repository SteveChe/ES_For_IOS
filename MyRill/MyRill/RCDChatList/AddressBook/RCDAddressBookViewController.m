//
//  RCDAddressBookViewController.m
//  RongCloud
//
//  Created by Liv on 14/11/11.
//  Copyright (c) 2014年 胡利武. All rights reserved.
//

#import "RCDAddressBookViewController.h"
//#import "RCDRCIMDataSource.h"
#import <RongIMLib/RongIMLib.h>
#import "RCDAddressBookTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "AFHttpTool.h"
#import "pinyin.h"
#import "ESUserInfo.h"
#import "ESContactList.h"
#include <ctype.h>
#import "RCDPersonDetailViewController.h"


@interface RCDAddressBookViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UISearchControllerDelegate,UISearchDisplayDelegate>

//#字符索引对应的user object
@property (nonatomic,strong) NSMutableArray *tempOtherArr;
@property (nonatomic,strong) NSMutableArray *friends;
@property (nonatomic,strong) GetContactListDataParse* getContactListDataParse;
@property (strong, nonatomic) UISearchDisplayController* searchDisplayController1;

@end

@implementation RCDAddressBookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationItem.title = @"联系人";
    
//    self.tableView.tableFooterView = [UIView new];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _getContactListDataParse = [[GetContactListDataParse alloc] init];
    _getContactListDataParse.delegate = self;

    [self getAllData];
    
    // Add searchbar
    UISearchBar* searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.bounds.size.width, 40)];
    searchBar.placeholder=@"搜索";
    searchBar.delegate = self;
    self.tableView.tableHeaderView = searchBar;
    searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _searchDisplayController1 = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
    
    // searchResultsDataSource 就是 UITableViewDataSource
    _searchDisplayController1.searchResultsDataSource = self;
    // searchResultsDelegate 就是 UITableViewDelegate
    _searchDisplayController1.searchResultsDelegate = self;
    _searchDisplayController1.delegate = self;

    
}

//删除已选中用户
-(void) removeSelectedUsers:(NSArray *) selectedUsers
{
    for (RCUserInfo *user in selectedUsers) {
        
        [_friends enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            ESUserInfo *userInfo = obj;
            if ([user.userId isEqualToString:userInfo.userId]) {
                [_friends removeObject:obj];
            }
            
        }];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/**
 *  initial data
 */

-(void) getAllData
{
    [_getContactListDataParse getContactList];
}

#pragma mark - GetContactListDelegate
-(void)getContactList:(NSArray*)contactList
{
    _friends = [NSMutableArray arrayWithArray:contactList];
    
//    if (_friends.count < 20) {
//        self.hideSectionHeader = YES;
//    }
    
//    _keys = @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",@"#"];
//    _allFriends = [NSMutableDictionary new];
//    _allKeys = [NSMutableArray new];
    //    [self removeSelectedUsers:_seletedUsers];
    
    //    static NSMutableDictionary *staticDic = nil;
    //    if (staticDic.count) {
    //        _allFriends = [NSMutableDictionary dictionaryWithDictionary:staticDic];
    //        return;
    //    }
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
//        _allFriends = [self sortedArrayWithPinYinDic:_friends];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            
        });
    });
}

-(void)getContactListFailed:(NSString *)errorMessage
{

}



#pragma mark - UITableViewDataSource

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0)
    {
        static NSString *reusableCellWithIdentifier = @"RCDAddressBookFirstSectionCell";
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:reusableCellWithIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reusableCellWithIdentifier];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        UIImage* defaultImage = [UIImage imageNamed:@"icon"];
        cell.imageView.image = defaultImage;

        switch (indexPath.row)
        {
            case 0:
            {
                cell.textLabel.text = @"新的联系人";
            }
                break;
            case 1:
            {
                cell.textLabel.text = @"多人聊天组";
            }
                
            default:
                break;
        }
        return cell;
    }
    else
    {
        
        static NSString *reusableCellWithIdentifier = @"RCDAddressBookCell";
        RCDAddressBookTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reusableCellWithIdentifier];
        if (!cell) {
            cell = [[RCDAddressBookTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reusableCellWithIdentifier];
        }
        
        ESContactList* contactList = _friends[indexPath.section-1];
        
        ESUserInfo *user = contactList.contactList[indexPath.row];
        if(user){
            cell.lblName.text = user.userName;
            [cell.imgvAva sd_setImageWithURL:[NSURL URLWithString:user.portraitUri] placeholderImage:[UIImage imageNamed:@"contact"]];
        }
        
        return cell;
    }

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 2;
    }
    else
    {
        ESContactList* contactList = [_friends objectAtIndex:section-1];
        return [contactList.contactList count];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_friends count]+1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65.f;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return nil;
    }
    else
    {
        ESContactList* contactList = [_friends objectAtIndex:section-1];
        return contactList.enterpriseName;
    }

}



#pragma mark - 拼音排序

/**
 *  汉字转拼音
 *
 *  @param hanZi 汉字
 *
 *  @return 转换后的拼音
 */
-(NSString *) hanZiToPinYinWithString:(NSString *)hanZi
{
    if(!hanZi) return nil;
    NSString *pinYinResult=[NSString string];
    for(int j=0;j<hanZi.length;j++){
        NSString *singlePinyinLetter=[[NSString stringWithFormat:@"%c",pinyinFirstLetter([hanZi characterAtIndex:j])] uppercaseString];
        pinYinResult=[pinYinResult stringByAppendingString:singlePinyinLetter];
        
    }
    
    return pinYinResult;

}


/**
 *  根据转换拼音后的字典排序
 *
 *  @param pinyinDic 转换后的字典
 *
 *  @return 对应排序的字典
 */
//-(NSMutableDictionary *) sortedArrayWithPinYinDic:(NSArray *) friends
//{
//    if(!friends) return nil;
//    
//    NSMutableDictionary *returnDic = [NSMutableDictionary new];
//    _tempOtherArr = [NSMutableArray new];
//    BOOL isReturn = NO;
//    
//    for (NSString *key in _keys) {
//        
//        if ([_tempOtherArr count]) {
//            isReturn = YES;
//        }
//        
//        NSMutableArray *tempArr = [NSMutableArray new];
//        for (ESUserInfo *user in friends) {
//            
//            NSString *pyResult = [self hanZiToPinYinWithString:user.userName];
//            NSString *firstLetter = [pyResult substringToIndex:1];
//            if ([firstLetter isEqualToString:key]){
//                [tempArr addObject:user];
//            }
//            
//            if(isReturn) continue;
//            char c = [pyResult characterAtIndex:0];
//            if (isalpha(c) == 0) {
//                [_tempOtherArr addObject:user];
//            }
//        }
//        if(![tempArr count]) continue;
//        [returnDic setObject:tempArr forKey:key];
//        
//    }
//    if([_tempOtherArr count])
//        [returnDic setObject:_tempOtherArr forKey:@"#"];
//    
//    
//    _allKeys = [[returnDic allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
//        
//        return [obj1 compare:obj2 options:NSNumericSearch];
//    }];
//    
//    return returnDic;
//}

//跳转到个人详细资料
//-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
//    NSString *key = [_allKeys objectAtIndex:indexPath.section];
//    NSArray *arrayForKey = [_friends objectForKey:key];
//    ESUserInfo *user = arrayForKey[indexPath.row];
//    RCUserInfo *userInfo = [RCUserInfo new];
//    userInfo.userId = user.userId;
//    userInfo.portraitUri = user.portraitUri;
//    userInfo.name = user.userName;

    
//    RCDPersonDetailViewController *detailViewController = [segue destinationViewController];
//    detailViewController.userInfo = userInfo;
//}


@end
