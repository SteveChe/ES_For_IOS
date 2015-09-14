//
//  BMCEmergencyTableViewCell.m
//  MyRill
//
//  Created by Siyuan Wang on 15/9/14.
//
//

#import "BMCEmergencyTableViewCell.h"
#import "EventVO.h"
#import "ColorHandler.h"

@interface BMCEmergencyTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *resourceTitleLbl;
@property (weak, nonatomic) IBOutlet UILabel *ipLbl;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;
@property (weak, nonatomic) IBOutlet UILabel *warningLevelLbl;

@property (weak, nonatomic) IBOutlet UILabel *warningLbl;

@end

@implementation BMCEmergencyTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateBMCEmergencyCell:(EventVO *)eventVO {
    self.resourceTitleLbl.text = eventVO.resName;
    self.ipLbl.text = eventVO.ip;
    self.timeLbl.text = [eventVO.createTime stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
    self.warningLevelLbl.text = eventVO.level;
    self.warningLbl.text = eventVO.name;
}

- (void)setWarningLevelLbl:(UILabel *)warningLevelLbl {
    _warningLevelLbl = warningLevelLbl;
    
    _warningLevelLbl.layer.cornerRadius = 5.f;
}

@end
