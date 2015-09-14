//
//  BMCEmergencyTableViewCell.h
//  MyRill
//
//  Created by Siyuan Wang on 15/9/14.
//
//

#import <UIKit/UIKit.h>
@class EventVO;

@interface BMCEmergencyTableViewCell : UITableViewCell

- (void)updateBMCEmergencyCell:(EventVO *)eventVO;

@end
