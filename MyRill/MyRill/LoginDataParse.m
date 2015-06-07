//
//  LoginDataParse.m
//  MyRill
//
//  Created by Siyuan Wang on 15/6/7.
//
//

#import "LoginDataParse.h"
#import "AFHttpTool.h"

@implementation LoginDataParse

-(void) loginWithUserName:(NSString *) userName  password:(NSString *) password
{
    [AFHttpTool loginWithUserName:userName password:password success:^(id response) {
        
        
    }
                          failure:^(NSError* err) {
                              
                          }];
}


@end
