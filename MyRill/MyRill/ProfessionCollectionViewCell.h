//
//  ProfessionCollectionViewCell.h
//  MyRill
//
//  Created by Siyuan Wang on 15/7/8.
//
//

#import <UIKit/UIKit.h>
@class ESProfession;

@interface ProfessionCollectionViewCell : UICollectionViewCell

- (void)updateCellData:(ESProfession *)profession;

@end
