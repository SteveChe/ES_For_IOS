//
//  ProfessionDataParse.h
//  MyRill
//
//  Created by Siyuan Wang on 15/7/6.
//
//

#import <Foundation/Foundation.h>

@protocol ProfessionDataDelegate <NSObject>

@optional
- (void)loadProfessionList:(NSArray *)list;
- (void)addProfessionSuccess;

@end

@interface ProfessionDataParse : NSObject

@property (nonatomic, weak) id<ProfessionDataDelegate> delegate;

- (void)getProfessionList;
- (void)addProfessionWithName:(NSString *)name url:(NSString *)url;
- (void)deleteProfessionWithName:(NSString *)name url:(NSString *)url;

@end
