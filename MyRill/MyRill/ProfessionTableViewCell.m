//
//  ProfessionTableViewCell.m
//  MyRill
//
//  Created by Siyuan Wang on 15/7/12.
//
//

#import "ProfessionTableViewCell.h"
#import "Masonry.h"
#import "ESProfession.h"

@interface ProfessionTableViewCell ()

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *titleLbl;

@end

@implementation ProfessionTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        //[self addSubview:self.imgView];
        [self addSubview:self.titleLbl];
        
        __weak UIView *ws = self;
        
//        [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.leading.equalTo(ws.mas_leading).with.offset(20);
//            make.centerY.equalTo(ws.mas_centerY);
//        }];
        
        //[self layoutIfNeeded];
        
        //__weak UIImageView *wi = self.imgView;
//        [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.leading.equalTo(ws.mas_leading).with.offset(70);
//            make.centerY.equalTo(ws.mas_centerY);
//        }];
        
    }
    
    return self;
}

#pragma mark - private mothods
- (void)updateProfessionCell:(ESProfession *)profession {
    self.titleLbl.text = profession.name;
    self.imageView.image = [UIImage imageNamed:@"icon.png"];
    [self.imageView sizeToFit];
    
    [self layoutIfNeeded];
}

#pragma mark - setters&getters
- (UIImageView *)imageView {
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
        _imgView.image = [UIImage imageNamed:@"icon.png"];
        [_imgView sizeToFit];
    }
    
    return _imgView;
}

- (UILabel *)titleLbl {
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 80, 30)];
        _titleLbl.textColor = [UIColor redColor];
    }
    
    return _titleLbl;
}

@end
