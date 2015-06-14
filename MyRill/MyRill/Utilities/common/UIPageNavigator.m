//
//  UIPageNavigator.m
//  MyRill
//
//  Created by Steve on 15/6/14.
//
//

#import "UIPageNavigator.h"
static UIPageNavigator *_navInstance = nil;

@implementation UIPageNavigator
+(UIPageNavigator*)getInstance{
    @synchronized(self){
        if (_navInstance==nil) {
            _navInstance = [[UIPageNavigator alloc] init];
        }
        return _navInstance;
    }
}

-(id)init{
    self=[super init];
    if (self) {
        _imageCache = [[NSCache alloc] init];
        
        //显示状态栏 ios >3.2
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    }
    return self;
}

+ (UIImage *)loadResourceImage:(NSString*)imageName
{
    UIPageNavigator* navigation = [UIPageNavigator getInstance];
    UIImage* image = [navigation.imageCache objectForKey:imageName];
    if (nil != image)
    {
        return image;
    }
    else
    {
        NSString *path = [[NSBundle mainBundle] pathForResource:imageName ofType:@"png"];
        if (path == nil) {
            return [UIImage imageNamed:imageName];
        }
        else
        {
            image = [UIImage imageWithContentsOfFile:path];
            [navigation.imageCache setObject:image forKey:imageName];
            return image;
        }
        
    }
}


+ (UIImage *)loadResourceImageNoCache:(NSString*)imageName
{
    
    UIImage* image = nil;
    
    NSString *path = [[NSBundle mainBundle] pathForResource:imageName ofType:@"png"];
    
    if (path == nil) {
        
        return [UIImage imageNamed:imageName];
    }
    else
    {
        image = [UIImage imageWithContentsOfFile:path];
        
        return image;
    }
    
}

@end
