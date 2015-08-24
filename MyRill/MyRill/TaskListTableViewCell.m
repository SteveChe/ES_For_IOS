//
//  TaskListTableViewCell.m
//  MyRill
//
//  Created by Siyuan Wang on 15/7/26.
//
//

#import "TaskListTableViewCell.h"
#import "ColorHandler.h"
#import "ESTask.h"
#import "ESUserInfo.h"
#import "UIImageView+WebCache.h"
#import "ESTaskComment.h"

@interface TaskListTableViewCell ()

@property (nonatomic, weak) IBOutlet UIView *layerView;
@property (weak, nonatomic) IBOutlet UIView *noticeView;
@property (nonatomic, weak) IBOutlet UILabel *titleLbl;
@property (nonatomic, weak) IBOutlet UILabel *leadLbl;
@property (nonatomic, weak) IBOutlet UILabel *replyUserLbl;
@property (nonatomic, weak) IBOutlet UILabel *lastReplyLbl;
@property (nonatomic, weak) IBOutlet UILabel *endDateLbl;
@property (nonatomic, weak) IBOutlet UIImageView *replyUserImg;
@property (nonatomic, weak) IBOutlet UILabel *replyTimeLbl;
@property (weak, nonatomic) IBOutlet UIImageView *tagImg;

@end

@implementation TaskListTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.layerView.layer.borderWidth = 1.f;
    self.layerView.layer.borderColor = [ColorHandler colorFromHexRGB:@"DDDDDD"].CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateTackCell:(ESTask *)task {
    if (task.isUpdate == YES) {
        self.noticeView.backgroundColor = [ColorHandler colorFromHexRGB:@"06A7E1"];
    } else {
        self.noticeView.backgroundColor = [UIColor whiteColor];
    }
    
    self.titleLbl.text = [@"任务名称:" stringByAppendingString:task.title];
    
    NSString *leadStr = [NSString stringWithFormat:@"负责人:%@",task.personInCharge.userName];
    if (![task.personInCharge.enterprise isEqualToString:@""]) {
        leadStr = [leadStr stringByAppendingString:@"/"];
        leadStr = [leadStr stringByAppendingString:task.personInCharge.enterprise];
    }
    self.leadLbl.text = leadStr;
    
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *userID = [userDefaultes stringForKey:@"UserId"];
    if ([userID isEqualToString:task.comments.user.userId]) {
        self.replyUserLbl.text = @"我";
    } else {
        self.replyUserLbl.text = task.comments.user.userName;
    }
    
    [self.replyUserImg sd_setImageWithURL:[NSURL URLWithString:task.comments.user.portraitUri] placeholderImage:[UIImage imageNamed:@"头像_100"]];
    
    NSString *replyDateStr = [task.comments.createDate stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
    self.replyTimeLbl.text = [replyDateStr isEqualToString:@""]?@"----/--/-- --:--":[replyDateStr substringToIndex:16];
    self.lastReplyLbl.text = [task.comments.content isEqualToString:@""]?@"最新回复:——":[@"最新回复:" stringByAppendingString:task.comments.content];
    
    if ([task.initiator.userId isEqualToString:userID]) {
        self.tagImg.image = [UIImage imageNamed:@"发起人.png"];
    } else {
        self.tagImg.image = [UIImage imageNamed:@"关注人.png"];
    }
    
    //创建日期格式化对象
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    //创建了两个日期对象
    NSDate *date1=[NSDate date];
    NSString *curdate = [dateFormatter stringFromDate:date1];
    NSDate *dateNow = [dateFormatter dateFromString:curdate];
    NSDate *dateEnd = [dateFormatter dateFromString:[task.endDate substringToIndex:16]];
    
    //取两个日期对象的时间间隔：
    NSTimeInterval time=[dateEnd timeIntervalSinceDate:dateNow];
    //这里的NSTimeInterval 并不是对象，是基本型，其实是double类型，是由c定义的:typedef double NSTimeInterval;
    
    if (time <= 0) {
        self.endDateLbl.text = @"超期";
        return;
    }
    
    //到期天数:足一天显示天数，否则化整为时，否则化整为分，否则无
    int days=((int)time)/(3600*24);
    if (days >= 1) {
        self.endDateLbl.text = [NSString stringWithFormat:@"%d天",days];
    } else {
        int hours=((int)time)/3600;
        if (hours >= 1) {
            self.endDateLbl.text = [NSString stringWithFormat:@"%d时",hours];
        } else {
            int munites = ((int)time)/60;
            self.endDateLbl.text = [NSString stringWithFormat:@"%d分",munites];
            if (munites == 0) {
                self.endDateLbl.text = @"";
            }
        }
    }
}

- (void)setReplyUserImg:(UIImageView *)replyUserImg {
    _replyUserImg = replyUserImg;
    
    _replyUserImg.layer.cornerRadius = 18.5f;
}

@end
