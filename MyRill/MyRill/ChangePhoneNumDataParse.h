//
//  ChangePhoneNumDataParse.h
//  MyRill
//
//  Created by Siyuan Wang on 15/7/5.
//
//

#import <Foundation/Foundation.h>

@protocol ChangePhoneNumDelegate <NSObject>

- (void)changePhoneNumSuccess;
- (void)changePhoneNUmFail;

@end

@interface ChangePhoneNumDataParse : NSObject

- (void)changePhoneNumWithNewPhoneNum:(NSString *)newphoneNum vertificationCode:(NSString *)code;

@end
