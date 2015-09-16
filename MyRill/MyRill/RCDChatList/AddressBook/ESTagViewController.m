//
//  ESTagViewController.m
//  MyRill
//
//  Created by Steve on 15/7/28.
//
//

#import "ESTagViewController.h"
#import "DeviceInfo.h"
#import "ESTag.h"
#import "TagDataParse.h"
#import "CustomShowMessage.h"

#define PICKER_FIRST_COLUME_WIDTH 200
//#define PICKER_SECOND_COLUME_WIDTH 100
//#define PICKER_THIRD_COLUME_WIDTH 80
#define PICKER_VIEW_ITEM_HEIGHT 40
#define PICKER_VIEW_Y IPHONE_SCREEN_HEIGHT - 236.0f
#define PICKER_VIEW_HEIGHT 216.0

enum
{
    TAG_PICKER_INDEX_FIRST = 0,
    TAG_PICKER_INDEX_COUNT,
};


@interface ESTagViewController ()<TagDataDelegate,UIPickerViewDelegate, UIPickerViewDataSource,UIActionSheetDelegate>
@property(nonatomic,strong) UIPickerView* pickerView;
@property(nonatomic,strong) NSMutableArray* tagListArray;
@property(nonatomic,strong) TagDataParse* tagDataParse;
@property(nonatomic,assign) NSInteger selectedTableViewSection;
@property(nonatomic,strong) UIToolbar *pickerTagToolbar;
//@property(nonatomic,strong) UIView* myPickView;
@end

@implementation ESTagViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"扩展属性";
    _tagDataParse = [[TagDataParse alloc] init];
    _tagDataParse.delegate = self;
    _tagListArray = [[NSMutableArray alloc] init];
    [self initTagInfo];
    
//    if (_myPickView == nil)
    {
//        _myPickView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 300)];
        
        //创建picker
        if (_pickerView == nil)
        {
            _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0.0, PICKER_VIEW_Y, IPHONE_SCREEN_WIDTH, PICKER_VIEW_HEIGHT)];
            //        _pickerView.backgroundColor = [UIColor blackColor];
            _pickerView.showsSelectionIndicator = true;
            _pickerView.delegate = self;
            _pickerView.dataSource = self;
            _pickerView.backgroundColor = [UIColor grayColor];
            _pickerView.hidden = YES;
            _pickerView.tintColor = [UIColor whiteColor];
            _pickerView.layer.borderColor = [UIColor whiteColor].CGColor;
            
            [self.view addSubview:_pickerView];

        }
        if (_pickerTagToolbar == nil)
        {
            _pickerTagToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, PICKER_VIEW_Y-44, IPHONE_SCREEN_WIDTH, 44)];
            _pickerTagToolbar.barStyle = UIBarStyleDefault;
            [_pickerTagToolbar sizeToFit];
            
            NSMutableArray *barItems = [[NSMutableArray alloc] init];
            UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:self action:@selector(toolBarCancelClick)];
            [barItems addObject:cancelBtn];
            
            UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
            [barItems addObject:flexSpace];
            
            UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(toolBarDoneClick)];
            [barItems addObject:doneBtn];
            
            [_pickerTagToolbar setItems:barItems animated:YES];
            _pickerTagToolbar.hidden = YES;
            [self.view addSubview:_pickerTagToolbar];
            
        }
    }

    

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
-(void)initTagInfo
{
    switch (_tagType) {
        case TAG_TYPE_USER:
        {
            if (_userId != nil && [_userId length] > 0)
            {
                [_tagDataParse getUserTag:_userId];
            }
        }
            break;
        case TAG_TYPE_ENTERPRISE:
        {
            if (_enterpriseId != nil && [_enterpriseId length]>0)
            {
                [_tagDataParse getEnterpriseTag:_enterpriseId];
            }
        }
            break;
            
        case TAG_TYPE_ASSIGNMENT:
        {
            if (_taskId != nil && [_taskId length]>0 )
            {
                [_tagDataParse getTaskTag:_taskId];
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark UIPickerViewDelegate
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [self.tableView reloadData];
}

#pragma mark UIPickerViewDataSource

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *returnStr = @"";
    if ([_tagListArray count]<= 0)
    {
        return returnStr;
    }
    if (pickerView == _pickerView)
    {
        if (TAG_PICKER_INDEX_FIRST == component)
        {
            
            ESTag *tag = [_tagListArray objectAtIndex:_selectedTableViewSection];
            if (tag == nil || tag.tagItemList == nil )
            {
                return returnStr;
            }
            else
            {
                ESTagItem * tagItem = [tag.tagItemList objectAtIndex:row];
                return tagItem.tagItemName;
            }
        }
    }
    
    return returnStr;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    CGFloat componentWidth = 0.0;
    
    if (TAG_PICKER_INDEX_FIRST == component)
    {
        componentWidth = PICKER_FIRST_COLUME_WIDTH;
    }
    return componentWidth;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return PICKER_VIEW_ITEM_HEIGHT;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if ([_tagListArray count]<=0)
    {
        return 0;
    }
    if (TAG_PICKER_INDEX_FIRST == component)
    {
        ESTag *tag = [_tagListArray objectAtIndex:_selectedTableViewSection];
        if (tag == nil || tag.tagItemList == nil )
        {
            return 0;
        }
        return [tag.tagItemList count];
    }
    return 0;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return TAG_PICKER_INDEX_COUNT;
}


- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        // Setup label properties - frame, font, colors etc
        //adjustsFontSizeToFitWidth property to YES
        //        pickerLabel.minimumFontSize = 8.;
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        pickerLabel.textColor = [UIColor whiteColor];
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:25]];
    }
    // Fill the label text here
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}


