//
//  UIPageNavigator.h
//  MyRill
//
//  Created by Steve on 15/6/14.
//
//

#import <UIKit/UIKit.h>

//*******************************old interface
@interface UIPageNavigator : NSObject 

@property (nonatomic, retain) NSCache* imageCache;

/**
 *	加载资源
 *
 *		@param	[in]	statusbarFrame	状态栏大小
 *
 *		@return	nil
 */
+ (UIImage *)loadResourceImage:(NSString*)imageName;


+ (UIImage *)loadResourceImageNoCache:(NSString*)imageName;

@end
