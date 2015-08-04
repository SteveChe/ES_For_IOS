//
//  FollowEnterpriseDataParse.h
//  MyRill
//
//  Created by Steve on 15/8/3.
//
//

#import <Foundation/Foundation.h>


@protocol FollowEnterpriseDelegate <NSObject>
-(void)followEnterpriseSucceed;
-(void)followEnterpriseFailed:(NSString*)errorMessage;
@end

@protocol UnFollowEnterpriseDelegate <NSObject>
-(void)unFollowEnterpriseSucceed;
-(void)unFollowEnterpriseFailed:(NSString*)errorMessage;
@end


@interface FollowEnterpriseDataParse : NSObject
@property (nonatomic, weak) id<FollowEnterpriseDelegate> followEnterPriseDelegate;
@property (nonatomic, weak) id<UnFollowEnterpriseDelegate> unfollowEnterPriseDelegate;

-(void)followEnterPriseWithEnterpriseId:(NSString*)enterpriseId;
-(void)unfollowEnterPriseWithEnterpriseId:(NSString*)enterpriseId;
@end
