//
//  RPELCourseViewController.m
//  RetailPlus
//
//  Created by lin dong on 14-7-22.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPELCourseViewController.h"
#import "RPELCourseHeadView.h"
#import "RPELCourseCell.h"
#import "RPSDK+ELearning.h"
#import "SVProgressHUD.h"
extern NSBundle * g_bundleResorce;
@interface RPELCourseViewController ()

@end

@implementation RPELCourseViewController

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
    
    
    NSFileManager * fileManager = [NSFileManager defaultManager];
    NSString * strRootPath = @"Course";
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * strDocumentDirectory = [paths objectAtIndex:0];
    NSString * strFileSavePath = [strDocumentDirectory stringByAppendingString:[NSString stringWithFormat:@"/%@/",strRootPath]];
    [fileManager createDirectoryAtPath:strFileSavePath withIntermediateDirectories:NO attributes:nil error:nil];
     
    [self initData];
}

- (void)initData
{
//    _arrayCourseCatagory = [[NSMutableArray alloc] init];
//    for (NSInteger n = 0; n < 3; n ++) {
//        RPELCourseCatagory * cata = [RPELCourseCatagory alloc];
//        cata.strCatagory = @"系列1";
//        cata.arrayCourse = [[NSMutableArray alloc] init];
//        cata.bExpand = YES;
//        {
//            RPELCourse * course = [[RPELCourse alloc] init];
//            course.strThumbUrl = @"http://i2.w.yun.hjfile.cn/doc/201312/4e2983b824644fe9945621d985a0e95f.jpg";
//            course.strNo= @"#001";
//            course.strName = @"NEW PRODUCT 2014 FALL-PART1";
//            course.arrayCourseWare = [[NSMutableArray alloc] init];
//            course.strDesc = @"课程说明";
//            
//            RPELCourseWare * ware = [[RPELCourseWare alloc] init];
//            ware.strNo = @"#001-00001";
//            ware.strName = @"kejian1";
//            ware.strDesc = @"系列-课件1";
//            ware.strThumbUrl = @"http://i2.w.yun.hjfile.cn/doc/201312/4e2983b824644fe9945621d985a0e95f.jpg";
//            ware.strDownloadUrl = @"http://192.168.1.244/RetailPlusAPI/hbc02140527.zip";
//            ware.strId = @"00000001";
//            ware.bRead = YES;
//            [course.arrayCourseWare addObject:ware];
//            
//            ware = [[RPELCourseWare alloc] init];
//            ware.strNo = @"#002-00002";
//            ware.strName = @"kejian2";
//            ware.strDesc = @"系列-课件2";
//            ware.strThumbUrl = @"http://i2.w.yun.hjfile.cn/doc/201312/4e2983b824644fe9945621d985a0e95f.jpg";
//            ware.strDownloadUrl = @"http://i2.w.yun.hjfile.cn/doc/201312/4e2983b824644fe9945621d985a0e95f.jpg";
//            ware.strReadUrl = @"http://i2.w.yun.hjfile.cn/doc/201312/4e2983b824644fe9945621d985a0e95f.jpg";
//            ware.strId = @"00000002";
//            [course.arrayCourseWare addObject:ware];
//            
//            [cata.arrayCourse addObject:course];
//        }
//        
//        {
//            RPELCourse * course = [[RPELCourse alloc] init];
//            course.strThumbUrl = @"http://i2.w.yun.hjfile.cn/doc/201312/4e2983b824644fe9945621d985a0e95f.jpg";
//            course.strNo= @"#002";
//            course.strName = @"NEW PRODUCT 2014 FALL-PART2";
//            [cata.arrayCourse addObject:course];
//        }
//        [_arrayCourseCatagory addObject:cata];
//    }
    
    [SVProgressHUD showWithStatus:@""];
    [[RPSDK defaultInstance] GetCourseCatagory:^(NSArray * arrayCatagory) {
        _arrayCourseCatagory = arrayCatagory;
        [_tbCourse reloadData];
        [SVProgressHUD dismiss];
    } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
        _arrayCourseCatagory = [[NSArray alloc] init];
        [_tbCourse reloadData];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)OnFilter:(id)sender
{
    _bShowFilter = !_bShowFilter;
    
    [UIView beginAnimations:nil context:nil];
    if (_bShowFilter) {
        _viewFilter.hidden = NO;
        _viewFilterTip.hidden = NO;
        _tbCourse.frame = CGRectMake(0, _viewFilter.frame.size.height + _viewHead.frame.size.height, _tbCourse.frame.size.width, _tbCourse.frame.size.height - _viewFilter.frame.size.height);
    }
    else
    {
        _viewFilter.hidden = YES;
        _viewFilterTip.hidden = YES;
        _tbCourse.frame = CGRectMake(0, _viewHead.frame.size.height, _tbCourse.frame.size.width, _tbCourse.frame.size.height + _viewFilter.frame.size.height);
    }
    [UIView commitAnimations];
}

-(IBAction)OnSearch:(id)sender
{
    _vcCourseSearch = [[RPELCourseSearchViewController alloc] initWithNibName:NSStringFromClass([RPELCourseSearchViewController class]) bundle:g_bundleResorce];
    _vcCourseSearch.delegate=self.delegate;
    _vcCourseSearch.arrayCourseCatagory = _arrayCourseCatagory;
    [self.navigationController pushViewController:_vcCourseSearch animated:YES];
}

-(void)OnExpandCatagory:(RPELCourseCatagory *)catagory
{
    catagory.bExpand = !catagory.bExpand;
    [_tbCourse reloadData];
}

-(void)UpdateFiltBtn
{
    [_btnFinish setSelected:_bFiltUnFinished];
    [_btnLearning setSelected:_bFiltUnLearning];
    [_btnNerverRead setSelected:_bFiltUnNerverRead];
    
    if (_bFiltUnNerverRead || _bFiltUnFinished || _bFiltUnLearning)
        [_btnFilter setSelected:YES];
    else
       [_btnFilter setSelected:NO];
    
}

-(IBAction)OnFiltFinished:(id)sender
{
    _bFiltUnFinished = !_bFiltUnFinished;
    [self UpdateFiltBtn];
    [_tbCourse reloadData];
}

-(IBAction)OnFiltLearning:(id)sender
{
    _bFiltUnLearning = !_bFiltUnLearning;
    [self UpdateFiltBtn];
    [_tbCourse reloadData];
}

-(IBAction)OnFiltNeverRead:(id)sender
{
    _bFiltUnNerverRead = !_bFiltUnNerverRead;
    [self UpdateFiltBtn];
    [_tbCourse reloadData];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _arrayCourseCatagory.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    RPELCourseCatagory * catagory = [_arrayCourseCatagory objectAtIndex:section];
    if (catagory.bExpand)
        return catagory.arrayCourse.count;
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    RPELCourseHeadView *view = [[[NSBundle mainBundle] loadNibNamed:@"RPELCourseHeadView" owner:nil options:nil] objectAtIndex:0];
    RPELCourseCatagory * catagory = [_arrayCourseCatagory objectAtIndex:section];
    view.catagory = catagory;
    view.delegate = self;
    return view;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RPELCourseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RPELCourseCell"];
    if (cell == nil)
    {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"RPELCourseCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
    }
    
    RPELCourseCatagory * catagory = [_arrayCourseCatagory objectAtIndex:indexPath.section];
    cell.course = [catagory.arrayCourse objectAtIndex:indexPath.row];
    return cell;
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RPELCourseCatagory * catagory = [_arrayCourseCatagory objectAtIndex:indexPath.section];
    RPELCourse * course = [catagory.arrayCourse objectAtIndex:indexPath.row];
    
    NSInteger nRead = 0;
    NSInteger nSta = 1; //0 finish 1 reading 2 unread
    
    for (RPELCourseWare * ware in course.arrayCourseWare) {
        if (ware.bRead) {
            nRead ++;
        }
    }
    if (nRead == 0) nSta = 2;
    else if (nRead == course.arrayCourseWare.count) nSta = 0;
    else nSta = 1;
    
    if (_bFiltUnFinished && nSta == 0) {
        return 0;
    }
    
    if (_bFiltUnNerverRead && nSta == 2) {
        return 0;
    }
    
    if (_bFiltUnLearning && nSta == 1) {
        return 0;
    }
    
    if (course.strDesc.length == 0)
        return 128;
    return 166;
}

-(float)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
//    return 32;
    
    RPELCourseCatagory * catagory = [_arrayCourseCatagory objectAtIndex:section];
    
    BOOL bShowHead = NO;
    for (RPELCourse * course in catagory.arrayCourse) {
        NSInteger nRead = 0;
        NSInteger nSta = 1; //0 finish 1 reading 2 unread
        
        for (RPELCourseWare * ware in course.arrayCourseWare) {
            if (ware.bRead) {
                nRead ++;
            }
        }
        
        if (nRead == 0) nSta = 2;
        else if (nRead == course.arrayCourseWare.count) nSta = 0;
        else nSta = 1;
        
        if (!_bFiltUnFinished && nSta == 0) {
            bShowHead = YES;
            break;
        }
        
        if (!_bFiltUnNerverRead && nSta == 2) {
            bShowHead = YES;
            break;
        }
        
        if (!_bFiltUnLearning && nSta == 1) {
            bShowHead = YES;
            break;
        }
    }
   
    if (bShowHead)
        return 32;
    return 0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _vcCourseWare = [[RPELCourseWareViewController alloc] initWithNibName:NSStringFromClass([RPELCourseWareViewController class]) bundle:[NSBundle mainBundle]];
    _vcCourseWare.delegate=self.delegate;
    [self.navigationController pushViewController:_vcCourseWare animated:YES];
    RPELCourseCatagory * catagory = [_arrayCourseCatagory objectAtIndex:indexPath.section];
    _vcCourseWare.course = [catagory.arrayCourse objectAtIndex:indexPath.row];
}

-(void)OnActive
{
    [_tbCourse reloadData];
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
