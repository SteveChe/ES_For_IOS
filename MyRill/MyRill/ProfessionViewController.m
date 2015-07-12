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
    UIBarButtonItem *sortBtnItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                                                               target:self
                                                                               action:@selector(onSortBtnItemClicked:)];
    self.navigationItem.rightBarButtonItem = sortBtnItem;

    [self.view addSubview:self.collectionView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.professionDP getProfessionList];
}

#pragma mark - ProfessionDataDelegate methods
- (void)loadProfessionList:(NSArray *)list {
    self.dataSource = [NSMutableArray arrayWithArray:list];
    
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDataSource&UICollectionViewDelegateFlowLayout
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count + 1;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ProfessionCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Profession Cell" forIndexPath:indexPath];
    
    cell.contentView.backgroundColor = [UIColor whiteColor];

//    if (!cell) {
//        cell = [UINib nibWithNibName:@"" bundle:nil];
//    }
//    ESProfession *profession = (ESProfession *)self.dataSource[indexPath.row];
    //[cell updateCellData:profession.name];
    
    return cell;
}

//- (NSArray*)layoutAttributesForElementsInRect:(CGRect)rect
//{
//    NSMutableArray* attributes = [[self.collectionView layoutAttributesForElementsInRect:rect] mutableCopy];
//    
//    
//    for (UICollectionViewLayoutAttributes *attr in attributes) {
//        NSLog(@"%@", NSStringFromCGRect([attr frame]));
//    }
//}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(([[UIScreen mainScreen] bounds].size.width - 3)/3,([[UIScreen mainScreen] bounds].size.height - 64 - 44 - 9)/4);
//    return CGSizeMake(60, 60);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 1;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 1;
}

//设置Cell的边界
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section;
{
    return UIEdgeInsetsMake(0,0,0,0);
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = (UICollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor redColor];
    NSLog(@"row=======%ld",(long)[indexPath row]);
    NSLog(@"section===%ld",(long)indexPath.section);
    
    if (indexPath.row == 2) {
        AddProfessionViewController *addProfessionVC = [[AddProfessionViewController alloc] init];
        [self.navigationController pushViewController:addProfessionVC animated:YES];
    }
}

#pragma mark - response events
- (void)onSortBtnItemClicked:(UIBarButtonItem *)sender {
    
}

#pragma mark - setters&getters
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = 0;
        [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        UINib *professionCell = [UINib nibWithNibName:@"ProfessionCollectionViewCell" bundle:nil];
        [_collectionView registerNib:professionCell forCellWithReuseIdentifier:@"Profession Cell"];
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
