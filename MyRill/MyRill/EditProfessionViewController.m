//
//  EditProfessionViewController.m
//  MyRill
//
//  Created by Siyuan Wang on 15/7/12.
//
//

#import "EditProfessionViewController.h"
#import "ProfessionTableViewCell.h"
#import "AddProfessionViewController.h"
#import "ModifyProfessionViewController.h"
#import "ColorHandler.h"
#import "ESProfession.h"
#import "Masonry.h"
#import "PushDefine.h"
#import "GetProfessionListDataParse.h"
#import "AddProfessionDataParse.h"
#import "DeleteProfessionDataParse.h"
#import "UpdateProfessionListOrderDataParse.h"
#import "CustomShowMessage.h"

@interface EditProfessionViewController () <UITableViewDataSource, UITableViewDelegate, GetProfessionListDelegate, DeleteProfessionDelegate, UpdateProfessionListOrderDelegate>

@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSIndexPath *deleteIndexPath;

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *cacheDataSource;
@property (nonatomic, strong) GetProfessionListDataParse *getProfessionListDP;
@property (nonatomic, strong) DeleteProfessionDataParse *deleteProfessionDP;
@property (nonatomic, strong) UpdateProfessionListOrderDataParse *updateProfessionListOrderDP;

@end

@implementation EditProfessionViewController

#pragma mark - lifeCycle methods
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"编辑业务";
    
    UIBarButtonItem *sortBtnItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑"
                                                                    style:UIBarButtonItemStyleDone
                                                                   target:self
                                                                   action:@selector(onSortBtnItemClicked:)];
    self.navigationItem.rightBarButtonItem = sortBtnItem;
    
    [self.view addSubview:self.tableView];
    self.tableView.tableFooterView = self.footerView;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updatePushProfession)
                                                 name:NOTIFICATION_PUSH_PROFESSION
                                               object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = YES;
    
    [self.getProfessionListDP getProfessionList];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:NOTIFICATION_PUSH_PROFESSION
                                                  object:nil];
}

#pragma mark - ProfessionDataDelegate methods
- (void)getProfessionListSuccess:(NSArray *)list {
    [self.dataSource removeAllObjects];
    [self.dataSource addObjectsFromArray:list];
    [self.cacheDataSource removeAllObjects];
    [self.cacheDataSource addObjectsFromArray:self.dataSource];
    
    [self.tableView reloadData];
}

- (void)getProfessionListFailure:(NSString *)errorMsg {
    [[CustomShowMessage getInstance] showNotificationMessage:errorMsg];
}

- (void)orderProfessionListSuccess:(NSArray *)orderList {
    [self.dataSource removeAllObjects];
    [self.dataSource addObjectsFromArray:orderList];
    [self.cacheDataSource removeAllObjects];
    [self.cacheDataSource addObjectsFromArray:self.dataSource];
    
    [self.tableView reloadData];
}

- (void)orderProfessionListFailure:(NSString *)errorMsg {
    [self.dataSource removeAllObjects];
    [self.dataSource addObjectsFromArray:self.cacheDataSource];
    
    [self.tableView reloadData];
    
    [[CustomShowMessage getInstance] showNotificationMessage:errorMsg];
}

- (void)deleteProfessionSuccess {
    [self.dataSource removeObjectAtIndex:self.deleteIndexPath.row];
    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:self.deleteIndexPath] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)deleteProfessionFailure:(NSString *)errorMsg {
    
    [[CustomShowMessage getInstance] showNotificationMessage:errorMsg];
}

//- (void)modifyProfessionSuccess:(ESProfession *)profession {
//    for (int i = 0; i < self.dataSource.count; i ++) {
//        ESProfession *temp = (ESProfession *)self.dataSource[i];
//        if ([profession.professionId isEqualToNumber:temp.professionId]) {
//            [self.dataSource removeObjectAtIndex:i];
//            [self.dataSource insertObject:profession atIndex:i];
//        }
//    }
//    
//    [self.tableView reloadData];
//}

