//
//  BMCEmergencyDetailViewController.h
//  MyRill
//
//  Created by Siyuan Wang on 15/9/17.
//
//

#import <UIKit/UIKit.h>
#import "ESViewController.h"
@class EventVO;

@interface BMCEmergencyDetailViewController : ESViewController

@property (nonatomic, copy) NSString *resId;     //
@property (nonatomic, strong) EventVO *eventVO;

@end
