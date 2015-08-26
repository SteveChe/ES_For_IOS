//
//  RootViewControllerImageCell.h
//  WeChatPublic
//
//  Created by Adrain Sun on 8/25/15.
//  Copyright (c) 2015 DaydayStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootImageCell : UITableViewCell

- (void)setTitle:(NSString *)title image:(NSString *)imageUrl instruction:(NSString *)instruction;

- (void)setTitle:(NSString *)title time:(NSString *)time image:(NSString *)image instruction:(NSString *)instruction;

@end