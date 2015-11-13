//
//  RPELCourseWareViewController.m
//  RetailPlus
//
//  Created by lin dong on 14-7-24.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPELCourseWareViewController.h"
#import "UIImageView+WebCache.h"
#import "RPWebDocViewController.h"
#import "RPAppDelegate.h"
#import "RPELWebCache.h"
#import "RPDLProgressViewController.h"
#import "RPSDK+ELearning.h"
#import "SVProgressHUD.h"
extern NSBundle * g_bundleResorce;
@interface RPELCourseWareViewController ()

@end

@implementation RPELCourseWareViewController

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
    _viewCorner.layer.cornerRadius = 8;
    _carousel.delegate = self;
    _carousel.dataSource = self;
    _carousel.type = iCarouselTypeCoverFlow;
   // _carousel.bounceDistance = 0;
   // _carousel.perspective = 0.5;
    [self UpdateUI];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)UpdateUI
{
    NSString * str = NSLocalizedStringFromTableInBundle(@"Course #",@"RPString", g_bundleResorce,nil);
    _lbNo.text = [NSString stringWithFormat:@"%@%@",str,_course.strNo];
    
    _lbTitle.text = _course.strName;
    
    NSInteger nRead = 0;
    for (RPELCourseWare * ware in _course.arrayCourseWare) {
        if (ware.bRead) nRead ++;
    }
    
    if (nRead == 0)
        _viewFrame.backgroundColor = [UIColor colorWithRed:190.0f/255 green:60.0f/255 blue:70.0f/255 alpha:1];
    else if (nRead == _course.arrayCourseWare.count)
        _viewFrame.backgroundColor = [UIColor colorWithRed:135.0f/255 green:150.0f/255 blue:85.0f/255 alpha:1];
    else
        _viewFrame.backgroundColor = [UIColor colorWithRed:247.0f/255 green:177.0f/255 blue:15.0f/255 alpha:1];
    
    //_lbReadCount.text = [NSString stringWithFormat:@"%d",nRead];
    _lbAllCount.text = [NSString stringWithFormat:@"/%d",_course.arrayCourseWare.count];
}

-(void)setCourse:(RPELCourse *)course
{
    _course = course;
    [self UpdateUI];
    [_carousel reloadData];
}

#pragma mark -

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return _course.arrayCourseWare.count;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index
{
    UIImageView *view = [[UIImageView alloc] init];
    RPELCourseWare * ware = [_course.arrayCourseWare objectAtIndex:index];
    [view setImageWithURLString:ware.strThumbUrl placeholderImage:[UIImage imageNamed:@"image_default_coursware.png"]];
    view.frame = CGRectMake(0, 0, 140, 140);
    view.layer.cornerRadius = 8;
    view.clipsToBounds = YES;
    return view;
}

- (NSUInteger)numberOfPlaceholdersInCarousel:(iCarousel *)carousel
{
	return 0;
}

- (NSUInteger)numberOfVisibleItemsInCarousel:(iCarousel *)carousel
{
    return _course.arrayCourseWare.count;
}

- (CGFloat)carouselItemWidth:(iCarousel *)carousel
{
    return 140;
}

- (void)carouselDidEndScrollingAnimation:(iCarousel *)carousel
{
    if (carousel.previousItemIndex >= 0) {
        _courseWare = [_course.arrayCourseWare objectAtIndex:carousel.previousItemIndex];
        _tvCourseWareDesc.text = _courseWare.strDesc;
        _lbCourseWareTitle.text = _courseWare.strName;
        
        NSString * str = NSLocalizedStringFromTableInBundle(@"Courseware #",@"RPString", g_bundleResorce,nil);
        _lbCourseWareNo.text = [NSString stringWithFormat:@"%@%@",str,_courseWare.strNo];
        
        if (_courseWare.bRead)
            _ivRead.image = [UIImage imageNamed:@"icon_cw_read.png"];
        else
            _ivRead.image = [UIImage imageNamed:@"icon_cw_noread.png"];
        
        NSString * strRootPath = @"Course";
        NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString * strDocumentDirectory = [paths objectAtIndex:0];
        NSString * strFileSavePath = [strDocumentDirectory stringByAppendingString:[NSString stringWithFormat:@"/%@/%@/",strRootPath,_courseWare.strId]];
        if ([RPELWebCache GetCacheURL:_courseWare.strDownloadUrl PathSave:strFileSavePath]) {
            [_btnDownload setImage:[UIImage imageNamed:@"icon_downloaded.png"] forState:UIControlStateNormal];
            [_btnDownload setSelected:YES];
        }
        else
        {
            [_btnDownload setImage:[UIImage imageNamed:@"button_download.png"] forState:UIControlStateNormal];
            [_btnDownload setSelected:NO];
        }
        
        _lbReadCount.text = [NSString stringWithFormat:@"%d",(carousel.previousItemIndex + 1)];
    }
}

