//
//  RemindDateTableViewCell.m
//  MyRill
//
//  Created by Siyuan Wang on 15/8/9.
//
//

#import "RemindDateTableViewCell.h"

@interface RemindDateTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *remindTimeLbl;
@property (weak, nonatomic) IBOutlet UIImageView *checkBoxImg;

@end

@implementation RemindDateTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setRemindTime:(NSString *)remindTime {
    _remindTime = remindTime;
    
    self.remindTimeLbl.text = _remindTime;
}

- (void)setIsCheck:(BOOL *)isCheck {
    _isCheck = isCheck;
    
    if (_isCheck) {
        self.checkBoxImg.image = [UIImage imageNamed:@"单选框-选中.png"];
    } else {
        self.checkBoxImg.image = [UIImage imageNamed:@"单选框.png"];
    }
}

@end
