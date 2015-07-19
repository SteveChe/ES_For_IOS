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
#import "ProfessionDataParse.h"

@interface ModifyProfessionViewController () <ProfessionDataDelegate>

@property (weak, nonatomic) IBOutlet UIView *popOverView;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *holdViews;
@property (weak, nonatomic) IBOutlet UITextField *nameTxtField;
@property (weak, nonatomic) IBOutlet UITextField *urlTxtField;
@property (nonatomic, strong) ProfessionDataParse *professionDP;
@property (nonatomic, strong) ESProfession *profession;

@end

@implementation ModifyProfessionViewController

#pragma mark - lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.view addGestureRecognizer:tapGesture];
}

#pragma mark - ProfessionDataDelegate methods
- (void)professionOperationSuccess:(id)context {
    [self.delegate modifyProfessionSuccess:(ESProfession *)context];
    [self dismissBtn:nil];
    
}

#pragma mark - response events
- (IBAction)dismissBtn:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)saveBtn:(UIButton *)sender {
    [self.professionDP updateProfessionWithId:[self.profession.professionId stringValue]
                                         name:self.nameTxtField.text
                                          url:self.urlTxtField.text];
}

- (void)hideKeyboard {
    [self.nameTxtField resignFirstResponder];
    [self.urlTxtField resignFirstResponder];
}

#pragma mark - private methods
- (void)loadProfessionData:(ESProfession *)profession {
    self.profession = nil;
    self.profession = profession;
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

- (ProfessionDataParse *)professionDP {
    if (!_professionDP) {
        _professionDP = [[ProfessionDataParse alloc] init];
        _professionDP.delegate = self;
    }
    return _professionDP;
}

@end
