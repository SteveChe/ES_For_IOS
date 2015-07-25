//
//  CustomShowMessage.m
//  MyRill
//
//  Created by Steve on 15/6/14.
//
//
#import <QuartzCore/QuartzCore.h>

#import "CustomShowMessage.h"
#import "CustomMessageBox.h"
#import "DeviceInfo.h"

#define WAIT_INDICATORWHEEL_WIDTH 24
#define WAIT_INDICATORWHEEL_X 65
#define WAIT_INDICATORWHEEL_Y 28

#define WAIT_DROP_WIDTH 25
#define WAIT_DROP_ORGIN_X 47
#define WAIT_DROP_ORGIN_Y (64.0-25.0)/2.0

#define COVERSCREEN_X  0
#define COVERSCREEN_Y  0
#define COVERSCREEN_WIDTH  IPHONE_SCREEN_WIDTH //320
#define COVERSCREEN_HEIGHT IPHONE_SCREEN_HEIGHT//(IPHONE_SCREEN_HEIGHT - NAVIGATION_BAR_HEIGHT)

#define WAIT_INDICATORVIEW_Y (IPHONE_SCREEN_HEIGHT - WAIT_INDICATORVIEW_HEIGHT)/2.0
#define WAIT_INDICATORVIEW_WIDTH 190
#define WAIT_INDICATORVIEW_HEIGHT 64
#define WAIT_INDICATORVIEW_ALPHA 0.7
#define WAIT_INDICATORVIEW_CORNER_RADIAN 2



#define WAIT_INDICATORLABEL_WIDTH 85
#define WAIT_INDICATORLABEL_HEIGHT 24
#define WAIT_INDICATORLABEL_FONTSIZE 16
#define COVERSCREEN_X  0


#define LINE_HEIGHT 28.0
#define LINE_FRAME  CGRectMake((COVERSCREEN_WIDTH - WAIT_INDICATORVIEW_WIDTH)/2.0 + 5.0 + 14.0 + 25.0 + 8.0 +WAIT_INDICATORLABEL_WIDTH, WAIT_INDICATORVIEW_Y + (WAIT_INDICATORVIEW_HEIGHT - LINE_HEIGHT)/2.0 , .5, LINE_HEIGHT)

#define CROSS_FRAME CGRectMake((COVERSCREEN_WIDTH - WAIT_INDICATORVIEW_WIDTH)/2.0 + 5.0 + 14.0 + 25.0 + 8.0 +WAIT_INDICATORLABEL_WIDTH, WAIT_INDICATORVIEW_Y + (WAIT_INDICATORVIEW_HEIGHT - 42.0)/2.0 ,42.0 , 42.0)


#define COVER_TOP_FRAME CGRectMake(5, IPHONE_STATUS_BAR_HEIGHT,COVERSCREEN_WIDTH - 5, COVERSCREEN_Y)

#define DROP_BG_FRAME CGRectMake((COVERSCREEN_WIDTH - WAIT_INDICATORVIEW_WIDTH)/2.0,WAIT_INDICATORVIEW_Y,WAIT_INDICATORVIEW_WIDTH,WAIT_INDICATORVIEW_HEIGHT)

#define DROP_BG_BIG_FRAME CGRectMake((COVERSCREEN_WIDTH - WAIT_INDICATORVIEW_WIDTH)/2.0 - WAIT_INDICATORVIEW_WIDTH*.5,WAIT_INDICATORVIEW_Y - WAIT_INDICATORVIEW_HEIGHT*.5,WAIT_INDICATORVIEW_WIDTH*2,WAIT_INDICATORVIEW_HEIGHT*2)


#define DROP_FRAME CGRectMake((COVERSCREEN_WIDTH - WAIT_INDICATORVIEW_WIDTH)/2.0 + 5.0 + 14.0 , WAIT_INDICATORVIEW_Y + WAIT_DROP_ORGIN_Y, WAIT_DROP_WIDTH, WAIT_DROP_WIDTH)

