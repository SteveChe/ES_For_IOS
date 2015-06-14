//
//  DeviceInfo.h
//  MyRill
//
//  Created by Steve on 15/6/14.
//
//

#import <Foundation/Foundation.h>
#import "UIDevice+screenType.h"
#import "BMBase.h"
// 用于统计的Button
//#import "BaiDubutton.h"

//上层ui统一使用该宏作为screen的宽度和高度
#define isPhone568 ([UIDevice currentScreenType] == UIDeviceScreenType_iPhoneRetina4Inch)

#define IPHONE_SCREEN_WIDTH      ([DeviceInfo getApplicationSize].width)
#define IPHONE_SCREEN_HEIGHT     ([DeviceInfo getApplicationSize].height + 20)
#define IPHONE_STATUS_BAR_HEIGHT 20                     //状态栏高度
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//tablevie cell的高度
#define NORMAL_CELL_HEIGHT 44.0f
#define SUBTITLE_CELL_HEIGHT 56.0f
#define PLACE_CELL_HEIGHT 90.0f
#define PLACE_CELL_MARGIN 5.0f
#define PLACE_CELL_MIN_MARGIN 5.0f
#define SPECIAL_CELL_HEIGHT 68.0f
#define kRoute_CELL_HEIGHT (50.0f)
#define kRoute_CELLSUG_Height (60.0f)

#define DEFAULT_CELL_ELEMENTS_SPACE 10.0f               //cell中控件之间的间距
#define CELL_EACH_HEIGHT_BLANK 20                       //cell中填满文字时 cell的高度与文字高度的差值
//字体 颜色 大小 linxs
#define TAG_TEXT_COLOR [UIColor blackColor]
#define TAG_NORMAL_TEXT_COLOR RGBA(102,102,102,1)
#define SECTION_TEXT_COLOR [UIColor whiteColor]         //section的文字颜色
#define DISABLE_TEXT_COLOR RGBA(178, 178, 178, 1)
#define NORMAL_TEXT_COLOR RGBA(51, 51, 51, 1)
#define SUB_TEXT_COLOR RGBA(76, 76, 76, 1)
#define PAOPAO_NORMAL_TEXT_COLOR RGBA(242, 242, 242, 1)
#define PAOPAO_SUB_TEXT_COLOR RGBA(230, 230, 230, 1)

#define NORMAL_TITLE_FONT_SIZE 16.0f                    //title
#define NORMAL_TITLE_FONT [UIFont systemFontOfSize:NORMAL_TITLE_FONT_SIZE]
#define NORMAL_SUBTITLE_FONT_SIZE 14.0f                 //address
#define NORMAL_SUBTITLE_FONT [UIFont systemFontOfSize:NORMAL_SUBTITLE_FONT_SIZE]
#define NAVIGATION_BAR_TITLE_SIZE 18.0f                 //导航栏标题字体
#define CELL_SELECT_TEXT_COLOR [UIColor whiteColor]

#define SUB_CELL_BACKGROUND_COLOR RGBA(218,218,218,1)
#define ONE_BUS_ROUTE_CELL_BACKGROUND_COLOR RGBA(245,245,245,1)
#define CELL_BORDER_COLOR RGBA (205,211,218,1)//(224, 224, 224, 1) //(217, 217, 217, 1)            //列表边线的颜色
#define CELL_SELECT_BACKGROUND_COLOR RGBA(220,224,229,1)//(229, 229, 229, 1)//RGBA(217, 230, 251, 1)  //选中的颜色
#define CELL_SELECT_BORDER_COLOR RGBA(229, 229, 229, 1)//RGBA(217, 230, 251, 1)  //选中的颜色
#define SUB_CELL_BORDER_COLOR RGBA (212, 212, 212, 1) //列表边线的颜色
#define PAOPAO_CELL_BORDER_COLOR RGBA(82, 82, 82, 1)            //列表边线的颜色
#define PAOPAO_CELL_SELECT_BACKGROUND_COLOR RGBA(82, 82, 82, 0.5)            //列表边线的颜色
#define PAOPAO_CELL_SELECT_BORDER_COLOR RGBA(82, 82, 82, 0.5)            //列表边线的颜色

