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

@interface ProfessionCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;

@end

@implementation ProfessionCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)updateCellData:(ESProfession *)profession {
    self.titleLbl.text = profession.name;
    if ([profession.icon_url isEqualToString:@"add"]) {
        self.icon.image = [UIImage imageNamed:@"添加"];
    } else {
        [self.icon sd_setImageWithURL:[NSURL URLWithString:profession.icon_url] placeholderImage:nil];
    }
}

@end
