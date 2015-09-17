//
//  ProfessionViewController.m
//  MyRill
//
//  Created by Siyuan Wang on 15/6/14.
//
//

#import "ProfessionViewController.h"
#import "ProfessionCollectionViewCell.h"
#import "AddProfessionViewController.h"
#import "EditProfessionViewController.h"
#import "BMCLoginViewController.h"
#import "ProfessionWebViewController.h"
#import "ColorHandler.h"
#import "ESProfession.h"
#import "PushDefine.h"
#import "GetProfessionListDataParse.h"
#import "CustomShowMessage.h"
#import "GetProfessionDataParse.h"
#import "BMCMainViewController.h"

@interface ProfessionViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, GetProfessionListDelegate, GetProfessionDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) GetProfessionListDataParse *getProfessionListDP;
@property (nonatomic, strong) GetProfessionDataParse *getProfessionDP;

@end

@implementation ProfessionViewController
#pragma mark - lifeCycle methods
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
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updatePushProfession:)
                                                 name:NOTIFICATION_PUSH_PROFESSION
                                               object:nil];
    
    [self.getProfessionListDP getProfessionList];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_PUSH_PROFESSION object:nil];
}

#pragma mark - GetProfessionListDelegate methods
- (void)getProfessionListSuccess:(NSArray *)list {
    [self.dataSource removeAllObjects];
    [self.dataSource addObjectsFromArray:list];
    ESProfession *profession = [[ESProfession alloc] init];
    profession.icon_url = @"add";
    [self.dataSource addObject:profession];
    
    [self.collectionView reloadData];
}

- (void)getProfessionListFailure:(NSString *)errorMsg {
    [[CustomShowMessage getInstance] showNotificationMessage:errorMsg];
}

#pragma mark - GetProfessionDelegate methods
- (void)getProfessionSuccess:(ESProfession *)profession {
    if ([profession.professionType isEqualToString:@"BMC"]) {
        dispatch_async(dispatch_get_main_queue(), ^{

            BMCLoginViewController *bmcLoginVC = [[BMCLoginViewController alloc] init];
            [self.navigationController pushViewController:bmcLoginVC animated:YES];
        });
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            ProfessionWebViewController *webVC = [[ProfessionWebViewController alloc] init];
            webVC.title = profession.name;
            webVC.type = ESWebProfessionWithURL;
            webVC.urlString = profession.url;
            [self.navigationController pushViewController:webVC animated:YES];
        });

    }
}

- (void)getProfessionFailure:(NSString *)errorMsg {
    [[CustomShowMessage getInstance] showNotificationMessage:@"进入指定业务失败!请手动进入。"];
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
        AddProfessionViewController *addProfessionVC = [[AddProfessionViewController alloc] init];
        [self.navigationController pushViewController:addProfessionVC animated:YES];
    } else {
        ESProfession *profession = (ESProfession *)self.dataSource[indexPath.row];
        if ([profession.professionType isEqualToString:@"BMC"]) {
            UIViewController *vc = nil;
            NSData *cookiesdata = [[NSUserDefaults standardUserDefaults] objectForKey:@"sessionCookies"];
            if([cookiesdata length]) {
                NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData:cookiesdata];
                NSHTTPCookie *cookie;
                BOOL jsessionidLogin = false;
                BOOL ssoTokenLogin = false;
                for (cookie in cookies) {
                    if ([cookie.name isEqual:@"JSESSIONID"] )
                    {
                        if([cookie.value length])
                            jsessionidLogin = true;
                    }
                    if ([cookie.name isEqual:@"SSOToken"] )
                    {
                        if([cookie.value length])
                            ssoTokenLogin = true;
                    }
                }
                if (jsessionidLogin && ssoTokenLogin) {
                    vc = [[BMCMainViewController alloc] init];
                } else {
                    vc = [[BMCLoginViewController alloc] init];
                }
            } else {
                vc = [[BMCLoginViewController alloc] init];
            }
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            ProfessionWebViewController *webVC = [[ProfessionWebViewController alloc] init];
            webVC.title = profession.name;
            webVC.type = ESWebProfessionWithURL;
            webVC.urlString = profession.url;
            [self.navigationController pushViewController:webVC animated:YES];
        }
    }
}

#pragma mark - response events
- (void)onSortBtnItemClicked:(UIBarButtonItem *)sender {
    EditProfessionViewController *editProfessionVC = [[EditProfessionViewController alloc] init];
    [self.navigationController pushViewController:editProfessionVC animated:YES];
}

//更新push到客户端的业务
- (void)updatePushProfession:(id)notification {
    NSString *professionID = (NSString *)[notification object];
    if ([ColorHandler isNullOrEmptyString:professionID]) {
        [self.getProfessionListDP getProfessionList];
    } else {
        [self.getProfessionDP getProfessionWithProfessionID:professionID];
    }
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

- (GetProfessionListDataParse *)getProfessionListDP {
    if (!_getProfessionListDP) {
        _getProfessionListDP = [[GetProfessionListDataParse alloc] init];
        _getProfessionListDP.delegate = self;
    }
    
    return _getProfessionListDP;
}

- (GetProfessionDataParse *)getProfessionDP {
    if (!_getProfessionDP) {
        _getProfessionDP = [[GetProfessionDataParse alloc] init];
        _getProfessionDP.delegate = self;
    }
    
    return _getProfessionDP;
}

@end