#define ROUND_CELL_BACKGROUND_COLOR [UIColor whiteColor]    //圆角文字矩形的填充色
#define ROUND_CELL_DISABLE_BACKGROUND_COLOR RGBA(247, 247, 247, 1)    //圆角文字矩形的填充色
#define ROUND_CELL_DISABLE_BORDER_COLOR RGBA(229, 229, 229, 1)    //圆角文字矩形的填充色
#define ROUND_CELL_SEL_BACKGROUND_COLOR RGBA(230,230,230,1)
#define ROUND_CELL_SEL_BORDER_COLOR RGBA(172,172,172,1)
#define ROUND_CELL_SEL_BAR_BACKGROUND_COLOR RGBA(217,217,217,1) //右边button的选中色
#define WEB_TOOLBAR_SEL_BACKGROUND_COLOR RGBA(25,25,25,1) //右边button的选中色
#define ARROW_SEGMENT_BACKGROUND_COLOR RGBA(51, 51, 51, 1)
//ratingView 的大小
#define RATING_VIEW_WIDTH 64
#define RATING_VIEW_HEIGHT 12
#define RATING_NEW_WIDTH 67
#define RATING_NEW_HEIGHT 13

//headerView margin
#define HEADER_VIEW_SPACE_MARGIN 5.0f
#define HEADER_VIEW_MARGIN 10.0f                        //headerView
#define HEADER_VIEW_SEARCH_HEIGHT   34.0f               //搜索框的高度
//输入框背景颜色
#define SEARCH_AREA_BACKGROUND_COLOR RGBA(245,245,245,1)

//圆角列表相关 linxs
#define TABLE_ROUND_MARGIN 5.0f                         //圆角边框左右边距
#define TABLE_ROUND_SECTION_MARGIN 10.0f               //Section之间的宽度
#define DEFAULT_PAGE_BACKGROUND UIColorFromRGB(0xe6e6e6)  //所有的页面的背景颜色 new 志伟说要用这个……感觉不靠谱 by biosli 2013.09.05
//#define DEFAULT_PAGE_BACKGROUND RGBA(230, 233, 237, 1)  //所有的页面的背景颜色
#define DETAIL_PAGE_BACKGROUND RGBA(224, 222, 217, 1)  //DetailPage webView的背景颜色
#define DETAIL_WEBVIEW_BACKGROUND UIColorFromRGB(0xEDEDED)//RGBA(230.0f, 233.0f, 237.0f, 1) Guichuan
//section列表中section的高度
#define TABLE_CELL_SECTION_HEIGHT 20.0f

//圆角边框高度
#define ROUND_BORDER_PANEL_HEIGHT_ONE_ROW   45  //单行内容
#define ROUND_BORDER_PANEL_HEIGHT_TWO_ROWS  70  //双行内容
#define FAVORITE_BUTTON_RESPONSE_SIZE       40  //收藏按钮的响应区域大小,60
#define PAGE_ROUND_BUTTON_TITLE_FONT [UIFont systemFontOfSize:12]

//导航栏相关
#define NAVIGATION_BAR_LEFT_INTERVAL 0			//导航栏左侧到实体的间隔
#define NAVIGATION_BAR_TOP_INTERVAL 0			//导航栏上方到实体的间隔
#define NAVIGATION_BAR_HEIGHT 50//44				//导航栏高度
#define NAVIGATION_BAR_HEIGHT_NOSHADOW 50		//导航栏无阴影高度
#define NAVIGATION_BAR_SHADOW_HEIHGT 0//1			//导航栏阴影高度,实际为3，列表按照43计算
#define NAVIGATION_BAR_SHADOW_HEIHGT_TRUE 3		//导航栏阴影高度,非列表按照44计算
//导航栏按钮相关
#define NAVIGATION_BUTTON_HEIGHT 30.0f
#define NAVIGATION_BUTTON_WIDTH 48.0f
#define NAVIGATION_ARROW_BUTTON_WIDTH 52.0f
#define NAVIGATION_BAR_BUTTON_INTERVAL 10		//导航栏方角按钮标题栏左右间距，尖角左边为
#define NAVIGATION_BUTTON_MARGIN (NAVIGATION_BAR_HEIGHT_NOSHADOW - NAVIGATION_BUTTON_HEIGHT)/2
#define NAVIGATION_BAR_BUTTON_FONT_SIZE 14		//导航栏按钮标题字体大小
#define NAVIGATION_BAR_BUTTON_FONT [UIFont systemFontOfSize:NAVIGATION_BAR_BUTTON_FONT_SIZE]
#define NAVIGATION_BAR_BUTTON_FONT_COLOR RGBA(51,51,51,1.0f) //按钮颜色定义
#define NAVIGATION_BAR_BUTTON_FONT_DISABLE_COLOR RGBA(200.0f, 200.0f, 200.0f, 1)

