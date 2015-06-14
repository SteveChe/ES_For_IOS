//
//  UIDevice+screenType.m
//  MyRill
//
//  Created by Steve on 15/6/14.
//
//

#import "UIDevice+screenType.h"

#import "UIDevice+screenType.h"

@implementation UIDevice (screenType)

+ (UIDeviceScreenType)currentScreenType
{
    UIDeviceScreenType ret = UIDeviceScreenType_iPhoneStandard;
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
        if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
            screenHeight = screenHeight * [[UIScreen mainScreen] scale];
        }
        if (screenHeight <= 480.0f) {
            ret = UIDeviceScreenType_iPhoneStandard;
        } else if (screenHeight == 960.0f) {
            ret = UIDeviceScreenType_iPhoneRetina35Inch;
        } else if (screenHeight == 1136.0f) {
            ret = UIDeviceScreenType_iPhoneRetina4Inch;
        } else if (screenHeight == 1334.0f) {
            ret = UIDeviceScreenType_iPhoneRetina47Inch;
        } else {
            ret = UIDeviceScreenType_iPhoneRetina55Inch;
        }
    } else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
            ret = UIDeviceScreenType_iPadRetina;
        } else {
            ret = UIDeviceScreenType_iPadStandard;
        }
    }
    return ret;
}

@end