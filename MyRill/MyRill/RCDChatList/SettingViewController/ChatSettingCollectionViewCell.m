//
//  ChatSettingCollectionViewCell.m
//  MyRill
//
//  Created by Steve on 15/7/22.
//
//

#import "ChatSettingCollectionViewCell.h"
#import "ESUserInfo.h"
#import "UIImageView+WebCache.h"

@interface ChatSettingCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *portraitImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end
@implementation ChatSettingCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
    self.portraitImage.clipsToBounds = YES;
    self.portraitImage.layer.cornerRadius = 25.f;
}
- (void)updateCellData:(ESUserInfo *)userInfo
{
    self.nameLabel.text = userInfo.userName;
    [self.portraitImage sd_setImageWithURL:[NSURL URLWithString:userInfo.portraitUri] placeholderImage:[UIImage imageNamed:@"头像_100"]];
}


@end