//语音界面相关
#define VOICE_TITLE_FONT_SIZE 18.0f                    //title
#define VOICE_TITLE_FONT [UIFont systemFontOfSize:VOICE_TITLE_FONT_SIZE]
#define VOICE_BUTTON_TITLE_FONT_SIZE 20.0f                    //title
#define VOICE_BUTTON_TITLE_FONT [UIFont systemFontOfSize:VOICE_BUTTON_TITLE_FONT_SIZE]
#define VOICE_BORDER_COLOR RGBA (197, 197, 197, 1)
#define VOICE_BUTTON_NORMAL_COLOR RGBA (239, 239, 239, 1)
#define VOICE_BUTTON_SELECTED_COLOR RGBA (230, 230, 230, 1)
//设置二级页面相关
#define OPTION_LAYER_FONT_SIZE 12.0f                 //address
#define OPTION_LAYER_FONT [UIFont systemFontOfSize:OPTION_LAYER_FONT_SIZE]
#define OPTION_LAYER_FONT_COLOR RGBA(0x4C,0x4C,0x4C,1)
#define OPTION_LAYER_BUTTON_SELCOLOR RGBA(0xE6,0xE6,0xE6,1)
//toolbar 相关
#define BAR_BUTTON_WIDTH 45
#define BAR_BUTTON_HEIGHT 30
#define BAR_BUTTON_INTERVAL 1
//我的位置toolbar
#define MY_LOCATION_BUTTON_FONT [UIFont systemFontOfSize:14.0f]
#define MY_LOCATION_BUTTON_FONT_COLOR RGBA(0x7A,0x71,0x71,1)
#define MY_LOCATION_BUTTON_BGRGB     RGBA (255, 250, 242, 1)

//Segment相关
#define SEGMENT_HEIGHT 35.0f
#define SEGMENT_WIDTH 55.0f
#define SEGMENT_SEAPTOR_WIDTH 1.0f

//Predict
#define PREDICT_RECT_HEIGHT 22.0f

//页面相关
#define TABLE_FLOATING_Y 4
//地图页面相关
#define MAP_SCALE_X 10
#define MAP_SCALE_Y IPHONE_SCREEN_HEIGHT - 115   //385
#define MAP_SCALE_H 20
#define MAP_BOTTOM_Y IPHONE_SCREEN_HEIGHT - 72  //408
#define MAP_BOTTOM_H 52
#define MAP_BOTTOM_MID_X 50
#define MAP_BOTTOM_MID_W 220
#define MAP_BOTTOM_RIGHT_X 267
#define MAP_BOTTOM_SEL_H 44
//用户头像宽高
#define kBMUserInfoUserPicWidth     (90.0f)
#define kBMUserInfoUserPicHeight     (90.0f)

#define SCREEN_NO_STATUSBAR_HEIGHT  (IPHONE_SCREEN_HEIGHT - IPHONE_STATUS_BAR_HEIGHT)
#define SCREEN_NO_STATUSBAR_NO_NAVIGATIONBAR_HEIGHT  (IPHONE_SCREEN_HEIGHT - IPHONE_STATUS_BAR_HEIGHT - NAVIGATION_BAR_HEIGHT)
#define RELEASE_SAFELY(object) \
[object release]; \
object = nil;
//预加载键盘宏定义
#ifndef kCFCoreFoundationVersionNumber_iPhoneOS_3_2
#define kCFCoreFoundationVersionNumber_iPhoneOS_3_2 478.61
#endif
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_3_2
#define IF_PRE_IOS32(...) \
if(kCFCoreFoundationVersionNumber<kCFCoreFoundationVersionNumber_iPhoneOS_3_2) \
{ \
__VA_ARGS__ \
}
#else
#define IF_PRE_IOS32(...)
#endif

@interface DeviceInfo : NSObject

+ (NSString *)platform;
+ (uint) detectDevice;
+ (int) detectModel;
+ (NSString *) returnDeviceName:(BOOL)ignoreSimulator;
+ (BOOL) isIPodTouch;
+ (BOOL) isEmulator;
+ (BOOL) isOS4;
+ (bool) isRetinaScreen;
+ (NSString*) getSystemVersion;
+ (CGSize) getScreenSize;
+ (CGSize) getApplicationSize;
+ (NSString*) getChannelID;
+ (NSInteger) getSystemTime;
+ (NSString*) getSystemTimeStamp;
+ (NSString*) getSoftVersion;
+ (NSString*) getHomePath;
+ (NSString*) getDocumentsPath;
+ (NSString*) getCachePath;
+ (NSString*) getTmpPath;
/*
 * 获得系统 精确时间
 */
+ (BMTime) getSystemPreciseTime;

@end