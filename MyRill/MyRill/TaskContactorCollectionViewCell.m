//
//  TaskContactorCollectionViewCell.m
//  MyRill
//
//  Created by Siyuan Wang on 15/8/11.
//
//

#import "TaskContactorCollectionViewCell.h"
#import "ESUserInfo.h"
#import "UIImageView+WebCache.h"

@interface TaskContactorCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIImageView *userImg;
@end

@implementation TaskContactorCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)updateCell:(ESUserInfo *)user {
    [self.userImg sd_setImageWithURL:[NSURL URLWithString:user.portraitUri] placeholderImage:[UIImage imageNamed:@"头像_100"]];
    self.name.text = user.userName;
}

- (void)setUserImg:(UIImageView *)userImg {
    _userImg = userImg;
    
    _userImg.layer.cornerRadius = 18.5f;
}

@end