@interface CustomShowMessage()
{
    CALayer *_circle;
    CALayer *_drop;
    CALayer *_line;
    CustomCancel _cancelMethod;
    
}

@property(nonatomic, strong) CustomMessageBox* msgBox;
//@property(nonatomic, strong) BaiDubutton *cancelButton;
@property(nonatomic, strong) UIView* coverScreenView;
@property(nonatomic, strong) UIView* coverTopView;
@property(nonatomic, strong) UIView* bg;
@property(nonatomic, strong) UIImageView* drop_bg;
@property(nonatomic, assign) BOOL isShow;
@property(nonatomic, strong) NSTimer* timeShow;

-(void)hiddenBox;

@end

@implementation CustomShowMessage
@synthesize msgBox = _msgBox;
@synthesize coverTopView= _coverTopView;
@synthesize coverScreenView = _coverScreenView;
@synthesize isShow = _isShow;
@synthesize timeShow = _timeShow;

static CustomShowMessage *_sharedInstance = nil;

+(CustomShowMessage*)getInstance
{
    
    
    @synchronized(self){
        if ( _sharedInstance == nil) {
            _sharedInstance = [[CustomShowMessage alloc] init];
        }
    }
    
    return _sharedInstance;
}

-(id) init
{
    
    self = [super init];
    if (self) {
        
        
        self.isShow = NO;
    }
    
    return self;
}


+(void)releaseInstance
{
    _sharedInstance = nil;
}


-(void)dealloc
{
    
}

- (void)showNotificationMessageAtMain:(NSString *)messageTitle
{
    
    CGRect _frame = CGRectZero;
    
    int leftRightMargin = 20;
    int boxHeight = 32;
    
    CGSize sysSize = [messageTitle sizeWithFont:NORMAL_TITLE_FONT constrainedToSize:CGSizeMake(IPHONE_SCREEN_WIDTH, 1000) lineBreakMode:NSLineBreakByWordWrapping];
    
    _frame = CGRectMake(0, 0, sysSize.width + 2* leftRightMargin, boxHeight);
    _frame.origin.x = (IPHONE_SCREEN_WIDTH -  _frame.size.width)/2;
    _frame.origin.y = IPHONE_SCREEN_HEIGHT -  _frame.size.height - 95;
    
    [self showNotificationMessage:messageTitle WithBgImg:nil AndFrame:_frame withAnimation:YES];
    
}


- (void)showNotificationMessage:(NSString *)messageTitle
{
    
    [self showNotificationMessage:messageTitle withDuration:2.0];
    
}

-(void)showNotificationMessage:(NSString *)messageTitle withDuration:(NSTimeInterval)duration
{
    if(_msgBox)
    {
        [_msgBox removeFromSuperview];
        _msgBox = nil;
    }
    
    //    UIViewController* topPage = [[UIPageNavigator getInstance] rootViewController];
    UIWindow *windows = [UIApplication sharedApplication].keyWindow;
    int boxHeight = 32;
    
    
    CGRect tmpFrame = CGRectZero; //CGRectMake(0, 0, sysSize.width + 2* leftRightMargin, boxHeight);
    tmpFrame.origin.x = 0;
    tmpFrame.origin.y = windows.rootViewController.view.frame.size.height -  boxHeight - 50.0f;
    
    _msgBox = [[CustomMessageBox alloc]initWithFrame:tmpFrame];
    [_msgBox setMessageTitle:messageTitle andBackgroundImg:nil];
    
    [windows addSubview:_msgBox];
    
    [_msgBox showMessage:duration];
}


-(void)showNotificationMessage:(NSString *)messageTitle WithBgImg:(NSString *)imageName AndFrame:(CGRect)frame withAnimation:(bool)needAnimation
{
    [self showNotificationMessage:messageTitle WithBgImg:imageName AndFrame:frame withAnimation:needAnimation withDuration:2.0];
}

