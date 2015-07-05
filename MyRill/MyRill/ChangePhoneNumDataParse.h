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
- (void)changePhoneNUmFail:(NSString *)errorMsg;

@end

@interface ChangePhoneNumDataParse : NSObject

@property (nonatomic, weak) id<ChangePhoneNumDelegate> delegate;

- (void)changePhoneNumWithNewPhoneNum:(NSString *)newphoneNum vertificationCode:(NSString *)code;

@end
