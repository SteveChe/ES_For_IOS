//
//  ChangeUserImageDataParse.h
//  MyRill
//
//  Created by Siyuan Wang on 15/7/19.
//
//

#import <Foundation/Foundation.h>

@interface ChangeUserImageDataParse : NSObject

- (void)changeUseImageWithId:(NSString *)UserId
                        data:(NSData *)imageData;

@end