- (void)showNotificationMessage:(NSString *)messageTitle WithBgImg:(NSString *)imageName AndFrame:(CGRect)frame withAnimation:(bool)needAnimation  withDuration:(NSTimeInterval)duration
{
    
    //   UIViewController* topPage = [[UIPageNavigator getInstance] rootViewController];
    UIWindow *windows = [UIApplication sharedApplication].keyWindow;
    
    if(_msgBox)
    {
        [_msgBox removeFromSuperview];
        _msgBox = nil;
    }
    
    _msgBox = [[CustomMessageBox alloc]initWithFrame:frame];
    [_msgBox setMessageTitle:messageTitle andBackgroundImg:imageName];
    
    [windows addSubview:_msgBox];
    
    if(needAnimation)
        [_msgBox showMessage:duration];
}

- (void)showWaitingIndicatorWithoutBackground:(IndicatorTYPE)type
{
    [self showWaitingIndicator:type];
    _bg.hidden = YES;
    _drop_bg.hidden = YES;
}

- (void)showWaitingIndicator:(IndicatorTYPE)type withCancelMethod:(CustomCancel)cancel
{
    [self showWaitingIndicator:type];
    _cancelMethod = [cancel copy];
}

-(void)showWaitingIndicator:(IndicatorTYPE)type
{
    [self hideWaitingIndicatorWithoutAnimation];
    
    _cancelMethod = nil;
    if (_coverScreenView == nil) {
        
        [self initContentView];
        UILabel* searchLabel = (UILabel*)[_coverScreenView viewWithTag:32345];
        searchLabel.text = [self getWaitingText:type];
        [self hideSetting];
        
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window addSubview: _coverScreenView];
        [window addSubview:_coverTopView];
        
        [_circle removeAllAnimations];
        CABasicAnimation* rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotationAnimation.toValue = @(2*M_PI);//[NSNumber numberWithFloat:(2 * M_PI)];
        rotationAnimation.duration = 1.0f;
        rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        rotationAnimation.repeatCount = HUGE_VALF;
        [_circle addAnimation:rotationAnimation forKey:@"rotateAnimation"];
        
        [UIView animateWithDuration:.3 animations:^{
            [self addSetting];
            
        }];
        
    }
    else
    {
        UILabel* searchLabel = (UILabel*)[_coverScreenView viewWithTag:32345];
        searchLabel.text = [self getWaitingText:type];
        [self hideSetting];
        
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window addSubview: _coverScreenView];
        [window addSubview:_coverTopView];
        
        
        [_circle removeAllAnimations];
        CABasicAnimation* rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotationAnimation.toValue = @(2*M_PI);//[NSNumber numberWithFloat:(2 * M_PI)];
        rotationAnimation.duration = 1.0f;
        rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        rotationAnimation.repeatCount = HUGE_VALF;
        [_circle addAnimation:rotationAnimation forKey:@"rotateAnimation"];
        
        [UIView animateWithDuration:.3 animations:^{
            [self addSetting];
        }];
        
    }
    
    
    self.timeShow = [NSTimer scheduledTimerWithTimeInterval:18.0 target:self selector:@selector(hiddenBox) userInfo:nil repeats:NO];
    
    
    _isShow = YES;
}



- (void)showShareLocationWaitingIndicatorWithoutBackground:(SharePositionIndicatorTYPE)type
{
    [self showShareLocationWaitingIndicator:type];
    _bg.hidden = YES;
    _drop_bg.hidden = YES;
}

- (void)showShareLocationWaitingIndicator:(SharePositionIndicatorTYPE)type withCancelMethod:(CustomCancel)cancel
{
    [self showShareLocationWaitingIndicator:type];
    _cancelMethod = [cancel copy];
}