#pragma mark - UITableViewDataSource&UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {

    id object = [self.dataSource objectAtIndex:[sourceIndexPath row]];
    [self.dataSource removeObjectAtIndex:[sourceIndexPath row]];
    [self.dataSource insertObject:object atIndex:[destinationIndexPath row]];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if(editingStyle == UITableViewCellEditingStyleDelete)
    {
        self.deleteIndexPath = [indexPath copy];
        ESProfession *profession = (ESProfession *)self.dataSource[self.deleteIndexPath.row];
        [self.deleteProfessionDP deleteProfessionWithId:[profession.professionId stringValue]];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    ESProfession *profession = (ESProfession *)self.dataSource[self.deleteIndexPath.row];
    if (profession.isSystem == YES) {
        return UITableViewCellEditingStyleNone;
    }
    return UITableViewCellEditingStyleDelete;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ProfessionTableViewCell *professionCell = [tableView dequeueReusableCellWithIdentifier:@"ProfessionTableCell" forIndexPath:indexPath];
    
    [professionCell updateProfessionCell:self.dataSource[indexPath.row]];

    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(0, professionCell.bounds.size.height - 1, professionCell.bounds.size.width, 1);
    layer.backgroundColor = [ColorHandler colorFromHexRGB:@"DDDDDD"].CGColor;
    [professionCell.layer addSublayer:layer];
    
    return professionCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ESProfession *profession = (ESProfession *)self.dataSource[self.deleteIndexPath.row];
    if (profession.isSystem == YES) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"后台派发业务，不可修改!"
                                                       delegate:self
                                              cancelButtonTitle:@"知道了!"
                                              otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    ModifyProfessionViewController *modifyProfessionVC = [[ModifyProfessionViewController alloc] init];
    modifyProfessionVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    modifyProfessionVC.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    [modifyProfessionVC loadProfessionData:self.dataSource[indexPath.row]];
//    modifyProfessionVC.delegate = self;
    [self presentViewController:modifyProfessionVC animated:YES completion:nil];
}

#pragma mark - response events
- (void)onSortBtnItemClicked:(UIBarButtonItem *)sender {
    if ([sender.title isEqualToString:@"编辑"]) {
        [self.tableView setEditing:YES animated:YES];
        sender.title = @"完成";

    } else {
        [self.tableView setEditing:NO animated:YES];
        sender.title = @"编辑";
        
        [self.updateProfessionListOrderDP updateProfessionListOrderWith:self.dataSource];
    }
}

- (void)onAddBtnClicked:(UIButton *)sender {
    AddProfessionViewController *addProfessionVC = [[AddProfessionViewController alloc] init];
    [self.navigationController pushViewController:addProfessionVC animated:YES];
}

- (void)updatePushProfession {
    [self.getProfessionListDP getProfessionList];
}

#pragma mark - setters&getters
- (UITableView *)tableView {
    if (!_tableView) {
        //此处不明，为什么使用allocinit方式初始的tableview，进入不到编辑模式
        _tableView = [UITableView new];
        _tableView.frame = self.view.bounds;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        UINib *professionTableCell = [UINib nibWithNibName:@"ProfessionTableViewCell" bundle:nil];
        [_tableView registerNib:professionTableCell forCellReuseIdentifier:@"ProfessionTableCell"];
    }
    
    return _tableView;
}

- (UIView *)footerView {
    if (!_footerView) {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 70)];
        
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, _footerView.bounds.size.height - 1, _footerView.bounds.size.width, 1);
        layer.backgroundColor = [ColorHandler colorFromHexRGB:@"DDDDDD"].CGColor;
        [_footerView.layer addSublayer:layer];
        
        UIImageView *imageView = [UIImageView new];
        imageView.image = [UIImage imageNamed:@"编辑业务-添加.png"];
        [_footerView addSubview:imageView];
        
        UIButton *addBtn = [UIButton new];
        [addBtn addTarget:self action:@selector(onAddBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_footerView addSubview:addBtn];
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(_footerView);
        }];
        
        [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_footerView);
        }];
    }
    
    return _footerView;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    
    return _dataSource;
}

- (GetProfessionListDataParse *)getProfessionListDP {
    if (!_getProfessionListDP) {
        _getProfessionListDP = [[GetProfessionListDataParse alloc] init];
        _getProfessionListDP.delegate = self;
    }
    
    return _getProfessionListDP;
}

- (DeleteProfessionDataParse *)deleteProfessionDP {
    if (!_deleteProfessionDP) {
        _deleteProfessionDP = [[DeleteProfessionDataParse alloc] init];
        _deleteProfessionDP.delegate = self;
    }
    
    return _deleteProfessionDP;
}

- (UpdateProfessionListOrderDataParse *)updateProfessionListOrderDP {
    if (!_updateProfessionListOrderDP) {
        _updateProfessionListOrderDP = [[UpdateProfessionListOrderDataParse alloc ] init];
        _updateProfessionListOrderDP.delegate = self;
    }
    
    return _updateProfessionListOrderDP;
}

@end
