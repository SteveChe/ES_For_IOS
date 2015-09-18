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
    if ([eventVO.level isEqualToString:@"严重"]) {
        self.warningLevelLbl.backgroundColor = [ColorHandler colorFromHexRGB:@"FF0000"];
    } else if ([eventVO.level isEqualToString:@"主要"]) {
        self.warningLevelLbl.backgroundColor = [ColorHandler colorFromHexRGB:@"FF6602"];
    } else if ([eventVO.level isEqualToString:@"次要"]) {
        self.warningLevelLbl.backgroundColor = [ColorHandler colorFromHexRGB:@"990099"];
    } else if ([eventVO.level isEqualToString:@"警告"]) {
        self.warningLevelLbl.backgroundColor = [ColorHandler colorFromHexRGB:@"31B0B2"];
    } else if ([eventVO.level isEqualToString:@"未知"]) {
        self.warningLevelLbl.backgroundColor = [ColorHandler colorFromHexRGB:@"999999"];
    } else if ([eventVO.level isEqualToString:@"信息"]) {
        self.warningLevelLbl.backgroundColor = [ColorHandler colorFromHexRGB:@"01CC00"];
    }
    self.warningLbl.text = eventVO.name;
}

- (void)setWarningLevelLbl:(UILabel *)warningLevelLbl {
    _warningLevelLbl = warningLevelLbl;
    
    _warningLevelLbl.layer.cornerRadius = 5.f;
}

@end
