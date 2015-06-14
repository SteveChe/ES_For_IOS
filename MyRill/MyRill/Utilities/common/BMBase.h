//
//  BMBase.h
//  MyRill
//
//  Created by Steve on 15/6/14.
//
//

#ifndef _BM_BASE_H_
#define _BM_BASE_H_

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

typedef long long  int64;

//point define
struct BMPoint
{
    //    int64 x;
    //    int64 y;
    //  linxs
    double x;
    double y;
    double z;
};
typedef struct BMPoint BMPoint;

//rect define
struct BMRect
{
    int64 left;
    int64 right;
    int64 top;
    int64 bottom;
};
typedef struct BMRect BMRect;

//Quadrangle define
struct BMQuadrangle
{
    BMPoint	lb;
    BMPoint	lt;
    BMPoint  rt;
    BMPoint	rb;
};
typedef struct BMQuadrangle BMQuadrangle;

//地图状态结构信息
struct BMMapStatus
{
    CGFloat       fLevel;       // 比例尺，3－19级
    CGFloat       fRotation;    // 旋转角度
    CGFloat       fOverlooking; // 俯视角度
    BMPoint       ptCenter;     // 地图中心点
    BMQuadrangle  mapRound;     // 屏幕范围 屏幕地理坐标,注意：用户不需要更改此值
    BMRect        winRound;     // 屏幕范围 屏幕坐标,注意：用户不需要更改此值
    BMPoint       ptOffset;     // 偏移量
    
    //因为街景显示Android精度不够等原因,添加此字段 后续可能会删掉,此项不甚合理
    char          statusID[64]; // panoid
};
typedef struct BMMapStatus BMMapStatus;




//地图状态结构信息
struct BMTime
{
    NSInteger    year;
    NSInteger    month;
    NSInteger    day;
    NSInteger    hour;
    NSInteger    minute;
    NSInteger    second;
};
typedef struct BMTime BMTime;


/**
 *	构造BMPoint
 *		@param	[in]	x	x信息
 *		@param	[in]	y	y信息
 *
 *		@return	成功返回qr转换后的BMRect
 */
//linxs
//CG_EXTERN BMPoint BMPointMake(int64 x,int64 y);
CG_EXTERN BMPoint BMPointMake2(double x,double y,double z);
CG_EXTERN BMPoint BMPointMake(double x,double y);
CG_EXTERN BOOL BMPointEqualToPoint(BMPoint point1, BMPoint point2);
/**
 *	构造BMRect
 *		@param	[in]	left	left信息
 *		@param	[in]	right	right信息
 *		@param	[in]	top     top信息
 *		@param	[in]	bottom	bottom信息
 *
 *		@return	成功返回qr转换后的BMRect
 */
CG_EXTERN BMRect BMRectMake(int64 left,int64 right,int64 top,int64 bottom);

/**
 *	BMQuadrangle转换成BMRect
 *		@param	[in]	qr		输入的BMQuadrangle
 *
 *		@return	成功返回qr转换后的BMRect
 */
CG_EXTERN BMRect GetBMRect(BMQuadrangle qr);

CG_EXTERN BOOL BMRectEqualToRect(BMRect rect1,BMRect rect2);
CG_EXTERN BOOL isZeroBMRect(BMRect rect);


//点击地图标注返回数据结构
@interface BMGeoElement : NSObject
{
    NSString*       uid;    // 数字，表示唯一标识
    int             index;  // 显示自驾或步行时，标识此点在Kps[]中的索引
    
    NSString*		text;	// 例:”百度大厦”; 标注文本
    BMPoint			pt;		// 地理坐标
}
@property (nonatomic,retain) NSString* uid;
@property (nonatomic,assign) int index;
@property (nonatomic,retain) NSString* text;
@property (nonatomic,assign) BMPoint pt;
@property (nonatomic,assign) int userIndex;
@property (nonatomic,assign) unsigned int tm;
@property (nonatomic,assign) int statusIndex;
@property (nonatomic,retain) NSString *streetScapeMode;//街景模式: 日景 或 夜景
@property (nonatomic,retain) NSString* poiname;         //POI名称，街景使用
@property (nonatomic,retain) NSString* poiaddress;      //POI地址，街景使用
@property (nonatomic,retain) NSString* poiindoorid;     //POI Id，街景使用
@property (nonatomic,assign) NSInteger streetScapeX;        //点击箭头的地图位置
@property (nonatomic,assign) NSInteger streetScapeY;        //点击箭头的地图位置
@property (nonatomic,assign) NSInteger streetScapeZ;        //点击箭头的地图位置
@property (nonatomic,assign) float     streetScapeRotation; //点击箭头时的旋转方向
@property (nonatomic,retain) NSString* poiuid;
@property (nonatomic,retain) NSString* streetPid;       //获取的street id通过getNearbyObj获得,为了setMapstatus使用
//@property ()

@end

//点击路况事件返回数据结构
@interface BMItsEvent : NSObject
{
}
@property (nonatomic,retain) BMGeoElement*  geo;
@property (nonatomic,assign) struct tm*     startTime;
@property (nonatomic,assign) struct tm*     endTime;
@property (nonatomic,retain) NSString*      strDetail;
@property (nonatomic,assign) unsigned long     timeStart;
@property (nonatomic,assign) unsigned long     timeEnd;

@end



//点击街景事件返回数据结构
@interface BMStreetScapeEvent : NSObject
{
}
@property (nonatomic,retain) BMGeoElement*  geo;
@property (nonatomic,assign) float      moveDir;

@end

#endif//_BM_BASE_H_