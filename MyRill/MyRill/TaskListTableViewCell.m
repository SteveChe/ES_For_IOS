//
//  TaskListTableViewCell.m
//  MyRill
//
//  Created by Siyuan Wang on 15/7/26.
//
//

#import "TaskListTableViewCell.h"
#import "ColorHandler.h"

@interface TaskListTableViewCell ()

@property (weak, nonatomic) IBOutlet UIView *layerView;

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

@end
