//
//  TaskOverviewTableViewCell.m
//  MyRill
//
//  Created by Siyuan Wang on 15/7/26.
//
//

#import "TaskOverviewTableViewCell.h"
#import "ESTaskOriginatorInfo.h"

@interface TaskOverviewTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *enterpriseNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *taskTotalLbl;

@end

@implementation TaskOverviewTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateTaskDashboardCell:(ESTaskOriginatorInfo *)taskOriginatorInfo {
    self.enterpriseNameLbl.text = taskOriginatorInfo.enterpriseName;
    self.taskTotalLbl.text = [taskOriginatorInfo.totalTask stringValue];
}

@end
