//
//  SubResPojo.h
//  MyRill
//
//  Created by Siyuan Wang on 15/9/26.
//
//

#import <Foundation/Foundation.h>

@interface SubResPojo : NSObject

@property (nonatomic, copy) NSString *subResId;     //子资源ID
@property (nonatomic, copy) NSString *resId;        //资源Id
@property (nonatomic, copy) NSString *subName;      //子资源名称
@property (nonatomic, copy) NSString *subResType;   //子资源类型名称
@property (nonatomic, assign) BOOL isManaged;       //子资源指标是否纳入监控，即是否可以根据subResId查得到子资源指标

//designed initilize
- (instancetype)initWithDic:(NSDictionary *)dic;

@end
