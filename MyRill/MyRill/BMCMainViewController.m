//
//  BMCMainViewController.m
//  MyRill
//
//  Created by Siyuan Wang on 15/9/10.
//
//

#import "BMCMainViewController.h"
#import "BMCGetMainResourceListDataParse.h"

@interface BMCMainViewController () <UITableViewDataSource, UITableViewDelegate, BMCGetMainResourceListDelegate>

@property (weak, nonatomic) IBOutlet UITableView *favoriteTableView;
@property (weak, nonatomic) IBOutlet UITableView *warningTableView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;

@property (nonatomic, strong) NSMutableArray *favoriteDataSource;
@property (nonatomic, strong) NSMutableArray *warningDataSource;

@property (nonatomic, strong) BMCGetMainResourceListDataParse *getMainResourceListDP;

@end

@implementation BMCMainViewController

#pragma mark - lifeCycle methods
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"RIIL-BMC";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.getMainResourceListDP getMainResourceListWithTreeNodeId:@"00"
                                                        pageIndex:@"1"
                                                            state:@"all"
                                                       sortColumn:@"venderName"
                                                         sortType:@"asc"];
    
}

#pragma mark - BMCGetMainResourceListDelegate methods
- (void)getMainResourceListSucceed:(NSArray *)resultList {
    [self.warningDataSource removeAllObjects];
    [self.warningDataSource addObjectsFromArray:resultList];
}

- (void)getMainResourceListFailed:(NSString *)errorMessage {
    
}

#pragma mark - UITableViewDataSource&UITableViewDelegate methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([tableView isEqual:self.favoriteTableView]) {
        return self.favoriteDataSource.count;
    } else {
        return self.warningDataSource.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

#pragma mark - setters&getters
- (BMCGetMainResourceListDataParse *)getMainResourceListDP {
    if (!_getMainResourceListDP) {
        _getMainResourceListDP = [[BMCGetMainResourceListDataParse alloc] init];
        
    }
    return _getMainResourceListDP;
}

- (NSMutableArray *)favoriteDataSource {
    if (!_favoriteDataSource) {
        _favoriteDataSource = [[NSMutableArray alloc] init];
    }
    
    return _favoriteDataSource;
}

- (NSMutableArray *)warningDataSource {
    if (!_warningDataSource) {
        _warningDataSource = [[NSMutableArray alloc] init];
    }
    
    return _warningDataSource;
}

@end
