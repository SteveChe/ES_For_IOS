//
//  RootFunctionView.h
//  WeChatPublic
//
//  Created by Adrain Sun on 8/25/15.
//  Copyright (c) 2015 DaydayStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootFunctionView : UIView

@property (nonatomic, copy) void(^selectionAction)(NSString *btnTitle);

- (void)setData:(NSArray *)data;

- (void)showInPoint:(CGPoint)point;
- (void)dismiss;

@end