//
//  UserMsgTableViewCell.m
//  MyRill
//
//  Created by Siyuan Wang on 15/6/23.
//
//

#import "UserMsgTableViewCell.h"

@interface UserMsgTableViewCell ()

@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) UILabel *contentLbl;
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation UserMsgTableViewCell

- (instancetype)init {
    self = [super init];
    
    if (self) {
        
    }
    
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateCell:(NSDictionary *)dic {
    
}

@end
