//
//  ProfessionWebViewController.h
//  MyRill
//
//  Created by Siyuan Wang on 15/7/16.
//
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    ESWebProfessionWithID = 400,
    ESWebProfessionWithURL
} ESWebProfessionType;

@interface ProfessionWebViewController : UIViewController

//必须设置的字段
@property (nonatomic, assign) ESWebProfessionType type;
//type为ESWebProfessionWithID必须设置的字段
@property (nonatomic, copy) NSString *professionID;
//type为ESWebProfessionWithURL必须设置的字段
@property (nonatomic, copy) NSString *urlString;

@end
