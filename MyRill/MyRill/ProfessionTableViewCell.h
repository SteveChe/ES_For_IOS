//
//  ProfessionTableViewCell.h
//  MyRill
//
//  Created by Siyuan Wang on 15/7/15.
//
//

#import <UIKit/UIKit.h>
@class ESProfession;

@interface ProfessionTableViewCell : UITableViewCell

- (void)updateProfessionCell:(ESProfession *)profession;

@end
