//
//  MessageListTableViewCell.h
//  MyRill
//
//  Created by Siyuan Wang on 15/8/9.
//
//

#import <UIKit/UIKit.h>
@class ESTaskComment;

@interface MessageListTableViewCell : UITableViewCell

- (void)updateMessage:(ESTaskComment *)taskComment;

@end
