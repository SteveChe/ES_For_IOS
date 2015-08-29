//
//  ESPushManager.h
//  MyRill
//
//  Created by Steve on 15/8/29.
//
//

#import <Foundation/Foundation.h>


@interface ESPushManager : NSObject

+(void)parsePushJsonDic:(NSDictionary*)pushDic;
@end
