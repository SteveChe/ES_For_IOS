//
//  ModifyProfessionViewController.m
//  MyRill
//
//  Created by Siyuan Wang on 15/7/13.
//
//

#import "ModifyProfessionViewController.h"
#import "ColorHandler.h"
#import "ESProfession.h"

@interface ModifyProfessionViewController ()

@property (weak, nonatomic) IBOutlet UIView *popOverView;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *holdViews;
@property (weak, nonatomic) IBOutlet UITextField *nameTxtField;
@property (weak, nonatomic) IBOutlet UITextField *urlTxtField;

@end

@implementation ModifyProfessionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private methods
- (void)loadProfessionData:(ESProfession *)profession {
    self.nameTxtField.text = profession.name;
    self.urlTxtField.text = profession.url;
}

#pragma mark - setters&getters
- (void)setPopOverView:(UIView *)popOverView {
    _popOverView = popOverView;
    
    _popOverView.layer.cornerRadius = 7.f;
}

- (void)setHoldViews:(NSArray *)holdViews {
    _holdViews = holdViews;
    
    for (UIView *view in _holdViews) {
        view.layer.borderWidth = 1.f;
        view.layer.borderColor = [ColorHandler colorFromHexRGB:@"DDDDDD"].CGColor;
        view.layer.cornerRadius = 3.f;
    }
}

@end
