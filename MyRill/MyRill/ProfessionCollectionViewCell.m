//
//  ProfessionCollectionViewCell.m
//  MyRill
//
//  Created by Siyuan Wang on 15/7/8.
//
//

#import "ProfessionCollectionViewCell.h"
#import "ESProfession.h"
#import "UIImageView+WebCache.h"
#import "ColorHandler.h"

@interface ProfessionCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *redBadgeLbl;

@end

@implementation ProfessionCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)updateCellData:(ESProfession *)profession {
    self.titleLbl.text = profession.name;
    if ([profession.icon_url isEqualToString:@"add"]) {
        self.icon.image = [UIImage imageNamed:@"添加"];
        self.redBadgeLbl.hidden = YES;

    } else {
        [self.icon sd_setImageWithURL:[NSURL URLWithString:profession.icon_url] placeholderImage:nil];
        self.redBadgeLbl.hidden = !profession.isUpdate;
    }
}


- (void)setRedBadgeLbl:(UILabel *)redBadgeLbl {
    _redBadgeLbl = redBadgeLbl;
    
//    _redBadgeLbl.font = [UIFont systemFontOfSize:17];
    _redBadgeLbl.textColor = [ColorHandler colorFromHexRGB:@"F64F50"];
    _redBadgeLbl.clipsToBounds = YES;
    _redBadgeLbl.layer.cornerRadius = 5.f;
}

@end
