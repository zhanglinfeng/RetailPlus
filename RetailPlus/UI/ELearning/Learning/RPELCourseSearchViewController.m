//
//  RPELCourseSearchViewController.m
//  RetailPlus
//
//  Created by lin dong on 14-7-24.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPELCourseSearchViewController.h"
#import "RPSDKELDefine.h"
#import "RPWebDocViewController.h"
#import "RPAppDelegate.h"
#import "RPELWebCache.h"
#import "RPDLProgressViewController.h"
#import "SVProgressHUD.h"

extern NSBundle * g_bundleResorce;

@interface RPELCourseSearchViewController ()

@end

@implementation RPELCourseSearchViewController

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
    _viewSearch.layer.cornerRadius = 4;
    _arrayCourseWare = [[NSMutableArray alloc] init];
    [_tbSearch reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)OnSearch:(id)sender
{
    [self.view endEditing:YES];
    [self DoSearch];
}

-(IBAction)OnClearSearch:(id)sender
{
    _tfSearch.text = @"";
    [self.view endEditing:YES];
    
    [_arrayCourseWare removeAllObjects];
    [_tbSearch reloadData];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self DoSearch];
    [self.view endEditing:YES];
    return YES;
}

-(void)DoSearch
{
    [_arrayCourseWare removeAllObjects];
    
    for (RPELCourseCatagory * catagory in _arrayCourseCatagory) {
        for (RPELCourse * course in catagory.arrayCourse) {
            for (RPELCourseWare * ware in course.arrayCourseWare) {
                NSRange range1 = [ware.strNo rangeOfString:_tfSearch.text options:NSCaseInsensitiveSearch];
                NSRange range2 = [ware.strName rangeOfString:_tfSearch.text options:NSCaseInsensitiveSearch];
                NSRange range3 = [ware.strDesc rangeOfString:_tfSearch.text options:NSCaseInsensitiveSearch];
                
                if (range1.length != 0 || range2.length != 0 || range3.length != 0) {
                    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
                    [dict setObject:ware forKey:@"CourseWare"];
                    [dict setObject:course forKey:@"Course"];
                    [_arrayCourseWare addObject:dict];
                }
            }
        }
    }
    
    if (_arrayCourseWare.count == 0) {
        [SVProgressHUD showErrorWithStatus:NSLocalizedStringFromTableInBundle(@"The search result is empty",@"RPString", g_bundleResorce,nil)];
    }
    
    [_tbSearch reloadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_arrayCourseWare.count == 0) {
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        return 0;
    }
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    return _arrayCourseWare.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RPELCourseWareSearchCell *cell=[tableView dequeueReusableCellWithIdentifier:@"RPELCourseWareSearchCell"];
    if (cell==nil)
    {
        NSArray *arrayNib=[[NSBundle mainBundle]loadNibNamed:@"RPELCourseWareSearchCell" owner:self options:nil];
        cell=[arrayNib objectAtIndex:0];
        cell.delegate = self;
    }
    
    cell.dictResult = [_arrayCourseWare objectAtIndex:indexPath.row];
    return cell;
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 74;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary * dictResult = [_arrayCourseWare objectAtIndex:indexPath.row];
    RPELCourseWare * courseWare = [dictResult objectForKey:@"CourseWare"];
    [self OpenCourseWare:courseWare InCourse:[dictResult objectForKey:@"Course"]];
}

-(void)OpenUrl:(NSString *)strOpenUrl Title:(NSString *)strTitle isLocalFile:(BOOL)bLocalFile
{
    RPWebDocViewController * vcWeb = [[RPWebDocViewController alloc] initWithNibName:NSStringFromClass([RPWebDocViewController class]) bundle:nil];
    vcWeb.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    vcWeb.strUrl = strOpenUrl;
    vcWeb.strTitle = strTitle;
    
    vcWeb.bLocalFile = bLocalFile;
    vcWeb.cache = nil;
    RPAppDelegate * app = (RPAppDelegate *)[[UIApplication sharedApplication] delegate];
    [app.viewController presentViewController:vcWeb animated:YES completion:^{
        
    }];
}

-(void)SetCourseWareRead:(RPELCourseWare *)courseWare InCourse:(RPELCourse *)course
{
    [SVProgressHUD showWithStatus:@""];
    [[RPSDK defaultInstance] UpdateLearnRecord:courseWare inCourse:course Success:^(id idResult) {
        courseWare.bRead = YES;
        [_tbSearch reloadData];
        [SVProgressHUD dismiss];
    } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
        
    }];
}

-(void)OpenCourseWare:(RPELCourseWare *)courseWare InCourse:(RPELCourse *)course
{
    NSString * strRootPath = @"Course";
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * strDocumentDirectory = [paths objectAtIndex:0];
    NSString * strFileSavePath = [strDocumentDirectory stringByAppendingString:[NSString stringWithFormat:@"/%@/%@/",strRootPath,courseWare.strId]];
    
    NSString * strOpenUrl = [RPELWebCache GetCacheURL:courseWare.strDownloadUrl PathSave:strFileSavePath];
    if (strOpenUrl) {
        [self OpenUrl:strOpenUrl Title:courseWare.strName isLocalFile:YES];
    }
    else
    {
        [self OpenUrl:courseWare.strReadUrl Title:courseWare.strName isLocalFile:NO];
    }
    
    if (!courseWare.bRead) {
        [self SetCourseWareRead:courseWare InCourse:course];
    }
}

NSInteger nBytesRecv;

-(void)DoDownloadOrOpenCourseWare:(RPELCourseWare *)courseWare InCourse:(RPELCourse *)course Open:(BOOL)bOpen
{
    if (bOpen) {
        [self OpenCourseWare:courseWare InCourse:course];
    }
    else
    {
        [RPDLProgressViewController dismiss];
        
        NSString * strRootPath = @"Course";
        NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString * strDocumentDirectory = [paths objectAtIndex:0];
        NSString * strFileSavePath = [strDocumentDirectory stringByAppendingString:[NSString stringWithFormat:@"/%@/%@/",strRootPath,courseWare.strId]];
        
        nBytesRecv = 0;
        _cacheDownloadCourseWare = [[RPELWebCache alloc] init:courseWare.strDownloadUrl PathSave:strFileSavePath];
        [_cacheDownloadCourseWare SetCompleteBlock:^(NSString *strFilePath) {
             [RPDLProgressViewController dismiss];
            [_tbSearch reloadData];
        }];
        
        [_cacheDownloadCourseWare SetFailedBlock:^{
             [RPDLProgressViewController dismiss];
        }];
        
        [_cacheDownloadCourseWare SetProgressBlock:^(unsigned long long size, unsigned long long total) {
            nBytesRecv += size;
            [RPDLProgressViewController showProgress:nBytesRecv TotalSize:total target:self Desc:courseWare.strName selector:@selector(OnCancelDownload)];
        }];
        
        [RPDLProgressViewController showProgress:0 TotalSize:0 target:self Desc:courseWare.strName selector:@selector(OnCancelDownload)];
        [_cacheDownloadCourseWare StartAsynchronous];
    }
}

-(void)OnCancelDownload
{
    [_cacheDownloadCourseWare CancelDownload];
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
