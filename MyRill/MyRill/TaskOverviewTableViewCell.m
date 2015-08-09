//
//  TaskOverviewTableViewCell.m
//  MyRill
//
//  Created by Siyuan Wang on 15/7/26.
//
//

#import "TaskOverviewTableViewCell.h"
#import "ESTaskOriginatorInfo.h"
#import "UIImageView+WebCache.h"

@interface TaskOverviewTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *initaiatorImg;
@property (weak, nonatomic) IBOutlet UILabel * initiatorNameLbl;
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
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    if ([taskOriginatorInfo.initiatorId.stringValue isEqualToString:[userDefaultes stringForKey:@"UserId"]]) {
        self.initiatorNameLbl.text = @"我";
    } else {
        self.initiatorNameLbl.text = taskOriginatorInfo.initiatorName;
    }
    
    self.taskTotalLbl.text = [taskOriginatorInfo.assignmentNum stringValue];
    [self.initaiatorImg sd_setImageWithURL:[NSURL URLWithString:taskOriginatorInfo.initiatorImgURL] placeholderImage:nil];
}

- (void)setInitaiatorImg:(UIImageView *)initaiatorImg {
    _initaiatorImg = initaiatorImg;
    
    _initaiatorImg.layer.cornerRadius = 20.f;
}

@end
