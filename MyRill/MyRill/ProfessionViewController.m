//
//  ProfessionViewController.m
//  MyRill
//
//  Created by Siyuan Wang on 15/6/14.
//
//

#import "ProfessionViewController.h"
#import "ColorHandler.h"
#import "ProfessionDataParse.h"
#import "ESProfession.h"
#import "ProfessionCollectionViewCell.h"
#import "AddProfessionViewController.h"
#import "EditProfessionViewController.h"
#import "ProfessionWebViewController.h"
#import "PushDefine.h"
#import "BMCLoginViewController.h"

@interface ProfessionViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, ProfessionDataDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) ProfessionDataParse *professionDP;

@end

@implementation ProfessionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"业务";
    self.view.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem *sortBtnItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"编辑.png"]
                                                                    style:UIBarButtonItemStyleDone
                                                                   target:self
                                                                   action:@selector(onSortBtnItemClicked:)];
    self.navigationItem.rightBarButtonItem = sortBtnItem;

    [self.view addSubview:self.collectionView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updatePushProfession)
                                                 name:NOTIFICATION_PUSH_PROFESSION
                                               object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = NO;
    [self.professionDP getProfessionList];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_PUSH_PROFESSION object:nil];
}

#pragma mark - ProfessionDataDelegate methods
- (void)professionOperationSuccess:(NSArray *)list {
    if ([list isKindOfClass:[NSArray class]]) {
        self.dataSource = nil;
        [self.dataSource addObjectsFromArray:list];
        ESProfession *profession = [[ESProfession alloc] init];
        profession.icon_url = @"add";
        [self.dataSource addObject:profession];
        
        [self.collectionView reloadData];
    }
}

#pragma mark - UICollectionViewDataSource&UICollectionViewDelegateFlowLayout
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ProfessionCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Profession CollectionCell" forIndexPath:indexPath];
    
    cell.contentView.backgroundColor = [UIColor whiteColor];

    if (self.dataSource.count > 0 && indexPath.row < self.dataSource.count) {
        ESProfession *profession = (ESProfession *)self.dataSource[indexPath.row];
        [cell updateCellData:profession];

    }
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(([[UIScreen mainScreen] bounds].size.width - 3)/3,([[UIScreen mainScreen] bounds].size.height - 64 - 44 - 9)/4);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 1;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 1;
}

//设置Cell的边界
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0,0,0,0);
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.dataSource.count - 1) {
//        AddProfessionViewController *addProfessionVC = [[AddProfessionViewController alloc] init];
//        [self.navigationController pushViewController:addProfessionVC animated:YES];
        BMCLoginViewController *bmcLoginVC = [[BMCLoginViewController alloc] init];
        [self.navigationController pushViewController:bmcLoginVC animated:YES];
    } else {
        ProfessionWebViewController *webVC = [[ProfessionWebViewController alloc] init];
        ESProfession *profession = self.dataSource[indexPath.row];
        webVC.title = profession.name;
        webVC.urlString = profession.url;
        [self.navigationController pushViewController:webVC animated:YES];
    }
}

#pragma mark - response events
- (void)onSortBtnItemClicked:(UIBarButtonItem *)sender {
    EditProfessionViewController *editProfessionVC = [[EditProfessionViewController alloc] init];
    [editProfessionVC loadProfessionContent:self.dataSource];
    [self.navigationController pushViewController:editProfessionVC animated:YES];
}

//更新push到客户端的业务
- (void)updatePushProfession {
    [self.professionDP getProfessionList];
}

#pragma mark - setters&getters
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = 0;
        [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - self.tabBarController.tabBar.bounds.size.height) collectionViewLayout:layout];
        UINib *professionCell = [UINib nibWithNibName:@"ProfessionCollectionViewCell" bundle:nil];
        [_collectionView registerNib:professionCell forCellWithReuseIdentifier:@"Profession CollectionCell"];
        _collectionView.backgroundColor = [ColorHandler colorFromHexRGB:@"DDDDDD"];
        _collectionView.bounces = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    }
    
    return _collectionView;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}

- (ProfessionDataParse *)professionDP {
    if (!_professionDP) {
        _professionDP = [[ProfessionDataParse alloc] init];
        _professionDP.delegate = self;
    }
    
    return _professionDP;
}

@end
