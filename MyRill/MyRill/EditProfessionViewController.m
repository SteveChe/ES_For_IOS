//
//  EditProfessionViewController.m
//  MyRill
//
//  Created by Siyuan Wang on 15/7/12.
//
//

#import "EditProfessionViewController.h"
#import "ProfessionDataParse.h"
#import "ProfessionTableViewCell.h"
#import "ColorHandler.h"
#import "ESProfession.h"
#import "Masonry.h"
#import "AddProfessionViewController.h"
#import "ModifyProfessionViewController.h"

@interface EditProfessionViewController () <UITableViewDataSource, UITableViewDelegate, ProfessionDataDelegate>

@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *cacheDataSource;
@property (nonatomic, strong) ProfessionDataParse *professionDP;
@property (nonatomic, strong) NSIndexPath *deleteIndexPath;

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
}

#pragma mark - ProfessionDataDelegate methods
- (void)professionOperationSuccess:(id)context {
    [self.dataSource removeObjectAtIndex:self.deleteIndexPath.row];
    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:self.deleteIndexPath] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)professionOperationFailure:(NSString *)errorMsg {
    self.dataSource = nil;
    self.dataSource = [NSMutableArray arrayWithArray:self.cacheDataSource];
    
    [self.tableView reloadData];
    
    NSLog(@"删除业务失败,请检查网络");
}

- (void)orderProfessionListResult:(id)context {
    if (context == nil) {
        NSLog(@"排序失败!");
    } else {
        
    }
}

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
        [self.professionDP deleteProfessionWithId:[profession.professionId stringValue]];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
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
    ModifyProfessionViewController *modifyProfessionVC = [[ModifyProfessionViewController alloc] init];
    modifyProfessionVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    modifyProfessionVC.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    [modifyProfessionVC loadProfessionData:self.dataSource[indexPath.row]];
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
        
        [self.professionDP updateProfessionListOrderWith:self.dataSource];
    }
}

- (void)onAddBtnClicked:(UIButton *)sender {
    AddProfessionViewController *addProfessionVC = [[AddProfessionViewController alloc] init];
    [self.navigationController pushViewController:addProfessionVC animated:YES];
}

#pragma mark - private methods
- (void)loadProfessionContent:(NSArray *)array {
    self.dataSource = nil;
    self.dataSource = [NSMutableArray arrayWithArray:array];
    [self.dataSource removeLastObject];
    
    self.cacheDataSource = [NSMutableArray arrayWithArray:self.dataSource];
    
    [self.tableView reloadData];
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

- (ProfessionDataParse *)professionDP {
    if (!_professionDP) {
        _professionDP = [[ProfessionDataParse alloc] init];
        _professionDP.delegate = self;
    }
    
    return _professionDP;
}

@end
