//
//  BMBase.m
//  MyRill
//
//  Created by Steve on 15/6/14.
//
//

#import "BMBase.h"
#import "DeviceInfo.h"

BMPoint BMPointMake2(double x,double y,double z)
{
    
    BMPoint pt;
    pt.x = x;
    pt.y = y;
    pt.z = z;
    return pt;
    
}

BMPoint BMPointMake(double x,double y)
{
    BMPoint pt;
    pt.x = x;
    pt.y = y;
    return pt;
}

BOOL BMPointEqualToPoint(BMPoint point1, BMPoint point2)
{
    return (point1.x == point2.x) && (point1.y == point2.y);
}

BMRect BMRectMake(int64 left,int64 right,int64 top,int64 bottom)
{
    BMRect rt;
    rt.left = left;
    rt.right = right;
    rt.top = top;
    rt.bottom = bottom;
    return rt;
}

BOOL BMRectEqualToRect(BMRect rect1,BMRect rect2){
    return ((rect1.left==rect2.left)&&(rect1.right==rect2.right)&&(rect1.top==rect2.top)&&(rect1.bottom==rect2.bottom));
}

BOOL isZeroBMRect(BMRect rect){
    BMRect t=BMRectMake(0, 0, 0, 0);
    return BMRectEqualToRect(rect, t);
}

BMRect GetBMRect(BMQuadrangle qr)
{
    int64	minX	= qr.lb.x;
    {
        if( qr.lt.x < minX )
            minX = qr.lt.x;
        if( qr.rt.x < minX )
            minX = qr.rt.x;
        if( qr.rb.x < minX )
            minX = qr.rb.x;
    }
    
    int64	maxX	= qr.lb.x;
    {
        if( qr.lt.x > maxX )
            maxX = qr.lt.x;
        if( qr.rt.x > maxX )
            maxX = qr.rt.x;
        if( qr.rb.x > maxX )
            maxX = qr.rb.x;
    }
    int64   minY	= qr.lb.y;
    {
        if( qr.lt.y < minY )
            minY = qr.lt.y;
        if( qr.rt.y < minY )
            minY = qr.rt.y;
        if( qr.rb.y < minY )
            minY = qr.rb.y;
    }
    int64	maxY	= qr.lb.y;
    {
        if( qr.lt.y > maxY )
            maxY = qr.lt.y;
        if( qr.rt.y > maxY )
            maxY = qr.rt.y;
        if( qr.rb.y > maxY )
            maxY = qr.rb.y;
    }
    return BMRectMake( minX, maxX, maxY, minY );
};

@implementation BMGeoElement
@synthesize uid;
@synthesize index;
@synthesize text;
@synthesize pt;
@synthesize userIndex;
@synthesize tm;
@synthesize streetScapeMode;

@end


@implementation BMItsEvent
@synthesize geo = _geo;
@synthesize startTime = _startTime;
@synthesize endTime = _endTime;
@synthesize strDetail = _strDetail;
@synthesize timeStart = _timeStart;
@synthesize timeEnd = _timeEnd;

@end

@implementation BMStreetScapeEvent
@synthesize geo = _geo;
@synthesize moveDir = _moveDir;

@end