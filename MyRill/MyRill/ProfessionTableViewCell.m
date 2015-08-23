//
//  ProfessionTableViewCell.m
//  MyRill
//
//  Created by Siyuan Wang on 15/7/15.
//
//

#import "ProfessionTableViewCell.h"
#import "ESProfession.h"
#import "UIImageView+WebCache.h"

@interface ProfessionTableViewCell ()


@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;

@end

@implementation ProfessionTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateProfessionCell:(ESProfession *)profession {
    self.titleLbl.text = profession.name;
    [self.image sd_setImageWithURL:[NSURL URLWithString:profession.icon_url] placeholderImage:nil];
}

@end