-(void)showShareLocationWaitingIndicator:(SharePositionIndicatorTYPE)type
{
    [self hideWaitingIndicatorWithoutAnimation];
    
    
    if (_coverScreenView == nil) {
        
        [self initContentView];
        UILabel* searchLabel = (UILabel*)[_coverScreenView viewWithTag:32345];
        searchLabel.text = [self getShareWaitingText:type];
        [self hideSetting];
        
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window addSubview: _coverScreenView];
        [window addSubview:_coverTopView];
        
        [_circle removeAllAnimations];
        CABasicAnimation* rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotationAnimation.toValue = @(2*M_PI);//[NSNumber numberWithFloat:(2 * M_PI)];
        rotationAnimation.duration = 1.0f;
        rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        rotationAnimation.repeatCount = HUGE_VALF;
        [_circle addAnimation:rotationAnimation forKey:@"rotateAnimation"];
        [UIView animateWithDuration:.3 animations:^{
            self.bg.alpha = .3;
            self.drop_bg.alpha = 1.0;
            self.drop_bg.frame = DROP_BG_FRAME;
            _circle.hidden = NO;
            searchLabel.hidden = NO;
        }];
        
    }
    else
    {
        UILabel* searchLabel = (UILabel*)[_coverScreenView viewWithTag:32345];
        searchLabel.text = [self getShareWaitingText:type];
        [self hideSetting];
        
        UIWindow *windows = [UIApplication sharedApplication].keyWindow;
        [windows addSubview: _coverScreenView];
        [windows addSubview:_coverTopView];
        
        [_circle removeAllAnimations];
        CABasicAnimation* rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotationAnimation.toValue = @(2*M_PI);//[NSNumber numberWithFloat:(2 * M_PI)];
        rotationAnimation.duration = 1.0f;
        rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        rotationAnimation.repeatCount = HUGE_VALF;
        [_circle addAnimation:rotationAnimation forKey:@"rotateAnimation"];
        
        [UIView animateWithDuration:.3 animations:^{
            [self addSetting];
        }];
        
    }
    
    
    _isShow = YES;
}




-(bool)getWaintingIndicatorStatus
{
    
    if (nil != _coverScreenView)
    {
        return _isShow;
    }
    else
    {
        return false;
    }
    
}

-(void)hideWaitingIndicator
{
    //Note: 添加清空取消函数的功能以释放在_cancelMethod中的指针。 by biosli 2013.10.08
    _cancelMethod = nil;
    
    if (_isShow == NO) {
        
        return;
    }
    
    if (nil != _coverScreenView)
    {
        
        [UIView animateWithDuration:0.3 animations:^{
            
            [self hideSetting];
            
        } completion:^(BOOL finished) {
            [_coverScreenView removeFromSuperview];
            
            [_coverTopView removeFromSuperview];
            
            _coverTopView = nil;
            _coverScreenView = nil;
        }];
        
        
    }
    
    _isShow = NO;
    _cancelMethod = nil;
    
    
    if ([_timeShow isValid]) {
        
        [_timeShow invalidate];
    }
}

- (void)hideWaitingIndicatorWithoutAnimation
{
    if (_isShow == NO) {
        
        return;
    }
    
    if (nil != _coverScreenView)
    {
        [_coverScreenView removeFromSuperview];
        
        [_coverTopView removeFromSuperview];
        
        _coverTopView = nil;
        _coverScreenView = nil;
        
    }
    
    _isShow = NO;
    _cancelMethod = nil;
    
    
    if ([_timeShow isValid]) {
        
        [_timeShow invalidate];
    }
}

-(void)hiddenBox
{
    [self hideWaitingIndicator];
}

