//
//  ImageTableViewCell.h
//  MyRill
//
//  Created by Siyuan Wang on 15/8/31.
//
//

#import <UIKit/UIKit.h>
@class ESTaskComment;
@interface ImageTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *placeholderImg;
@property (weak, nonatomic) IBOutlet UILabel *contentLbl;

- (void)updateMessage:(ESTaskComment *)taskComment;

@end