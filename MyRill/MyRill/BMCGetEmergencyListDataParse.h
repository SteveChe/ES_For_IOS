//
//  BMCGetEmergencyListDataParse.h
//  MyRill
//
//  Created by Siyuan Wang on 15/9/14.
//
//

#import <Foundation/Foundation.h>

@protocol BMCGetEmergencyListDelegate <NSObject>

- (void)getEmergencyListSucceed:(NSArray *)resultList;
- (void)getEmergencyeListFailed:(NSString *)errorMessage;

@end

@interface BMCGetEmergencyListDataParse : NSObject

@property (nonatomic, weak) id<BMCGetEmergencyListDelegate> delegate;

- (void)getEmergencyListWithViewType:(NSString *)viewType;

@end
