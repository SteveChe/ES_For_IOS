//
//  CustomMessageBox.m
//  MyRill
//
//  Created by Steve on 15/6/14.
//
//
#import <QuartzCore/QuartzCore.h>

#import "CustomMessageBox.h"
#import "DeviceInfo.h"
//#import "BundleUtil.h"
#import "UIPageNavigator.h"
#import "StretchImageUtil.h"

@implementation CustomMessageBox

@synthesize bgImage = m_bgImage;
@synthesize messageTitle = m_messageTitle;

- (void)dealloc
{
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        m_bgImage = [[UIImageView alloc]initWithFrame:frame];
        m_messageTitle = [[UILabel alloc]init ];
        m_messageTitle.font = [UIFont boldSystemFontOfSize:NORMAL_TITLE_FONT_SIZE];
        m_messageTitle.backgroundColor = [UIColor clearColor];
        m_messageTitle.textColor = [UIColor whiteColor];
        m_messageTitle.textAlignment = NSTextAlignmentCenter;
        
        self.backgroundColor = [UIColor clearColor];
        
        [self addSubview:m_bgImage];
        [self addSubview:m_messageTitle];
    }
    return self;
}

- (void)setMessageTitle:(NSString *)messageTitle andBackgroundImg:(NSString *) imageName
{
    if(messageTitle == nil)
        return;
    
    m_messageTitle.text = messageTitle;
    [m_messageTitle sizeToFit];
    
    if (imageName == nil)
    {
        CGPoint myOrigin = m_bgImage.frame.origin;
        CGFloat leftrightmargin = 20.0f;
        CGFloat topshadow = 1.0f;
        CGFloat bottomshadow = 5.0f;
        CGFloat leftrightshadow = 3.0f;
        //
        //         m_bgImage.image = [[UIPageNavigator loadResourceImage:@"icon_warning_bg"]stretchableImageWithLeftCapWidth:5.0f topCapHeight:3.0f  ];
        m_bgImage.image = [StretchImageUtil stretchableImageWithLeftCapWidth:5 topCapHeight:3 targetImage:[UIPageNavigator loadResourceImage:@"icon_warning_bg"]];
        [m_bgImage sizeToFit];
        
        CGRect _frame = m_bgImage.frame;
        _frame.origin = CGPointMake(0, 0);
        _frame.size.width = 2*leftrightshadow + 2*leftrightmargin + m_messageTitle.frame.size.width;
        m_bgImage.frame = _frame;
        
        _frame.origin = myOrigin;
        _frame.origin.x = (IPHONE_SCREEN_WIDTH -  _frame.size.width)/2;
        self.frame = _frame;
        //text frame
        _frame = m_messageTitle.frame;
        _frame.origin.x = leftrightshadow + leftrightmargin;
        _frame.origin.y = topshadow + (m_bgImage.frame.size.height - topshadow -bottomshadow - _frame.size.height)/2;
        m_messageTitle.frame = _frame;
    }
    else
    {
        //         m_bgImage.image = [[UIPageNavigator loadResourceImage:imageName]stretchableImageWithLeftCapWidth:9.0f topCapHeight:9.0f  ];
        m_bgImage.image = [StretchImageUtil stretchableImageWithLeftCapWidth:9 topCapHeight:9 targetImage:[UIPageNavigator loadResourceImage:imageName]];
    }
}

- (void)showMessage:(NSTimeInterval)duration
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    [animation setDelegate:self];
    
    animation.values = [NSArray arrayWithObjects:[NSNumber numberWithFloat:1.0],
                        [NSNumber numberWithFloat:1.0],[NSNumber numberWithFloat:1.0],
                        [NSNumber numberWithFloat:1.0],[NSNumber numberWithFloat:0.9],
                        [NSNumber numberWithFloat:0.8],[NSNumber numberWithFloat:0.7],
                        [NSNumber numberWithFloat:0.6],[NSNumber numberWithFloat:0.4],
                        [NSNumber numberWithFloat:0.2],[NSNumber numberWithFloat:0.0],
                        nil];
    animation.duration = duration;
    animation.repeatCount = 1;
    animation.removedOnCompletion = NO;
    animation.fillMode=kCAFillModeForwards;
    [self.layer addAnimation:animation forKey:@"WarningMessageAnimation"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    self.hidden = YES;
}
@end

@implementation CustomMessageTip
@synthesize bgImage = m_bgImage;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        m_bgImage = [[UIImageView alloc]init];
        
        m_startPoint = frame.origin;
        
        m_messageTitle = [[UILabel alloc]init];
        m_messageTitle.font = NORMAL_TITLE_FONT;
        m_messageTitle.backgroundColor = [UIColor clearColor];
        m_messageTitle.textColor = [UIColor whiteColor];
        m_messageTitle.textAlignment = NSTextAlignmentCenter;
        
        self.backgroundColor = [UIColor clearColor];
        
        [self addSubview:m_bgImage];
        [self addSubview:m_messageTitle];
        
        m_arrowHeight = 7.0f;
        
        self.userInteractionEnabled = NO;
    }
    return self;
}

- (void)showMessage:(NSTimeInterval)duration
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    [animation setDelegate:self];
    
    animation.values = [NSArray arrayWithObjects:[NSNumber numberWithFloat:1.0],
                        [NSNumber numberWithFloat:1.0],[NSNumber numberWithFloat:1.0],
                        [NSNumber numberWithFloat:1.0],[NSNumber numberWithFloat:0.9],
                        [NSNumber numberWithFloat:0.8],[NSNumber numberWithFloat:0.7],
                        [NSNumber numberWithFloat:0.6],[NSNumber numberWithFloat:0.4],
                        [NSNumber numberWithFloat:0.2],[NSNumber numberWithFloat:0.0],
                        nil];
    animation.duration = duration;
    animation.repeatCount = 1;
    animation.removedOnCompletion = NO;
    animation.fillMode=kCAFillModeForwards;
    [self.layer addAnimation:animation forKey:@"TipMessageAnimation"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    self.hidden = YES;
}

@end