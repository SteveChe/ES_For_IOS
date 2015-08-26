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
#import "ColorHandler.h"
#import "UserDefaultsDefine.h"

@interface TaskOverviewTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *initaiatorImg;
@property (weak, nonatomic) IBOutlet UILabel * initiatorNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *taskTotalLbl;
@property (weak, nonatomic) IBOutlet UILabel *redBadgeLbl;

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
    if ([taskOriginatorInfo.initiatorId.stringValue isEqualToString:[userDefaultes stringForKey:DEFAULTS_USERID]]) {
        self.initiatorNameLbl.text = @"我";
    } else {
        self.initiatorNameLbl.text = taskOriginatorInfo.initiatorName;
    }
    
    self.taskTotalLbl.text = [taskOriginatorInfo.assignmentNum stringValue];
    [self.initaiatorImg sd_setImageWithURL:[NSURL URLWithString:taskOriginatorInfo.initiatorImgURL] placeholderImage:[UIImage imageNamed:@"头像_100"]];

    self.redBadgeLbl.hidden = !taskOriginatorInfo.isUpdate;
}

- (void)setInitaiatorImg:(UIImageView *)initaiatorImg {
    _initaiatorImg = initaiatorImg;
    
    _initaiatorImg.layer.cornerRadius = 20.f;
}

- (void)setRedBadgeLbl:(UILabel *)redBadgeLbl {
    _redBadgeLbl = redBadgeLbl;
    
    _redBadgeLbl.font = [UIFont systemFontOfSize:8];
    _redBadgeLbl.textColor = [ColorHandler colorFromHexRGB:@"F64F50"];
    _redBadgeLbl.clipsToBounds = YES;
    _redBadgeLbl.layer.cornerRadius = 5.f;
}

@end
