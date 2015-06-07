//
//  ColorHandler.h
//  Easy Check-in
//
//  Created by 7k on 15/5/22.
//  Copyright (c) 2015年 qlwy7k. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ColorHandler : NSObject

+ (UIColor *)colorFromHexRGB:(NSString *)inColorString;
+ (UIColor *)colorFromHexRGB:(NSString *)inColorString Alpha:(float)alpha;

@end
