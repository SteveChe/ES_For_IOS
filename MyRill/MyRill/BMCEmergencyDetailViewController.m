//
//  BMCEmergencyDetailViewController.m
//  MyRill
//
//  Created by Siyuan Wang on 15/9/17.
//
//

#import "BMCEmergencyDetailViewController.h"
#import "BMCEmergencyDetailTableViewCell.h"
#import "EventVO.h"
#import "ColorHandler.h"

@interface BMCEmergencyDetailViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) BMCEmergencyDetailTableViewCell *prototypeCell;

@property (nonatomic, strong) NSArray *titleArray;

@end

@implementation BMCEmergencyDetailViewController
#pragma mark - lifeCycle methods
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"告警详情";
    
    [self.view addSubview:self.tableView];
    
    self.titleArray = @[@"事件名称",@"事件ID",@"事件级别",@"事件产生时间",@"事件类型",@"事件状态",@"采集类型",@"资源名称",@"资源类型",@"资源IP地址",@"产生时间",@"资源ID",@"策略ID",@"模板ID",@"是否基础应用",@"是否受理"];
    
    self.prototypeCell = [self.tableView dequeueReusableCellWithIdentifier:@"BMCEmergencyDetailTableViewCell"];
}

#pragma mark - UITableViewDataSource&UITableViewDelegate methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titleArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    BMCEmergencyDetailTableViewCell *cell = (BMCEmergencyDetailTableViewCell *)self.prototypeCell;
    
    if ([cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height > 0) {
        return [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height + 1;
    } else {
        return 44.f;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    self.prototypeCell  = nil;
    BMCEmergencyDetailTableViewCell *cell = (BMCEmergencyDetailTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"BMCEmergencyDetailTableViewCell" forIndexPath:indexPath];
    cell.titleLbl.text = self.titleArray[indexPath.row];
    NSString *content = nil;
    switch (indexPath.row) {
        case 0:
            content = self.eventVO.name;
            break;
        case 1:
            content = self.eventVO.eventId;
            break;
        case 2:
            content = self.eventVO.level;
            break;
        case 3:
            content = self.eventVO.time;
            break;
        case 4:
            content = self.eventVO.eventType;
            break;
        case 5:
            content = self.eventVO.eventState;
            break;
        case 6:
            content = self.eventVO.collectType;
            break;
        case 7:
            content = self.eventVO.resName;
            break;
        case 8:
            content = self.eventVO.resType;
            break;
        case 9:
            content = self.eventVO.ip;
            break;
        case 10:
            content = self.eventVO.createTime;
            break;
        case 11:
            content = self.eventVO.resId;
            break;
        case 12:
            content = self.eventVO.policyId;
            break;
        case 13:
            content = self.eventVO.resTempId;
            break;
        case 14:
            content = self.eventVO.isApp;
            break;
        case 15:
            content = self.eventVO.viewType;
            break;
        default:
            break;
    }
    cell.contentLbl.text = content;
    
    self.prototypeCell = cell;
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(0, 0, self.prototypeCell.bounds.size.width, 1);
    layer.backgroundColor = [ColorHandler colorFromHexRGB:@"F5F5F5"].CGColor;
    [self.prototypeCell.layer addSublayer:layer];
    [self.prototypeCell layoutIfNeeded];
    
    return self.prototypeCell;
}

#pragma mark - setters&getters
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 16)];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        UINib *nib = [UINib nibWithNibName:@"BMCEmergencyDetailTableViewCell" bundle:nil];
        [_tableView registerNib:nib forCellReuseIdentifier:@"BMCEmergencyDetailTableViewCell"];
    }
    
    return _tableView;
}

@end