#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return [_tagListArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section >= [_tagListArray count])
    {
        return nil;
    }
    ESTag* tag = [_tagListArray objectAtIndex:section];
    if (tag == nil)
    {
        return nil;
    }
    return tag.tagName;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"EsTagViewCellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:MyIdentifier];
    }
    
    if (indexPath.section > [_tagListArray count])
    {
        return nil;
    }
    
    ESTag* tag = [_tagListArray objectAtIndex:indexPath.section];
    if (tag == nil)
    {
        return nil;
    }
    
    cell.textLabel.text = tag.tagName;
    if (tag.selectedTagItemId == nil || [tag.selectedTagItemId isEqual:[NSNull null]] )
    {
        ESTagItem *item = [tag.tagItemList objectAtIndex:0];
        if (item!=nil)
        {
            cell.detailTextLabel.text = item.tagItemName;
        }
    }
    else
    {
        for (ESTagItem* item in tag.tagItemList)
        {
            if ([item.tagItemId isEqualToString:tag.selectedTagItemId])
            {
                cell.detailTextLabel.text = item.tagItemName;
                break;
            }
        }
    }
    
    if(tag.bIs_locked)
        cell.userInteractionEnabled = NO;
    else
        cell.userInteractionEnabled = YES;
        
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view bringSubviewToFront:_pickerView];
    [self.view bringSubviewToFront:_pickerTagToolbar];
    
    _pickerView.hidden = NO;
    _pickerTagToolbar.hidden = NO;
    _selectedTableViewSection = indexPath.section;
    [_pickerView reloadAllComponents];
}

#pragma mark --TagDataDelegate
- (void)getTag:(NSMutableArray *)tagInfoArray
{
    [_tagListArray removeAllObjects];
    [_tagListArray addObjectsFromArray:tagInfoArray];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            
        });
    });

    
}
- (void)getTagFailed:(NSString*)errorMessage
{
    [[CustomShowMessage getInstance] showNotificationMessage:errorMessage];
}

- (void)setTagSucceed:(NSMutableArray *)tagInfoArray
{
    _pickerTagToolbar.hidden = YES;
    _pickerView.hidden = YES;
    [[CustomShowMessage getInstance] hideWaitingIndicator];

    [[CustomShowMessage getInstance] showNotificationMessage:@"标签设定成功!"];
    
    [_tagListArray removeAllObjects];
    [_tagListArray addObjectsFromArray:tagInfoArray];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            
        });
    });
}
- (void)setTagFailed:(NSString*)errorMessage
{
    [[CustomShowMessage getInstance] hideWaitingIndicator];
    [[CustomShowMessage getInstance] showNotificationMessage:errorMessage];
}

#pragma mark - button event
-(void) toolBarCancelClick
{
    _pickerTagToolbar.hidden = YES;
    _pickerView.hidden = YES;
}

-(void)toolBarDoneClick
{
    ESTag *tag = [_tagListArray objectAtIndex:_selectedTableViewSection];
    if (tag == nil || tag.tagItemList == nil )
    {
        return;
    }

    NSInteger nSelectedIndex = [_pickerView selectedRowInComponent:TAG_PICKER_INDEX_FIRST];
//    [_pickerView selectedRowInComponent:TAG_PICKER_INDEX_FIRST];
    if (nSelectedIndex >= [tag.tagItemList count])
    {
        return;
    }
    
    ESTagItem* tagItem = [tag.tagItemList objectAtIndex:nSelectedIndex];
    if (tagItem == nil)
    {
        return;
    }
    tag.selectedTagItemId = tagItem.tagItemId;
    
    NSMutableDictionary* tagParamsDic = [NSMutableDictionary dictionary];
    for (ESTag *tag in _tagListArray)
    {
        NSString* strKey = [NSString stringWithFormat:@"attr_%@",tag.tagId];
        if (tag.selectedTagItemId != nil )
        {
            [tagParamsDic setObject:tag.selectedTagItemId forKey:strKey];
        }
    }
    
    switch (_tagType) {
        case TAG_TYPE_USER:
        {
            [_tagDataParse setUserTag:_userId TagParams:tagParamsDic];
            [[CustomShowMessage getInstance] showWaitingIndicator:REQ_WAITING_INDICATOR];
        }
            break;
        case TAG_TYPE_ENTERPRISE:
        {
            [_tagDataParse setEnterpriseTag:_enterpriseId TagParam:tagParamsDic];
            [[CustomShowMessage getInstance] showWaitingIndicator:REQ_WAITING_INDICATOR];
        }
            break;
            
        case TAG_TYPE_ASSIGNMENT:
        {
//            [_tagDataParse setTaskTag:_taskId TagId:tag.tagId tagItemId:tagItem.tagItemId];
            [_tagDataParse setTaskTag:_taskId TagParam:tagParamsDic];
            [[CustomShowMessage getInstance] showWaitingIndicator:REQ_WAITING_INDICATOR];
        }
            break;
        default:
            break;
    }
}
@end
