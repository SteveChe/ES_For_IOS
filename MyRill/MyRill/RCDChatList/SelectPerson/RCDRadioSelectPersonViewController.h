//
//  RCDRadioSelectPersonViewController.h
//  MyRill
//
//  Created by Steve on 15/8/30.
//
//

#import "RCDAddressBookViewController.h"
typedef enum E_SELECTED_PERSON_TYPE
{
    e_Selected_Person_None = -1,
    e_Selected_Person_Radio = 0, //单选
    e_Selected_Check_Box = 1, //多选
}E_SELECTED_PERSON_TYPE;

@interface RCDRadioSelectPersonViewController : RCDAddressBookViewController

typedef void(^clickDone)(RCDRadioSelectPersonViewController *radioselectPersonViewController, NSArray *seletedUsers);

@property (nonatomic,copy) clickDone clickDoneCompletion;
@property (nonatomic,assign) E_SELECTED_PERSON_TYPE type;

@end
