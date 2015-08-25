//
//  MessageListSelfTableViewCell.h
//  MyRill
//
//  Created by Siyuan Wang on 15/8/9.
//
//

#import <UIKit/UIKit.h>
@class ESTaskComment;

@interface MessageListSelfTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextView *contentTxtVIew;
- (void)updateMessage:(ESTaskComment *)taskComment;

@end