-(void)OpenUrl:(NSString *)strOpenUrl Title:(NSString *)strTitle isLocalFile:(BOOL)bLocalFile
{
    RPWebDocViewController * vcWeb = [[RPWebDocViewController alloc] initWithNibName:NSStringFromClass([RPWebDocViewController class]) bundle:nil];
    vcWeb.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    vcWeb.strUrl = strOpenUrl;
    vcWeb.bLocalFile = bLocalFile;
    vcWeb.strTitle = strTitle;
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
        if ([courseWare.strId isEqualToString:_courseWare.strId]) {
            _ivRead.image = [UIImage imageNamed:@"icon_cw_read.png"];
        }
        [self UpdateUI];
        [SVProgressHUD dismiss];
    } Failed:^(NSInteger nErrorCode, NSString *strDesc) {

    }];
}

-(void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index
{
    _courseWare = [_course.arrayCourseWare objectAtIndex:index];
    
    NSString * strRootPath = @"Course";
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * strDocumentDirectory = [paths objectAtIndex:0];
    NSString * strFileSavePath = [strDocumentDirectory stringByAppendingString:[NSString stringWithFormat:@"/%@/%@/",strRootPath,_courseWare.strId]];
    
    NSString * strOpenUrl = [RPELWebCache GetCacheURL:_courseWare.strDownloadUrl PathSave:strFileSavePath];
    if (strOpenUrl) {
        [self OpenUrl:strOpenUrl Title:_courseWare.strName isLocalFile:YES];
    }
    else
    {
        [self OpenUrl:_courseWare.strReadUrl Title:_courseWare.strName isLocalFile:NO];
    }
    
    if (!_courseWare.bRead) {
        [self SetCourseWareRead:_courseWare InCourse:_course];
    }
}

- (BOOL)carouselShouldWrap:(iCarousel *)carousel
{
    return NO;
}

-(IBAction)OnDownload:(id)sender
{
    if (!_courseWare) return;
    
    NSString * strRootPath = @"Course";
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * strDocumentDirectory = [paths objectAtIndex:0];
    NSString * strFileSavePath = [strDocumentDirectory stringByAppendingString:[NSString stringWithFormat:@"/%@/%@/",strRootPath,_courseWare.strId]];
    
    NSString * strOpenUrl = [RPELWebCache GetCacheURL:_courseWare.strDownloadUrl PathSave:strFileSavePath];
    if (strOpenUrl) {
        [self OpenUrl:strOpenUrl Title:_courseWare.strName isLocalFile:YES];
        if (!_courseWare.bRead) {
            [self SetCourseWareRead:_courseWare InCourse:_course];
        }
        return;
    }
    
    [RPDLProgressViewController dismiss];
    _cacheCourseWare = [[RPELWebCache alloc] init:_courseWare.strDownloadUrl PathSave:strFileSavePath];
    [_cacheCourseWare SetCompleteBlock:^(NSString *strFilePath) {
        [RPDLProgressViewController dismiss];
        [_btnDownload setImage:[UIImage imageNamed:@"icon_downloaded.png"] forState:UIControlStateNormal];
        [_btnDownload setSelected:YES];
    }];
    
    [_cacheCourseWare SetFailedBlock:^{
        [RPDLProgressViewController dismiss];
    }];
    
    [_cacheCourseWare SetProgressBlock:^(unsigned long long size, unsigned long long total) {
        nBytesRecv += size;
        [RPDLProgressViewController showProgress:nBytesRecv TotalSize:total target:self Desc:_courseWare.strName selector:@selector(OnCancelDownload)];
    }];
    
    [RPDLProgressViewController showProgress:0 TotalSize:0 target:self Desc:_courseWare.strName selector:@selector(OnCancelDownload)];
    nBytesRecv = 0;
    [_cacheCourseWare StartAsynchronous];
}

-(void)OnCancelDownload
{
    [_cacheCourseWare CancelDownload];
}

-(void)OnCancelDownloadArray
{
    [_arrayDownload removeAllObjects];
    [_cacheCourseWareArray CancelDownload];
    
    NSString * strRootPath = @"Course";
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * strDocumentDirectory = [paths objectAtIndex:0];
    NSString * strFileSavePath = [strDocumentDirectory stringByAppendingString:[NSString stringWithFormat:@"/%@/%@/",strRootPath,_courseWare.strId]];
    if ([RPELWebCache GetCacheURL:_courseWare.strDownloadUrl PathSave:strFileSavePath]) {
        [_btnDownload setImage:[UIImage imageNamed:@"icon_downloaded.png"] forState:UIControlStateNormal];
        [_btnDownload setSelected:YES];
    }
    else
    {
        [_btnDownload setImage:[UIImage imageNamed:@"button_download.png"] forState:UIControlStateNormal];
        [_btnDownload setSelected:NO];
    }
}

NSInteger nBytesRecv;

-(void)DoDownloadArray:(NSInteger)nIndex
{
    NSString * strRootPath = @"Course";
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * strDocumentDirectory = [paths objectAtIndex:0];
    if (nIndex >= _arrayDownload.count)
    {
        NSString * strFileSavePath = [strDocumentDirectory stringByAppendingString:[NSString stringWithFormat:@"/%@/%@/",strRootPath,_courseWare.strId]];
        if ([RPELWebCache GetCacheURL:_courseWare.strDownloadUrl PathSave:strFileSavePath]) {
            [_btnDownload setImage:[UIImage imageNamed:@"icon_downloaded.png"] forState:UIControlStateNormal];
            [_btnDownload setSelected:YES];
        }
        else
        {
            [_btnDownload setImage:[UIImage imageNamed:@"button_download.png"] forState:UIControlStateNormal];
            [_btnDownload setSelected:NO];
        }
        return;
    }
    
    [RPDLProgressViewController dismiss];
    
    RPELCourseWare * ware = [_arrayDownload objectAtIndex:nIndex];
    NSString * strFileSavePath = [strDocumentDirectory stringByAppendingString:[NSString stringWithFormat:@"/%@/%@/",strRootPath,ware.strId]];
    
    _cacheCourseWareArray = [[RPELWebCache alloc] init:ware.strDownloadUrl PathSave:strFileSavePath];
    [_cacheCourseWareArray SetCompleteBlock:^(NSString *strFilePath) {
        [self DoDownloadArray:(nIndex + 1)];
        [RPDLProgressViewController dismiss];
    }];
    
    [_cacheCourseWareArray SetFailedBlock:^{
        [self DoDownloadArray:(nIndex + 1)];
        [RPDLProgressViewController dismiss];
    }];
    
    [_cacheCourseWareArray SetProgressBlock:^(unsigned long long size, unsigned long long total) {
        nBytesRecv += size;
        [RPDLProgressViewController showProgress:nBytesRecv TotalSize:total target:self Desc:ware.strName selector:@selector(OnCancelDownloadArray)];
    }];
    
    nBytesRecv = 0;
    [RPDLProgressViewController showProgress:0 TotalSize:0 target:self Desc:ware.strName selector:@selector(OnCancelDownloadArray)];
    [_cacheCourseWareArray StartAsynchronous];
}

-(IBAction)OnDownloadAll:(id)sender
{
    NSString * strRootPath = @"Course";
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * strDocumentDirectory = [paths objectAtIndex:0];
   
    _arrayDownload = [[NSMutableArray alloc] init];
    for (RPELCourseWare * ware in _course.arrayCourseWare) {
        NSString * strFileSavePath = [strDocumentDirectory stringByAppendingString:[NSString stringWithFormat:@"/%@/%@/",strRootPath,ware.strId]];
        if (![RPELWebCache GetCacheURL:ware.strDownloadUrl PathSave:strFileSavePath])  {
            [_arrayDownload addObject:ware];
        }
    }
    
    if (_arrayDownload.count == 0)
        return;
    
    [self DoDownloadArray:0];
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
