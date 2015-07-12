//
//  ColorHandler.m
//  Easy Check-in
//
//  Created by 7k on 15/5/22.
//  Copyright (c) 2015年 qlwy7k. All rights reserved.
//

#import "ColorHandler.h"

@implementation ColorHandler

+ (BOOL)isNullOrNilNumber:(NSNumber *)num
{
    return [num isEqual:[NSNull null]] || num == nil;
}

+ (BOOL)isNullOrEmptyString:(NSString *)str
{
    return [str isEqual:[NSNull null]] || str == nil || str.length == 0;
}

+ (UIColor *)colorFromHexRGB:(NSString *)inColorString
{
    UIColor *result = nil;
    result = [self colorFromHexRGB:inColorString Alpha:1];
    return result;
}

+ (UIColor *)colorFromHexRGB:(NSString *)inColorString Alpha:(float)alpha
{
    UIColor *result = nil;
    unsigned int colorCode = 0;
    unsigned char redByte, greenByte, blueByte;
    
    if (nil != inColorString)
    {
        NSScanner *scanner = [NSScanner scannerWithString:inColorString];
        (void) [scanner scanHexInt:&colorCode]; // ignore error
    }
    redByte = (unsigned char) (colorCode >> 16);
    greenByte = (unsigned char) (colorCode >> 8);
    blueByte = (unsigned char) (colorCode); // masks off high bits
    result = [UIColor
              colorWithRed: (float)redByte / 0xff
              green: (float)greenByte/ 0xff
              blue: (float)blueByte / 0xff
              alpha:alpha];
    return result;
}

@end
