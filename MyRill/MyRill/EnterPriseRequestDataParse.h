//
//  EnterPriseRequestDataParse.h
//  MyRill
//
//  Created by Steve on 15/8/1.
//
//

#import <Foundation/Foundation.h>

@protocol RequestJoinEnterPriseRequestDelegate <NSObject>
-(void)requestJoinEnterPriseSucceed;
-(void)requestJoinEnterPriseFailed:(NSString*)errorMessage;
@end

@protocol GetEnterPriseRequestListDelegate <NSObject>
-(void)getEnterPriseRequestListSucceed:(NSArray*)requestList;
-(void)getEnterPriseRequestListFailed:(NSString*)errorMessage;
@end

@protocol ApprovedEnterPriseRequestDelegate <NSObject>
-(void)approvedEnterPriseRequestSucceed;
-(void)approvedEnterPriseRequestFailed:(NSString*)errorMessage;
@end

@interface EnterPriseRequestDataParse : NSObject
@property (nonatomic, weak) id<RequestJoinEnterPriseRequestDelegate> joinEnterPriseDelegate;
@property (nonatomic, weak) id<GetEnterPriseRequestListDelegate> getEnterPriseRequestListDelegate;
@property (nonatomic, weak) id<ApprovedEnterPriseRequestDelegate> approvedEnterPriseRequestDelegate;


-(void)requestJoinEnterPriseWithUserId:(NSString*)userId;
-(void)getEnterPriseRequestList;
-(void)approvedEnterPriseRequest:(NSString*)requestId bApproved:(BOOL)bApproved ;

@end
