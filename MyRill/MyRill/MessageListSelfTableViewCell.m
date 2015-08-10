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
@property (strong, nonatomic) NSMutableAttributedString *attrString;

@end

@implementation MessageListSelfTableViewCell

- (void)awakeFromNib {
    // Initialization code
    UIImage *image = [UIImage imageNamed:@"对话框背景1.png"];
    UIEdgeInsets insets = UIEdgeInsetsMake(25, 20, 10, 50);
    image = [image resizableImageWithCapInsets:insets];
    // 指定为拉伸模式，伸缩后重新赋值
//    image = [image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.bounds = CGRectMake(0, 0, 200, 60);
    [self.contentTxtVIew addSubview:imageView];
    [self.contentTxtVIew sendSubviewToBack:imageView];
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
    
    NSString *createDateStr = [taskComment.createDate substringToIndex:16];
    self.createDate.text = [createDateStr stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
    self.contentTxtVIew.text = taskComment.content;

    self.attrString = [[NSMutableAttributedString alloc] initWithString:taskComment.content];
    
    CGRect bounds = [self.attrString boundingRectWithSize:CGSizeMake(150, 1000)
                                                 options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                 context:nil];
}

- (void)setUserImg:(UIImageView *)userImg {
    _userImg = userImg;
    
    _userImg.layer.cornerRadius = 18.5f;
}

@end
