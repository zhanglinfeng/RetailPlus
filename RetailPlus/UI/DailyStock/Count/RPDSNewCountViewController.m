//
//  RPDSNewCountViewController.m
//  RetailPlus
//
//  Created by lin dong on 14-7-4.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//
#import "RPBlockUIAlertView.h"
#import "RPDSNewCountViewController.h"
#import "RPCountMarkCell.h"
#import "SVProgressHUD.h"

extern NSBundle * g_bundleResorce;
@interface RPDSNewCountViewController ()
@property (nonatomic, strong) AutocompletionTableView *autoCompleter;
@end

@implementation RPDSNewCountViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [_tfMark1 addTarget:self.autoCompleter action:@selector(textFieldEditDidBegin:) forControlEvents:UIControlEventEditingDidBegin];
    
    [_tfMark1 addTarget:self.autoCompleter action:@selector(textFieldEditDidEnd:) forControlEvents:UIControlEventEditingDidEnd];
    
    [_tfMark1 addTarget:self.autoCompleter action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
    
    [_tfMark2 addTarget:self.autoCompleter action:@selector(textFieldEditDidBegin:) forControlEvents:UIControlEventEditingDidBegin];
    
    [_tfMark2 addTarget:self.autoCompleter action:@selector(textFieldEditDidEnd:) forControlEvents:UIControlEventEditingDidEnd];
    
    [_tfMark2 addTarget:self.autoCompleter action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
    
    [_tfMark3 addTarget:self.autoCompleter action:@selector(textFieldEditDidBegin:) forControlEvents:UIControlEventEditingDidBegin];
    
    [_tfMark3 addTarget:self.autoCompleter action:@selector(textFieldEditDidEnd:) forControlEvents:UIControlEventEditingDidEnd];
    
    [_tfMark3 addTarget:self.autoCompleter action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(locationTapped:)];
    [self.view addGestureRecognizer:tap];
    tap.cancelsTouchesInView=NO;//为yes只响应优先级最高的事件，Button高于手势，textfield高于手势，textview高于手势，手势高于tableview。为no同时都响应，默认为yes
    [self loadTag];
}
- (void)locationTapped:(UITapGestureRecognizer *)tap
{
    [_autoCompleter hideOptionsView];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(AutocompletionTableView*)autoCompleter
{
    if (!_autoCompleter)
    {
        NSMutableDictionary *options = [NSMutableDictionary dictionaryWithCapacity:2];
        [options setValue:[NSNumber numberWithBool:YES] forKey:ACOCaseSensitive];
        [options setValue:nil forKey:ACOUseSourceFont];
        
        //计算套在输入框相对主视图的位置大小
        CGPoint p=[_viewCurrentMark convertPoint:_tfMark1.frame.origin toView:self.view];
        CGRect rect=CGRectMake(p.x, p.y, _tfMark1.frame.size.width, _tfMark1.frame.size.height);
        _autoCompleter = [[AutocompletionTableView alloc] initWithTextField:_tfMark1 inViewController:self.view withOptions:options frame:rect];
        _autoCompleter.type =AutoRemaindType_CountTag;
    }
    return _autoCompleter;
}
-(void)OnActive
{
    _viewFrame.layer.cornerRadius=10;
    _viewCount.layer.cornerRadius=5;
    _viewCount.layer.borderColor=[UIColor colorWithWhite:0.7 alpha:1].CGColor;
    _viewCount.layer.borderWidth=1;
    _btBlanket.layer.cornerRadius=4;
    
    _viewMark.frame=CGRectMake(_viewMark.frame.origin.x, -_viewMark.frame.size.height, _viewMark.frame.size.width, _viewMark.frame.size.height);
    
    _vcCount= [[RPCountViewController alloc] initWithNibName:NSStringFromClass([RPCountViewController class]) bundle:g_bundleResorce];
    
    
}
-(void)showDefaultTag
{
    for (FavTagList *favtag in _arrayTag)
    {
        if (favtag.isLast)
        {
            _tfMark1.text=((RPDSTag *)[favtag.arrayTag objectAtIndex:0]).strTagName;
            _tfMark2.text=((RPDSTag *)[favtag.arrayTag objectAtIndex:1]).strTagName;
            _tfMark3.text=((RPDSTag *)[favtag.arrayTag objectAtIndex:2]).strTagName;
            return;
        }
    }
    _tfMark1.text=NSLocalizedStringFromTableInBundle(@"Area A",@"RPString", g_bundleResorce,nil);
}

-(void)loadTag
{
    [[RPSDK defaultInstance]GetTagList:_storeSelected.strStoreId Success:^(NSMutableArray * arrayResult) {
        _arrayTag=arrayResult;
        [self showDefaultTag];
        [_tbMark reloadData];
    } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
        
    }];
}
-(void)OnNavBack
{
    [self.view endEditing:YES];
    [self.delegateNewCount endCount];
    if (!_bModify)
    {
        [self DoNavBack];
    }
    else
    {
        NSString * strDesc = NSLocalizedStringFromTableInBundle(@"Confirm to exit?",@"RPString", g_bundleResorce,nil);
        NSString * strOK = NSLocalizedStringFromTableInBundle(@"OK",@"RPString", g_bundleResorce,nil);
        NSString * strCancel = NSLocalizedStringFromTableInBundle(@"CANCEL",@"RPString", g_bundleResorce,nil);
        
        RPBlockUIAlertView *alertView = [[RPBlockUIAlertView alloc] initWithTitle:nil message:strDesc cancelButtonTitle:strCancel clickButton:^(NSInteger indexButton){
            if (indexButton == 1) {
                [self DoNavBack];
            }
        } otherButtonTitles:strOK,nil];
        [alertView show];
        
    }
    
}

-(IBAction)OnQuit:(id)sender
{
    [self.view endEditing:YES];
    NSString * strDesc = NSLocalizedStringFromTableInBundle(@"Confirm to exit?",@"RPString", g_bundleResorce,nil);
    NSString * strOK = NSLocalizedStringFromTableInBundle(@"OK",@"RPString", g_bundleResorce,nil);
    NSString * strCancel = NSLocalizedStringFromTableInBundle(@"CANCEL",@"RPString", g_bundleResorce,nil);
    
    RPBlockUIAlertView *alertView = [[RPBlockUIAlertView alloc] initWithTitle:nil message:strDesc cancelButtonTitle:strCancel clickButton:^(NSInteger indexButton){
        if (indexButton == 1) {
            [self DoQuit];
        }
    } otherButtonTitles:strOK,nil];
    [alertView show];
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FavTagList *favTagList=[_arrayTag objectAtIndex:indexPath.row];
    _tfMark1.text=((RPDSTag *)[favTagList.arrayTag objectAtIndex:0]).strTagName;
    _tfMark2.text=((RPDSTag *)[favTagList.arrayTag objectAtIndex:1]).strTagName;
    _tfMark3.text=((RPDSTag *)[favTagList.arrayTag objectAtIndex:2]).strTagName;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 52;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _arrayTag.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RPCountMarkCell *cell=[tableView dequeueReusableCellWithIdentifier:@"RPCountMarkCell"];
    if (cell==nil)
    {
        NSArray *arrayNib=[[NSBundle mainBundle]loadNibNamed:@"RPCountMarkCell" owner:self options:nil];
        cell=[arrayNib objectAtIndex:0];
    }
    cell.favTagList=[_arrayTag objectAtIndex:indexPath.row];
    return cell;
}
-(IBAction)OnClear:(id)sender
{
    _tfMark1.text=@"";
    _tfMark2.text=@"";
    _tfMark3.text=@"";
}

- (IBAction)OnOK:(id)sender
{
    if (_tfCount.text.intValue>99999)
    {
        [SVProgressHUD showErrorWithStatus:NSLocalizedStringFromTableInBundle(@"Count no more than 99999",@"RPString", g_bundleResorce,nil)];
    }
    else if (_tfCount.text.intValue>0)
    {
        NSString * str = NSLocalizedStringFromTableInBundle(@"Submitting...",@"RPString", g_bundleResorce,nil);
        [SVProgressHUD showWithStatus:str];
        if (_tfMark1.text.length<1&&_tfMark2.text.length<1&&_tfMark3.text.length<1)
        {
            _tfMark1.text=NSLocalizedStringFromTableInBundle(@"Undefined",@"RPString", g_bundleResorce,nil);
        }
        [[RPSDK defaultInstance]PostStoreStockCount:_storeSelected.strStoreId SN:_sn Count:_tfCount.text.intValue Tag1:_tfMark1.text Tag2:_tfMark2.text Tag3:_tfMark3.text Comments:@"" Success:^(id idResult) {
            [SVProgressHUD showSuccessWithStatus:NSLocalizedStringFromTableInBundle(@"Submit Success",@"RPString", g_bundleResorce,nil)];
            _bModify=NO;
            [self.view endEditing:YES];
            [self.delegateNewCount endCount];
            [self DoNavRoot];
        } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
            [SVProgressHUD showErrorWithStatus:NSLocalizedStringFromTableInBundle(@"failure",@"RPString", g_bundleResorce,nil)];
        }];
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:NSLocalizedStringFromTableInBundle(@"Number must be greater than 0",@"RPString", g_bundleResorce,nil)];
    }
}
-(IBAction)OnMenu:(id)sender
{
    _btMenu.selected=!_btMenu.selected;
    if (_btMenu.selected)
    {
        [UIView beginAnimations:nil context:nil];
        _viewMark.frame=CGRectMake(_viewMark.frame.origin.x, _viewHeader.frame.size.height+_viewCurrentMark.frame.size.height, _viewMark.frame.size.width, _viewMark.frame.size.height);
        [UIView commitAnimations];
    }
    else
    {
        [UIView beginAnimations:nil context:nil];
        _viewMark.frame=CGRectMake(_viewMark.frame.origin.x, -_viewMark.frame.size.height, _viewMark.frame.size.width, _viewMark.frame.size.height);
        [UIView commitAnimations];
    }
}

-(IBAction)OnCount:(id)sender
{
    
    _vcCount.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
//    NSLog(@"mode===%i",_mode);
    _vcCount.delegate=self;
    _vcCount.sum=_tfCount.text.integerValue;
    [self.vcFrame presentViewController:_vcCount animated:YES completion:^{
//        _mode++;
    }];
}
-(void)OnEndCount:(int)count
{
    _tfCount.text=[NSString stringWithFormat:@"%i",count];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    _bModify=YES;
    if (textField==_tfMark1)
    {
        _tfMark1.text=@"";
    }
    if (textField==_tfMark2)
    {
        _tfMark2.text=@"";
    }
    if (textField==_tfMark3)
    {
        _tfMark3.text=@"";
    }
}



- (IBAction)OnHelp:(id)sender
{
    [RPGuide ShowGuide:self.view];
}
@end
