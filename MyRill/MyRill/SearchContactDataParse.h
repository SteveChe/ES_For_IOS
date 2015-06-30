//
//  SearchContactDataParse.h
//  MyRill
//
//  Created by Steve on 15/6/28.
//
//

#import <Foundation/Foundation.h>
@protocol SearchContactDelegate <NSObject>

-(void)searchContactResult:(NSArray*)contactsResult;

-(void)searchContactFailed:(NSString*)errorMessage;

@end

@interface SearchContactDataParse : NSObject

@property (nonatomic,weak)id<SearchContactDelegate>delegate;

//searchContacts
-(void) searchContacts:(NSString *)searchText;

@end
