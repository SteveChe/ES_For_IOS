//
//  StretchImageUtil.h
//  MyRill
//
//  Created by Steve on 15/6/14.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface StretchImageUtil : NSObject {
    
}

+ (UIImage*)getStretchImage:(NSString*)imageName stretchPoint:(CGPoint)stretchPoint;
+ (UIImageView*)getStretchImageViewWithImageName:(NSString*)imageName highlightedImageName:(NSString*)highlightedImageName stretchByRect:(CGRect)stretchRect;
//+ (UIButton*)getStretchButtonWithImageName:(NSString*)imageName highlightedImageName:(NSString*)highlightedImageName disabledImageName:(NSString*)disabledImageName stretchByRect:(CGRect)stretchRect;

/**
 * 拉伸图片 版本兼容
 *		@param		targetImage原始图片
 *		@return     新图片
 *		@notes
 */
+ (UIImage *)stretchableImageWithLeftCapWidth:(NSInteger)leftCapWidth
                                 topCapHeight:(NSInteger)topCapHeight
                                  targetImage:(UIImage *)targetImage;

@end
