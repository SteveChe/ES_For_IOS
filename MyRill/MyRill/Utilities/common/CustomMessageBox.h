//
//  CustomMessageBox.h
//  MyRill
//
//  Created by Steve on 15/6/14.
//
//

#import <UIKit/UIKit.h>

@interface CustomMessageBox : UIView
{
    UIImageView *   m_bgImage;
    UILabel     *   m_messageTitle;
}

@property (nonatomic, strong) UIImageView  * bgImage;
@property (nonatomic, strong) UILabel * messageTitle;


- (void)setMessageTitle:(NSString *)messageTitle andBackgroundImg:(NSString *) imageName;
- (void)showMessage:(NSTimeInterval)duration;
@end

/*
 * 第一次出现指南针：“再次点击进入罗盘模式”
 * 第一次进入地图定位成功：“点击恢复到2D正北模式”
 策略:
 1.如果用户不点击，十秒钟退出
 2.如果用户点击，立刻退出
 */
typedef enum
{
    E_TIP_ARROW_UP = 0,
    E_TIP_ARROW_DOWN
} TipType;

@interface CustomMessageTip : UIView
{
    UIImageView *   m_bgImage;
    UILabel     *   m_messageTitle;
    
    CGFloat         m_arrowHeight;      //箭头的高度
    CGPoint         m_startPoint;
}

@property (nonatomic, strong) UIImageView  * bgImage;

//- (void)setMessageTitle:(NSString *)messageTitle andType:(TipType)arrowTip;
- (void)showMessage:(NSTimeInterval)duration;
@end