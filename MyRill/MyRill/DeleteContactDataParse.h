//
//  DeleteContactDataParse.h
//  MyRill
//
//  Created by Steve on 15/8/20.
//
//

#import <Foundation/Foundation.h>
@protocol DeleteContactDelegate <NSObject>
-(void)deleteContactSucceed;
-(void)deleteContactFailed:(NSString*)errorMessage;

@end

@interface DeleteContactDataParse : NSObject
@property (nonatomic,weak)id<DeleteContactDelegate>delegate;

//delete Contacts
-(void) deleteContact:(NSString *)userId;


@end
