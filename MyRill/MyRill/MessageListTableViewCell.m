//
//  MessageListTableViewCell.m
//  MyRill
//
//  Created by Siyuan Wang on 15/8/9.
//
//

#import "MessageListTableViewCell.h"
#import "ESTaskComment.h"
#import "ESUserInfo.h"
#import "UIImageView+WebCache.h"
#import "ColorHandler.h"

@interface MessageListTableViewCell ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewHeightConstraint;


@property (weak, nonatomic) IBOutlet UIImageView *userImg;
@property (weak, nonatomic) IBOutlet UILabel *nameAndEnterpriseLbl;
@property (weak, nonatomic) IBOutlet UILabel *createDate;

@end

@implementation MessageListTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateMessage:(ESTaskComment *)taskComment {
    [self.userImg sd_setImageWithURL:[NSURL URLWithString:taskComment.user.portraitUri] placeholderImage:[UIImage imageNamed:@"头像_100"]];
    
    if ([ColorHandler isNullOrEmptyString:taskComment.user.enterprise]) {
        self.nameAndEnterpriseLbl.text = taskComment.user.userName;
    } else {
        self.nameAndEnterpriseLbl.text = [NSString stringWithFormat:@"%@/%@",taskComment.user.userName,taskComment.user.enterprise];
    }
    NSString *createDateStr = [taskComment.createDate substringToIndex:16];
    self.createDate.text = [createDateStr stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
    self.contentTxtVIew.text = taskComment.content;
    UIView *view = [self.contentTxtVIew subviews].lastObject;
    view.bounds = CGRectMake(0, 0, 240, 60);

}

- (void)setUserImg:(UIImageView *)userImg {
    _userImg = userImg;
    
    _userImg.layer.cornerRadius = 18.5f;
}

@end
