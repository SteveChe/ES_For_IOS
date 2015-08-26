//
//  RootFunctionView.m
//  WeChatPublic
//
//  Created by Adrain Sun on 8/25/15.
//  Copyright (c) 2015 DaydayStudio. All rights reserved.
//

#import "RootFunctionView.h"

@interface RootFunctionView () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *listData;
@property (nonatomic, assign) CGPoint point;
@end

@implementation RootFunctionView

- (void)setData:(NSArray *)data;
{
    [self setListData:data];
    [self.tableView reloadData];
}

- (void)showInPoint:(CGPoint)point
{
    [self setPoint:point];
    [self setFrame:CGRectMake((point.x - CGRectGetWidth(self.frame) / 2), (point.y - 20.0f), CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
    [self setHidden:NO];
    [self setAlpha:0.0f];
    [UIView animateWithDuration:0.3f animations:^{
        [self setAlpha:1.0f];
        [self setFrame:CGRectMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame) - CGRectGetHeight(self.frame), CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
    }];
}

- (void)dismiss
{
    [UIView animateWithDuration:0.3f animations:^{
        [self setAlpha:0.0f];
        [self setFrame:CGRectMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame) + CGRectGetHeight(self.frame), CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
    } completion:^(BOOL finished) {
        [self setHidden:YES];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _listData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:@"Identifier"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Identifier"];
        [cell setBackgroundColor:[UIColor clearColor]];
        [cell.contentView setBackgroundColor:[UIColor clearColor]];
    }
    [cell.textLabel setText:[_listData objectAtIndex:indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_selectionAction) {
        _selectionAction([_listData objectAtIndex:indexPath.row]);
    }
}

@end
