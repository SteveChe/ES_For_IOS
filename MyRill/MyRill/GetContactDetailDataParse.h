//
//  GetContactDetailDataParse.h
//  MyRill
//
//  Created by Steve on 15/7/15.
//
//

#import <Foundation/Foundation.h>
@class ESUserDetailInfo;
@protocol ContactDetailDataDelegate <NSObject>

- (void)getContactDetail:(ESUserDetailInfo *)userDetailInfo;
- (void)getContactDetailFailed:(NSString*)errorMessage;

@end

@interface GetContactDetailDataParse : NSObject

@property (nonatomic, weak) id<ContactDetailDataDelegate> delegate;

//获取联系人的详细信息
-(void) getContactDetail:(NSString*)userID ;

@end