- (NSString *)getWaitingText:(IndicatorTYPE)type
{
    NSString *text = nil;
    switch (type) {
        case VERSION_UPDATE_WAITING_INDICATOR:
            text = NSLocalizedString(@"CheckUpdate",@"检查更新...");
            break;
        case REQ_WAITING_INDICATOR:
            text = @"正在请求";
            break;
        case LOAD_PAGE_REQ_WAITING_INDICATOR:
            text = NSLocalizedString(@"IsLoadingB",@"正在载入...");
            break;
        case SYNCDATA_REQ_WAITING_INDICATOR:
            text = NSLocalizedString(@"IsSynchronizing",@"正在同步...");
            break;
        case SUBMIT_REQ_WAITING_INDICATOR:
            text = NSLocalizedString(@"IsSubmiting",@"正在提交...");
            break;
        case SUBMIT_PORTRAIT_REQ_WAITTING_INDICATOR:
            text = @"正在上传头像";
            break;
        default:
            text = NSLocalizedString(@"IsSearching",@"正在搜索...");
            break;
    }
    return text;
}

- (NSString *)getShareWaitingText:(SharePositionIndicatorTYPE)type
{
    NSString *text = nil;
    switch (type) {
        case SHARE_POSITION_DEFAULT_REQUEST_WAITING_INDICATOR:
            text = NSLocalizedString(@"RequstSending",@"请求发送中...");
            break;
        case SHARE_POSITION_CREATING_ACTIVITY_WAITING_INDICATOR:
            text = NSLocalizedString(@"AskSending",@"邀请发送中...");
            break;
        case SHARE_POSITION_MODIFY_ACTIVITY_WAITING_INDICATOR:
            text = NSLocalizedString(@"ActivityModifying",@"活动修改中...");
            break;
        case SHARE_POSITION_MODIFY_NICKNAME_WAITING_INDICATOR:
            text = NSLocalizedString(@"NicknameChanging",@"昵称修改中...");
            break;
        case SHARE_POSITION_RESPONSE_ACTIVITY_WAITING_INDICATOR:
            text = NSLocalizedString(@"ServiceResponsing",@"服务响应中...");
            break;
        case SHARE_POSITION_DEFAULT_RESPONSE_WAITING_INDICATOR:
            text = NSLocalizedString(@"InfoLoading",@"加载信息中...");
            break;
        case SHARE_POSITION_DEFAULT_WAITING_INDICATOR:
            text = NSLocalizedString(@"LoadingA",@"载入中...");
            break;
        default:
            text = NSLocalizedString(@"LoadingA",@"载入中...");
            break;
    }
    return text;
}

- (void)initContentView
{
    UILabel* searchLabel;
    
    _coverScreenView = [[UIView alloc] initWithFrame:CGRectMake(COVERSCREEN_X,COVERSCREEN_Y, COVERSCREEN_WIDTH, COVERSCREEN_HEIGHT)];
    _coverScreenView.backgroundColor = [UIColor clearColor];
    
    self.bg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, COVERSCREEN_WIDTH, COVERSCREEN_HEIGHT)];
    self.bg.backgroundColor = [UIColor blackColor];
    self.bg.alpha = 0;
    self.bg.tag =12345;
    
//    self.drop_bg = [[UIImageView alloc]initWithFrame:DROP_BG_BIG_FRAME];
//    self.drop_bg.image = [StretchImageUtil stretchableImageWithLeftCapWidth:17 topCapHeight:17 targetImage:[UIPageNavigator loadResourceImage:@"loading_cell"]];
//    self.drop_bg.tag = 22345;
    
