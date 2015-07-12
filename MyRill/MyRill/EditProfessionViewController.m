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
#import "Masonry.h"
#import "AddProfessionViewController.h"

@interface EditProfessionViewController () <UITableViewDataSource, UITableViewDelegate, ProfessionDataDelegate>

@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) ProfessionDataParse *professioniDP;

@end

@implementation EditProfessionViewController

#pragma mark - lifeCycle methods
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"编辑业务";
    
    UIBarButtonItem *sortBtnItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑"
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self
                                                                   action:@selector(onSortBtnItemClicked:)];
    self.navigationItem.rightBarButtonItem = sortBtnItem;
    
    [self.view addSubview:self.tableView];
    self.tableView.tableFooterView = self.footerView;
}

#pragma mark - ProfessionDataDelegate methods


#pragma mark - UITableViewDataSource&UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

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
        [self.tableView beginUpdates];
        [self.dataSource removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        [self.tableView endUpdates];
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ProfessionTableViewCell *professionCell = [tableView dequeueReusableCellWithIdentifier:@"Profession TableCell" forIndexPath:indexPath];
    
    [professionCell updateProfessionCell:self.dataSource[indexPath.row]];

    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(0, professionCell.bounds.size.height - 1, professionCell.bounds.size.width, 1);
    layer.backgroundColor = [ColorHandler colorFromHexRGB:@"DDDDDD"].CGColor;
    [professionCell.layer addSublayer:layer];
    
    return professionCell;
}

#pragma mark - response events
- (void)onSortBtnItemClicked:(UIBarButtonItem *)sender {
    if ([sender.title isEqualToString:@"编辑"]) {
        [self.tableView setEditing:YES animated:YES];
        sender.title = @"完成";
    } else {
        [self.tableView setEditing:NO animated:YES];
        sender.title = @"编辑";
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
    
    [self.tableView reloadData];
}

#pragma mark - setters&getters
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[ProfessionTableViewCell class] forCellReuseIdentifier:@"Profession TableCell"];
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
        imageView.image = [UIImage imageNamed:@"icon.png"];
        [_footerView addSubview:imageView];
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(_footerView);
        }];
        
        UIButton *addBtn = [UIButton new];
        [addBtn addTarget:self action:@selector(onAddBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_footerView addSubview:addBtn];
        
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

@end
