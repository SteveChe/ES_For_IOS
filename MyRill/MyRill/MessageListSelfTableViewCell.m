//
//  MessageListSelfTableViewCell.m
//  MyRill
//
//  Created by Siyuan Wang on 15/8/9.
//
//

#import "MessageListSelfTableViewCell.h"
#import "ESTaskComment.h"
#import "UIImageView+WebCache.h"
#import "ESContactor.h"
#import "ColorHandler.h"

@interface MessageListSelfTableViewCell ()
@property (weak, nonatomic) IBOutlet UITextView *contentTxtVIew;
@property (weak, nonatomic) IBOutlet UIImageView *userImg;
@property (weak, nonatomic) IBOutlet UILabel *nameAndEnterpriseLbl;
@property (weak, nonatomic) IBOutlet UILabel *createDate;

@end

@implementation MessageListSelfTableViewCell

- (void)awakeFromNib {
    // Initialization code
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chat_to_bg_normal.png"]];
    [self.contentTxtVIew addSubview:imageView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateMessage:(ESTaskComment *)taskComment {
    [self.userImg sd_setImageWithURL:[NSURL URLWithString:taskComment.user.imgURLstr] placeholderImage:nil];
    if ([ColorHandler isNullOrEmptyString:taskComment.user.enterprise]) {
        self.nameAndEnterpriseLbl.text = @"我";
    } else {
        self.nameAndEnterpriseLbl.text = [NSString stringWithFormat:@"%@/%@", taskComment.user.enterprise, @"我"];
    }
    
    self.createDate.text = taskComment.createDate;
    UIView *view = [self.contentTxtVIew subviews].lastObject;
    view.bounds = CGRectMake(0, 0, 240, 60);
}

- (void)setUserImg:(UIImageView *)userImg {
    _userImg = userImg;
    
    _userImg.layer.cornerRadius = 18.5f;
}

@end
