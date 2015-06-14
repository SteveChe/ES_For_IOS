//
//  UIDevice+screenType.h
//  MyRill
//
//  Created by Steve on 15/6/14.
//
//

#import <UIKit/UIKit.h>

typedef enum {
    UIDeviceScreenType_iPhoneStandard         = 1,    // iPhone 1,3,3GS Standard Display  (320x480px)
    UIDeviceScreenType_iPhoneRetina35Inch     = 2,    // iPhone 4,4S Retina Display 3.5"  (640x960px)
    UIDeviceScreenType_iPhoneRetina4Inch      = 3,    // iPhone 5 Retina Display 4"       (640x1136px)
    UIDeviceScreenType_iPhoneRetina47Inch     = 4,    // iPhone 6        Display 4.7"  (750x1334px)
    UIDeviceScreenType_iPhoneRetina55Inch     = 5,    // iPhone 6 Plus      Display 5.5"  (1080x1920px)
    UIDeviceScreenType_iPadStandard           = 6,    // iPad 1,2 Standard Display        (1024x768px)
    UIDeviceScreenType_iPadRetina             = 7     // iPad 3 Retina Display            (2048x1536px)
}UIDeviceScreenType;

@interface UIDevice (screenType)

+ (UIDeviceScreenType)currentScreenType;

@end
