//
//  GetEnterpriseListDataParse.h
//  MyRill
//
//  Created by Steve on 15/8/3.
//
//

#import <Foundation/Foundation.h>
@protocol GetFollowedEnterpriseListDelegate <NSObject>
-(void)getFollowedEnterpriseListSucceed:(NSArray*)enterpriseList;
-(void)getFollowedEnterpriseListFailed:(NSString*)errorMessage;
@end

@protocol GetSearchEnterpriseListDelegate <NSObject>
-(void)getSearchEnterpriseListSucceed:(NSArray*)enterpriseList;
-(void)getSearchEnterpriseListFailed:(NSString*)errorMessage;
@end

@interface GetEnterpriseListDataParse : NSObject

@property (nonatomic, weak) id<GetFollowedEnterpriseListDelegate> getFollowedEnterPriseListDelegate;
@property (nonatomic, weak) id<GetSearchEnterpriseListDelegate> getSearchEnterpriseListDelegate;

/******** 获取企业联系人列表******
 请求方式：GET
 参数：无
 备注：该接口返回当前用户所有的联系人信息
 **/
-(void) getFollowedEnterpriseList;

//搜索企业联系人
-(void) searchEnterprise:(NSString*)searchText;

@end
