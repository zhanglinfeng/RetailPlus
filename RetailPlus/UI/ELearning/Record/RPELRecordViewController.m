//
//  RPELRecordViewController.m
//  RetailPlus
//
//  Created by lin dong on 14-7-22.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPELRecordViewController.h"
#import "RPELLearnRecordCell.h"
#import "RPELExamRecordCell.h"
#import "SVProgressHUD.h"
extern NSBundle * g_bundleResorce;
@interface RPELRecordViewController ()

@end

@implementation RPELRecordViewController

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
    _viewFrame.layer.cornerRadius = 8;
    _bLearnMode = YES;
    [self UpdateUI];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)UpdateUI
{
    [SVProgressHUD showWithStatus:@""];
    
    if (_bLearnMode) {
        _viewLearnBg.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
        _lbLearnRec.textColor = [UIColor colorWithWhite:0.3 alpha:1];
        _viewLearnTip.hidden = NO;
        
        _viewExamBg.backgroundColor = [UIColor colorWithWhite:0.4 alpha:1];
        _lbExamRec.textColor = [UIColor colorWithWhite:0.2 alpha:1];
        _viewExamTip.hidden = YES;
        
        _tbLearnRec.hidden = NO;
        _tbExamRec.hidden = YES;
        
        _arrayLearnCataRec = [[NSArray alloc] init];
        [_tbLearnRec reloadData];
        
        [[RPSDK defaultInstance] GetLearnRecCatagory:^(NSArray * arrayResult) {
            _arrayLearnCataRec = arrayResult;
            [_tbLearnRec reloadData];
            [SVProgressHUD dismiss];
        } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
            
        }];
    }
    else
    {
        _viewLearnBg.backgroundColor = [UIColor colorWithWhite:0.4 alpha:1];
        _lbLearnRec.textColor = [UIColor colorWithWhite:0.2 alpha:1];
        _viewLearnTip.hidden = YES;
        
        _viewExamBg.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
        _lbExamRec.textColor = [UIColor colorWithWhite:0.3 alpha:1];
        _viewExamTip.hidden = NO;
        
        _tbLearnRec.hidden = YES;
        _tbExamRec.hidden = NO;
        
        _arrayExamCataRec = [[NSArray alloc] init];
        [_tbExamRec reloadData];
        
        [[RPSDK defaultInstance] GetExamRecCatagory:^(NSArray * arrayResult) {
            _arrayExamCataRec = arrayResult;
            [_tbExamRec reloadData];
            [SVProgressHUD dismiss];
        } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
            
        }];
    }
}

-(IBAction)OnLearnRec:(id)sender
{
    _bLearnMode = YES;
    [self UpdateUI];
}

-(IBAction)OnExamRec:(id)sender
{
    _bLearnMode = NO;
    [self UpdateUI];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == _tbLearnRec)
        return _arrayLearnCataRec.count;
    return _arrayExamCataRec.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    RPELRecordCatagory * catagory = nil;
    if (tableView == _tbLearnRec)
        catagory = [_arrayLearnCataRec objectAtIndex:section];
    else
        catagory = [_arrayExamCataRec objectAtIndex:section];
    
    if (catagory.bExpand)
        return catagory.arrayRecord.count;
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    RPELRecordHeadView *view = [[[NSBundle mainBundle] loadNibNamed:@"RPELRecordHeadView" owner:nil options:nil] objectAtIndex:0];
    RPELRecordCatagory * catagory = nil;
    if (tableView == _tbLearnRec)
    {
        catagory = [_arrayLearnCataRec objectAtIndex:section];
        view.bLearnRecord = YES;
    }
    else
    {
        catagory = [_arrayExamCataRec objectAtIndex:section];
        view.bLearnRecord = NO;
    }
    view.catagory = catagory;
    view.delegate = self;
    return view;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _tbLearnRec) {
        RPELLearnRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RPELLearnRecordCell"];
        if (cell == nil)
        {
            NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"RPELLearnRecordCell" owner:self options:nil];
            cell = [array objectAtIndex:0];
        }
        
        RPELRecordCatagory * catagory = [_arrayLearnCataRec objectAtIndex:indexPath.section];
        cell.record = [catagory.arrayRecord objectAtIndex:indexPath.row];
        return cell;
    }
    else
    {
        RPELExamRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RPELExamRecordCell"];
        if (cell == nil)
        {
            NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"RPELExamRecordCell" owner:self options:nil];
            cell = [array objectAtIndex:0];
        }
        
        RPELRecordCatagory * catagory = [_arrayExamCataRec objectAtIndex:indexPath.section];
        cell.record = [catagory.arrayRecord objectAtIndex:indexPath.row];
        return cell;
    }
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

-(float)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 32;
}

-(void)OnExpandCatagory:(RPELRecordCatagory *)catagory
{
    catagory.bExpand = !catagory.bExpand;
    [_tbLearnRec reloadData];
    [_tbExamRec reloadData];
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
- (IBAction)OnHelp:(id)sender
{
    [RPGuide ShowGuide:self.view];
}
@end
