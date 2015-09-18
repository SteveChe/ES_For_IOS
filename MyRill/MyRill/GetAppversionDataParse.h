//
//  GetAppversionDataParse.h
//  MyRill
//
//  Created by Steve on 15/9/18.
//
//

#import <Foundation/Foundation.h>
@protocol GetAppVersionDelegate <NSObject>
-(void)getAppVersionSucceed:(NSString*)appVersionString;
-(void)getAppVersionFailed:(NSString*)errorMessage;
@end

@interface GetAppversionDataParse : NSObject
@property (nonatomic, weak) id<GetAppVersionDelegate> delegate;
//获取APP版本
-(void)getAppVersion;
@end
