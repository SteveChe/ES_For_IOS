//
//  ImageTableViewCell.m
//  MyRill
//
//  Created by Siyuan Wang on 15/8/31.
//
//

#import "ImageTableViewCell.h"
#import "ESTaskComment.h"
#import "ESUserInfo.h"
#import "UIImageView+WebCache.h"
#import "ColorHandler.h"
#import "ESEnterpriseInfo.h"

@interface ImageTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *userImg;
@property (weak, nonatomic) IBOutlet UILabel *nameAndEnterpriseLbl;
@property (weak, nonatomic) IBOutlet UILabel *createDate;


@end

@implementation ImageTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateMessage:(ESTaskComment *)taskComment {
    [self.userImg sd_setImageWithURL:[NSURL URLWithString:taskComment.user.portraitUri] placeholderImage:[UIImage imageNamed:@"头像_100"]];
    
    if ([ColorHandler isNullOrEmptyString:taskComment.user.enterprise.enterpriseName]) {
        self.nameAndEnterpriseLbl.text = taskComment.user.userName;
    } else {
        self.nameAndEnterpriseLbl.text = [NSString stringWithFormat:@"%@/%@",taskComment.user.userName,taskComment.user.enterprise.enterpriseName];
    }
    NSString *createDateStr = [taskComment.createDate substringToIndex:16];
    self.createDate.text = [createDateStr stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
    
    if (taskComment.images.count > 1) {
        self.placeholderImg.image = [UIImage imageNamed:@"多张图片"];
    } else {
        self.placeholderImg.image = [UIImage imageNamed:@"单张图片"];
    }
}

- (void)setUserImg:(UIImageView *)userImg {
    _userImg = userImg;
    
    _userImg.layer.cornerRadius = 18.5f;
}

@end
