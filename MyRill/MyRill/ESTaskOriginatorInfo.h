//
//  ESTaskOriginatorInfo.h
//  MyRill
//
//  Created by Siyuan Wang on 15/7/27.
//
//

#import <Foundation/Foundation.h>

@interface ESTaskOriginatorInfo : NSObject

@property (nonatomic, strong) NSNumber *initiatorId;
@property (nonatomic, copy) NSString *initiatorName;
@property (nonatomic, copy) NSString *initiatorImgURL;
@property (nonatomic, strong) NSNumber *assignmentNum;
@property (nonatomic, assign) BOOL isUpdate;

@end
