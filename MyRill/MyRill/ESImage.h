//
//  ESImage.h
//  MyRill
//
//  Created by Siyuan Wang on 15/9/1.
//
//

#import <Foundation/Foundation.h>

@interface ESImage : NSObject

@property (nonatomic, strong) NSNumber *imageID;
@property (nonatomic, copy) NSString *imgURL;
@property (nonatomic, copy) NSString *imgUserID;

- (instancetype)initWithDic:(NSDictionary *)dic;

@end
