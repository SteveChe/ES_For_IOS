//
//  ChangeUserImageDataParse.h
//  MyRill
//
//  Created by Siyuan Wang on 15/7/19.
//
//

#import <Foundation/Foundation.h>

@protocol ChangeUserImageDataDelegate <NSObject>

- (void)changeUserImageSuccess:(NSString *)avatar;

@end

@interface ChangeUserImageDataParse : NSObject

@property (nonatomic, weak) id<ChangeUserImageDataDelegate> delegate;

- (void)changeUseImageWithId:(NSString *)UserId
                        data:(NSData *)imageData;

@end
