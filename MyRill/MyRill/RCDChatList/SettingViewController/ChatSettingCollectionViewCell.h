//
//  ChatSettingCollectionViewCell.h
//  MyRill
//
//  Created by Steve on 15/7/22.
//
//

#import <UIKit/UIKit.h>

@class ESUserInfo;

@interface ChatSettingCollectionViewCell : UICollectionViewCell
- (void)updateCellData:(ESUserInfo *)userInfo;

@end
