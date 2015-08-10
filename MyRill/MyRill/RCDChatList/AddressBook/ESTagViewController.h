//
//  ESTagViewController.h
//  MyRill
//
//  Created by Steve on 15/7/28.
//
//

#import <UIKit/UIKit.h>
typedef enum
{
    TAG_TYPE_NONE = 0,
    TAG_TYPE_USER,
    TAG_TYPE_ENTERPRISE,
    TAG_TYPE_ASSIGNMENT,
}TAG_TYPE ;


@interface ESTagViewController : UITableViewController

@property (nonatomic,strong) NSString* userId;
@property (nonatomic,assign) TAG_TYPE tagType;
@property (nonatomic,strong) NSString* enterpriseId;

@end
