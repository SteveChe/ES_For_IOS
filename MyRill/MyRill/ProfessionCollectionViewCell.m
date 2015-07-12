//
//  ProfessionCollectionViewCell.m
//  MyRill
//
//  Created by Siyuan Wang on 15/7/8.
//
//

#import "ProfessionCollectionViewCell.h"

@interface ProfessionCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;

@end

@implementation ProfessionCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)updateCellData:(NSString *)title {
    self.titleLbl.text = title;
    NSURL *url = [NSURL URLWithString:@"http://g.soz.im/http://sina.com.cn?defaulticon=http://soz.im/favicon.ico"];
    NSData *data = [NSData dataWithContentsOfURL:url];
    self.icon.image = [UIImage imageWithData:data];
    
}

@end
