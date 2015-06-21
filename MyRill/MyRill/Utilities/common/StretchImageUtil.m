//
//  StretchImageUtil.m
//  MyRill
//
//  Created by Steve on 15/6/14.
//
//

#import "StretchImageUtil.h"

#import "DeviceInfo.h"
//#import "BundleUtil.h"
//#import "BaiDubutton.h"

@implementation StretchImageUtil

+ (UIImage*)getStretchImage:(NSString*)imageName stretchPoint:(CGPoint)stretchPoint
{
    if (!imageName) return nil;
    
    //UIImage *image = [ViewsNavigation loadResourceImage:imageName];
    
    UIImage* image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:imageName ofType:@"png"]];//[UIImage imageNamed:imageName];
    //    return [image stretchableImageWithLeftCapWidth:stretchPoint.x topCapHeight:stretchPoint.y];
    
    return [StretchImageUtil stretchableImageWithLeftCapWidth:stretchPoint.x topCapHeight:stretchPoint.y targetImage:image];
}

+ (UIImageView*)getStretchImageViewWithImageName:(NSString*)imageName highlightedImageName:(NSString*)highlightedImageName stretchByRect:(CGRect)stretchRect
{
    UIImageView *imageView = [[UIImageView alloc] init];
    UIImage *image = [self getStretchImage:imageName stretchPoint:stretchRect.origin];
    UIImage *highlightedImage = [self getStretchImage:highlightedImageName stretchPoint:stretchRect.origin];
    imageView.image = image;
    imageView.highlightedImage = highlightedImage;
    [imageView sizeToFit];
    
    CGRect _frame = imageView.frame;
    _frame.size.width = stretchRect.size.width > 0 ? stretchRect.size.width : _frame.size.width;
    _frame.size.height = stretchRect.size.height > 0 ? stretchRect.size.height : _frame.size.height;
    imageView.frame = _frame;
    return imageView;
}

//+ (UIButton*)getStretchButtonWithImageName:(NSString*)imageName highlightedImageName:(NSString*)highlightedImageName disabledImageName:(NSString*)disabledImageName stretchByRect:(CGRect)stretchRect
//{
//    //UIButton *button = [FixedBackgroundButton fixedBackgroundButtonWithType:UIButtonTypeCustom];
//    //Turn UIButton to BaiDubutton
//    BaiDubutton *button = [BaiDubutton buttonWithType:UIButtonTypeCustom];
//    button.superViewName = @"BaseMapPage";
//    UIImage *image = [self getStretchImage:imageName stretchPoint:stretchRect.origin];
//    UIImage *highlightedImage = [self getStretchImage:highlightedImageName stretchPoint:stretchRect.origin];
//    UIImage *disabledImage = [self getStretchImage:disabledImageName stretchPoint:stretchRect.origin];
//    [button setBackgroundImage:image forState:UIControlStateNormal];
//    [button setBackgroundImage:highlightedImage forState:UIControlStateHighlighted];
//    [button setBackgroundImage:disabledImage forState:UIControlStateDisabled];
//    CGSize imageSize = image.size;
//    if (!image)
//    {
//        imageSize = highlightedImage.size;
//    }
//    
//    CGRect _frame = button.frame;
//    _frame.size.width = stretchRect.size.width > 0 ? stretchRect.size.width : imageSize.width;
//    _frame.size.height = stretchRect.size.height > 0 ? stretchRect.size.height : imageSize.height;
//    button.frame = _frame;
//    return button;
//}

/**
 * 拉伸图片 版本兼容
 *		@param		targetImage原始图片
 *		@return     新图片
 *		@notes
 */
+ (UIImage *)stretchableImageWithLeftCapWidth:(NSInteger)leftCapWidth
                                 topCapHeight:(NSInteger)topCapHeight
                                  targetImage:(UIImage *)targetImage {
    if ([targetImage respondsToSelector:@selector(resizableImageWithCapInsets:)]){
        UIEdgeInsets inset = UIEdgeInsetsMake(topCapHeight, leftCapWidth, targetImage.size.height - (topCapHeight + 1), targetImage.size.width - (leftCapWidth + 1));
        return [targetImage resizableImageWithCapInsets:inset];
    }
    return [targetImage stretchableImageWithLeftCapWidth:leftCapWidth topCapHeight:topCapHeight];
}
@end