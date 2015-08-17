//
//  TaskContactorCollectionViewCell.m
//  MyRill
//
//  Created by Siyuan Wang on 15/8/11.
//
//

#import "TaskContactorCollectionViewCell.h"
#import "ESContactor.h"
#import "UIImageView+WebCache.h"

@interface TaskContactorCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIImageView *userImg;
@end

@implementation TaskContactorCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)updateCell:(ESContactor *)contactor {
    [self.userImg sd_setImageWithURL:[NSURL URLWithString:contactor.imgURLstr] placeholderImage:[UIImage imageNamed:@"头像_100"]];
    self.name.text = contactor.name;
}

- (void)setUserImg:(UIImageView *)userImg {
    _userImg = userImg;
    
    _userImg.layer.cornerRadius = 18.5f;
}

@end
