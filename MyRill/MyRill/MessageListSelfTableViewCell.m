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

@interface MessageListSelfTableViewCell ()
@property (weak, nonatomic) IBOutlet UITextView *contentTxtVIew;
@property (weak, nonatomic) IBOutlet UIImageView *userImg;
@property (weak, nonatomic) IBOutlet UILabel *nameAndEnterpriseLbl;
@property (weak, nonatomic) IBOutlet UILabel *createDate;

@end

@implementation MessageListSelfTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    self.contentTxtVIew.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"chat_to_bg_normal.png"]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateMessage:(ESTaskComment *)taskComment {
    [self.userImg sd_setImageWithURL:[NSURL URLWithString:taskComment.user.imgURLstr] placeholderImage:nil];
    self.nameAndEnterpriseLbl.text = [NSString stringWithFormat:@"%@/%@",taskComment.user.name,taskComment.user.enterprise];
    self.createDate.text = taskComment.createDate;
}

@end
