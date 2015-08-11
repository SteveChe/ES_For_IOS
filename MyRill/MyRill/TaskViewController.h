//
//  TaskViewController.h
//  MyRill
//
//  Created by Siyuan Wang on 15/8/6.
//
//

#import <UIKit/UIKit.h>
@class ESTask;

@interface TaskViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *startDateLbl;
@property (nonatomic, strong) ESTask *taskModel;

- (void)headViewAnotherBtnOnClicked:(BOOL)isOpen;

@end