//    _drop = [CALayer layer];
//    _drop.frame = DROP_FRAME;
//    _drop.contentsScale = [UIScreen mainScreen].scale;
//    _drop.contents = (id)[UIPageNavigator loadResourceImage:@"loading_drop"].CGImage;
//    
//    _circle = [CALayer layer];
//    _circle.frame = DROP_FRAME;
//    _circle.contentsScale = [UIScreen mainScreen].scale;
//    _circle.contents = (id)[UIPageNavigator loadResourceImage:@"loading_circle"].CGImage;
    
    
//    _line = [CALayer layer];
//    _line.frame = LINE_FRAME;
//    _line.contentsScale = [UIScreen mainScreen].scale;
//    _line.contents = (id)[UIPageNavigator loadResourceImage:@"vertical_line"].CGImage;
    
    searchLabel = [[UILabel alloc] initWithFrame:CGRectMake((COVERSCREEN_WIDTH - WAIT_INDICATORVIEW_WIDTH)/2.0 + 5.0 + 14.0 + 25.0 + 8.0, WAIT_INDICATORVIEW_Y + WAIT_DROP_ORGIN_Y + 1.0, WAIT_INDICATORLABEL_WIDTH, WAIT_INDICATORLABEL_HEIGHT)];
    searchLabel.font = [UIFont boldSystemFontOfSize:WAIT_INDICATORLABEL_FONTSIZE];
    searchLabel.backgroundColor = [UIColor clearColor];
    searchLabel.textColor = UIColorFromRGB(0x333333);
    searchLabel.tag = 32345;
    searchLabel.textAlignment = NSTextAlignmentLeft;//NSTextAlignmentLeft
    
    
//    _cancelButton = [[BaiDubutton alloc] initWithFrame:CROSS_FRAME];
//    [_cancelButton setImage:[UIImage imageNamed:@"loadingX"] forState:UIControlStateNormal];
//    [_cancelButton setBackgroundImage:[self imageWithColor:UIColorFromRGB(0xd9d9d9) andSize:CGSizeMake(42, 42)] forState:UIControlStateHighlighted];
//    [_cancelButton addTarget:self action:@selector(performCancelMethod) forControlEvents:UIControlEventTouchUpInside];
    
    
    int topCoverX = 5;
    _coverTopView = [[UIView alloc] initWithFrame:CGRectMake(topCoverX, IPHONE_STATUS_BAR_HEIGHT,COVERSCREEN_WIDTH - topCoverX, COVERSCREEN_Y)];
    _coverTopView.backgroundColor = [UIColor clearColor];
    
    [_coverScreenView addSubview:self.bg];
    [_coverScreenView addSubview:self.drop_bg];
    [_coverScreenView.layer addSublayer: _drop];
    [_coverScreenView.layer addSublayer: _circle];
    [_coverScreenView.layer addSublayer:_line];
    
    [_coverScreenView addSubview: searchLabel];
//    [_coverScreenView addSubview:_cancelButton];
}

- (void)hideSetting
{
    UILabel* searchLabel = (UILabel*)[_coverScreenView viewWithTag:32345];
    searchLabel.hidden = YES;
    self.bg.alpha = .0;
    self.drop_bg.alpha = .0;
    self.drop_bg.frame = DROP_BG_BIG_FRAME;
    _circle.hidden = YES;
    _drop.hidden = YES;
    _line.hidden = YES;
//    _cancelButton.alpha = .0;
}

- (void)addSetting
{
    UILabel* searchLabel = (UILabel*)[_coverScreenView viewWithTag:32345];
    searchLabel.hidden = NO;
    self.bg.alpha = .3;
    self.drop_bg.alpha = 1.0;
    self.drop_bg.frame = DROP_BG_FRAME;
    _circle.hidden = NO;
    _drop.hidden = NO;
    _line.hidden = NO;
//    _cancelButton.alpha = 1.0;
}

- (UIImage *)imageWithColor:(UIColor *)color andSize:(CGSize)size
{
    UIImage *img = nil;
    @autoreleasepool {
        CGRect rect = CGRectMake(0, 0, size.width, size.height);
        UIGraphicsBeginImageContext(rect.size);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context,color.CGColor);
        CGContextFillRect(context, rect);
        img = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return img;
}

- (void)performCancelMethod
{
    if (_cancelMethod) {
        _cancelMethod();
        _cancelMethod = nil;
    }
    else {
//        [[Searcher getSearchInstance] cancelSearch];
    }
    
    [self hideWaitingIndicator];
}

@end
