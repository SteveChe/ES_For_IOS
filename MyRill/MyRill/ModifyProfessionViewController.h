//
//  ModifyProfessionViewController.h
//  MyRill
//
//  Created by Siyuan Wang on 15/7/13.
//
//

#import <UIKit/UIKit.h>
@class ESProfession;

@protocol ModifyProfessionDelegate <NSObject>

- (void)modifyProfessionSuccess:(ESProfession *)profession;

@end

@interface ModifyProfessionViewController : UIViewController

@property (nonatomic, assign) id<ModifyProfessionDelegate> delegate;

- (void)loadProfessionData:(ESProfession *)profession;

@end
