//
//  AddProfessionViewController.h
//  MyRill
//
//  Created by Siyuan Wang on 15/7/9.
//
//

#import <UIKit/UIKit.h>
#import "ESViewController.h"
@class ESProfession;

@protocol AddProfessionDelegate <NSObject>

- (void)addProfessionSuccess:(ESProfession *)profession;

@end

@interface AddProfessionViewController : ESViewController

@property (nonatomic, assign) id<AddProfessionDelegate> delegate;

@end
