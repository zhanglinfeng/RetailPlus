//
//  RPDSMainViewController.m
//  RetailPlus
//
//  Created by lin dong on 14-7-4.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPDSMainViewController.h"
#import "RPStockSearchCell.h"
#import "SVProgressHUD.h"
#import "RPBlockUIAlertView.h"
extern NSBundle * g_bundleResorce;
@interface RPDSMainViewController ()

@end

@implementation RPDSMainViewController

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
    _tbReport.delegateReport = self;
    _viewFrame.layer.cornerRadius=10;
    _viewSearch.layer.cornerRadius=6;
    NSArray *array = [g_bundleResorce loadNibNamed:@"CustomView" owner:self options:nil];
    _viewStoreList = [array objectAtIndex:1];
    _viewStoreList.delegate = self;
    _tbReport.bShowCurrentStock=NO;
    _tbReport.hidden=YES;
    _viewMenu.hidden=NO;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd"];
    _pickDate = [[RPDatePicker alloc] init:_tfSearch Format:dateFormatter curDate:[NSDate date] canDelete:NO Mode:UIDatePickerModeDate canFuture:NO canPreviously:YES];
    _tfSearch.text=@"";
    
    
    // 滑动的 Recognizer
    UISwipeGestureRecognizer *swipeRecognizerLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeLeft:)];
    //设置滑动方向
    [swipeRecognizerLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [_viewThumbFrame addGestureRecognizer:swipeRecognizerLeft];
    
    // 滑动的 Recognizer
    UISwipeGestureRecognizer *swipeRecognizerRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeRight:)];
    //设置滑动方向
    [swipeRecognizerRight setDirection:UISwipeGestureRecognizerDirectionRight];
    [_viewThumbFrame addGestureRecognizer:swipeRecognizerRight];
    _bInAppear=YES;
}
-(void)handleSwipeLeft:(UISwipeGestureRecognizer*)recognizer
{
    if (_storeSelected==nil)
    {
        [SVProgressHUD showErrorWithStatus:NSLocalizedStringFromTableInBundle(@"No Store Selected",@"RPString", g_bundleResorce,nil)];
        return;
    }
    
    //处理滑动操作
//    CGPoint translation = [recognizer locationInView:self.view];
//    NSLog(@"Swipe - start location: %f,%f", translation.x, translation.y);
    //    recognizer.view.transform = CGAffineTransformMakeTranslation(translation.x, translation.y);
    if (_sn==_snSum)
    {
        return;
    }
        _sn=_sn+1;
        _isLatest=NO;
        _isQuery=NO;
        [self loadData];
    
    
    _lbPrevious.frame=CGRectMake(320+20, _lbPrevious.frame.origin.y, _lbPrevious.frame.size.width, _lbPrevious.frame.size.height);
    _lbInOut.frame=CGRectMake(320+96, _lbInOut.frame.origin.y, _lbInOut.frame.size.width, _lbInOut.frame.size.height);
    _lbCurrentStock.frame=CGRectMake(320+172, _lbCurrentStock.frame.origin.y, _lbCurrentStock.frame.size.width, _lbCurrentStock.frame.size.height);
    [UIView beginAnimations:nil context:nil];
    _lbPrevious.frame=CGRectMake(20, _lbPrevious.frame.origin.y, _lbPrevious.frame.size.width, _lbPrevious.frame.size.height);
    _lbInOut.frame=CGRectMake(96, _lbInOut.frame.origin.y, _lbInOut.frame.size.width, _lbInOut.frame.size.height);
    _lbCurrentStock.frame=CGRectMake(172, _lbCurrentStock.frame.origin.y, _lbCurrentStock.frame.size.width, _lbCurrentStock.frame.size.height);
    [UIView commitAnimations];
}
-(void)changeColor:(BOOL)isCurrent
{
    if (isCurrent)
    {
        
        _lbCurrentStock.text=NSLocalizedStringFromTableInBundle(@"CURRENT STOCK",@"RPString", g_bundleResorce,nil);
        _viewBG.backgroundColor=[UIColor colorWithRed:55.0/255 green:115.0/255 blue:120.0/255 alpha:1];
        _viewBGFinish.backgroundColor=[UIColor colorWithRed:55.0/255 green:115.0/255 blue:120.0/255 alpha:1];
        [_btCurrent setBackgroundImage:[UIImage imageNamed:@"button_current@2x.png"] forState:UIControlStateNormal];
        [_btCurrent setBackgroundImage:[UIImage imageNamed:@"button_current_@2x.png"] forState:UIControlStateSelected];
        _ivTag.image=[UIImage imageNamed:@"image_finish counting_@2x.png"];
        _ivTag.frame=CGRectMake(_ivTag.frame.origin.x, _ivTag.frame.origin.y,30, _ivTag.frame.size.height);
        _lbFinishName.text=NSLocalizedStringFromTableInBundle(@"CLOSE COUNTING",@"RPString", g_bundleResorce,nil);
        _lbDifference.textColor=[UIColor colorWithRed:255.0/255 green:204.0/255 blue:0 alpha:1];
        _viewLine.hidden=YES;
        if (_lbDifference.text.intValue==0)
        {
            _ivWarn.hidden=YES;//平账
        }
        else
        {
            _ivWarn.hidden=NO;//不平账
        }
    }
    else
    {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        _lbCurrentStock.text=[formatter stringFromDate:_storeStockList.closeTime];
        
        _viewBG.backgroundColor=[UIColor colorWithRed:225.0/255 green:130.0/255 blue:0 alpha:1];
        _viewBGFinish.backgroundColor=[UIColor colorWithRed:225.0/255 green:130.0/255 blue:0 alpha:1];
        [_btCurrent setBackgroundImage:[UIImage imageNamed:@"button_current@2x.png"] forState:UIControlStateNormal];
        [_btCurrent setBackgroundImage:[UIImage imageNamed:@"button_current__@2x.png"] forState:UIControlStateSelected];
        _ivTag.frame=CGRectMake(_ivTag.frame.origin.x, _ivTag.frame.origin.y,26, _ivTag.frame.size.height);
        _lbFinishName.text=[NSString stringWithFormat:@"%@",_storeStockList.userInfo.strFirstName];
        _lbDifference.textColor=[UIColor colorWithRed:150.0/255 green:170.0/255 blue:20.0/255 alpha:1];
        _viewLine.hidden=NO;
        _ivWarn.hidden=YES;
        if (_lbDifference.text.intValue==0)
        {
            _ivTag.image=[UIImage imageNamed:@"icon_sign@2x.png"];//平账
        }
        else
        {
            _ivTag.image=[UIImage imageNamed:@"icon_warn_white@2x.png"];//不平账
        }
    }
}
-(void)handleSwipeRight:(UISwipeGestureRecognizer*)recognizer
{
    if (_storeSelected==nil)
    {
        [SVProgressHUD showErrorWithStatus:NSLocalizedStringFromTableInBundle(@"No Store Selected",@"RPString", g_bundleResorce,nil)];
        return;
    }
    
    if (_sn==1)
    {
        return;
    }
    _sn=_sn-1;
    _isLatest=NO;
    _isQuery=NO;
    [self loadData];
    
    _lbPrevious.frame=CGRectMake(20-320, _lbPrevious.frame.origin.y, _lbPrevious.frame.size.width, _lbPrevious.frame.size.height);
    _lbInOut.frame=CGRectMake(96-320, _lbInOut.frame.origin.y, _lbInOut.frame.size.width, _lbInOut.frame.size.height);
    _lbCurrentStock.frame=CGRectMake(172-320, _lbCurrentStock.frame.origin.y, _lbCurrentStock.frame.size.width, _lbCurrentStock.frame.size.height);
    [UIView beginAnimations:nil context:nil];
    _lbPrevious.frame=CGRectMake(20, _lbPrevious.frame.origin.y, _lbPrevious.frame.size.width, _lbPrevious.frame.size.height);
    _lbInOut.frame=CGRectMake(96, _lbInOut.frame.origin.y, _lbInOut.frame.size.width, _lbInOut.frame.size.height);
    _lbCurrentStock.frame=CGRectMake(172, _lbCurrentStock.frame.origin.y, _lbCurrentStock.frame.size.width, _lbCurrentStock.frame.size.height);
    [UIView commitAnimations];
}
//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    _btCurrent.userInteractionEnabled=NO;
//    _btInOut.userInteractionEnabled=NO;
//    _btLast.userInteractionEnabled=NO;
//    _btShowSearch.userInteractionEnabled=NO;
//}
//-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    _btCurrent.userInteractionEnabled=YES;
//    _btInOut.userInteractionEnabled=YES;
//    _btLast.userInteractionEnabled=YES;
//    _btShowSearch.userInteractionEnabled=YES;
//}
-(void)loadSearchData
{
    [[RPSDK defaultInstance]GetStoreStock:_storeSelected.strStoreId SN:0 IsLatest:NO IsQuery:YES Query:_tfSearch.text Success:^(NSMutableArray * arrayResult) {
        _arrayStoreStock=arrayResult;
        [_tbSearch reloadData];
    } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
        
    }];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)OnActive
{
    
}
-(void)viewDidAppear:(BOOL)animated
{
    if (_tag==-1)//如果是从店铺进入该功能
    {
        _lbBrandName.text=_storeSelected.strBrandName;
        _lbStoreName.text=_storeSelected.strStoreName;
        //    _btSelectStore.titleLabel.text=@"";
        [_btSelectStore setTitle:@"" forState:UIControlStateNormal];
        _sn=0;
        _isLatest=YES;
        _isQuery=NO;
        [self loadData];
        
    }
    else
    {
        if (_bInAppear)
        {
            //延时函数：
            [NSThread sleepForTimeInterval:0.3]; //暂停0.5s.
            [self OnSelectStore:nil];
        }
    }
    
    
}
-(void)setStoreSelected:(StoreDetailInfo *)storeSelected
{
    _storeSelected=storeSelected;
    
}
-(IBAction)OnNewCount:(id)sender
{
    if (_storeSelected==nil)
    {
        [SVProgressHUD showErrorWithStatus:NSLocalizedStringFromTableInBundle(@"No Store Selected",@"RPString", g_bundleResorce,nil)];
        return;
    }
    
    _vcNewCount = [[RPDSNewCountViewController alloc] initWithNibName:NSStringFromClass([RPDSNewCountViewController class]) bundle:g_bundleResorce];
    _vcNewCount.delegate = self.delegate;
    _vcNewCount.delegateNewCount=self;
    _vcNewCount.vcFrame=self.vcFrame;
    _vcNewCount.storeSelected=_storeSelected;
    _vcNewCount.sn=_snSum;
    [self.navigationController pushViewController:_vcNewCount animated:YES];
    
    _viewMenu.hidden=YES;
    _bInAppear=NO;
}

//显示或隐藏tableview
-(void)showOrHiddenTB
{
    if (_tbReport.bShowCurrentStock||_tbReport.bShowInOutStock||_tbReport.bShowLastStock)
    {
        _tbReport.hidden=NO;
    }
    else
    {
        _tbReport.hidden=YES;
    }
}

- (IBAction)OnCurrentCounting:(id)sender {
    _btCurrent.selected=!_btCurrent.selected;
    if (_btCurrent.selected)
    {
        _lbCurrent.textColor= [UIColor whiteColor];
    }
    else
    {
        _lbCurrent.textColor=[UIColor colorWithRed:55.0/255 green:115.0/255 blue:120.0/255 alpha:1];
    }
    _tbReport.bShowCurrentStock = !_tbReport.bShowCurrentStock;
    _viewMenu.hidden=YES;
    _tbReport.hidden=NO;
    [self showOrHiddenTB];
}

- (IBAction)OnIO:(id)sender {
    _btInOut.selected=!_btInOut.selected;
    if (_btInOut.selected)
    {
        _ivIn.image=[UIImage imageNamed:@"image_io_plus_@2x.png"];
        _ivOut.image=[UIImage imageNamed:@"image_io_minus_@2x.png"];
        _lbIn.textColor=[UIColor whiteColor];
        _lbOut.textColor=[UIColor whiteColor];
    }
    else
    {
        _ivIn.image=[UIImage imageNamed:@"image_io_plus@2x.png"];
        _ivOut.image=[UIImage imageNamed:@"image_io_minus@2x.png"];
        _lbIn.textColor=[UIColor colorWithRed:83.0/255 green:152.0/255 blue:201.0/255 alpha:1];
        _lbOut.textColor=[UIColor colorWithRed:200.0/255 green:70.0/255 blue:55.0/255 alpha:1];
    }
    _tbReport.bShowInOutStock = !_tbReport.bShowInOutStock;
    _viewMenu.hidden=YES;
    _tbReport.hidden=NO;
    [self showOrHiddenTB];
}

- (IBAction)OnLastTime:(id)sender {
    _btLast.selected=!_btLast.selected;
    if (_btLast.selected)
    {
        _lbLast.textColor= [UIColor whiteColor];
    }
    else
    {
        _lbLast.textColor=[UIColor colorWithWhite:0.4 alpha:1];
    }
    _tbReport.bShowLastStock = !_tbReport.bShowLastStock;
    _viewMenu.hidden=YES;
    _tbReport.hidden=NO;
    [self showOrHiddenTB];
}

- (IBAction)OnShowButton:(id)sender
{
    _viewMenu.hidden=!_viewMenu.hidden;
}

- (IBAction)OnAddRecord:(id)sender
{
    if (_storeSelected==nil)
    {
        [SVProgressHUD showErrorWithStatus:NSLocalizedStringFromTableInBundle(@"No Store Selected",@"RPString", g_bundleResorce,nil)];
        return;
    }
    
    _vcAddRecord=[[RPAddRecordViewController alloc]initWithNibName:NSStringFromClass([RPAddRecordViewController class]) bundle:g_bundleResorce];
    _vcAddRecord.delegate=self.delegate;
    _vcAddRecord.delegateAddRecord=self;
    _vcAddRecord.vcFrame=self.vcFrame;
    _vcAddRecord.sn=_snSum;
    _vcAddRecord.storeSelected=_storeSelected;
    [self.navigationController pushViewController:_vcAddRecord animated:YES];
    
    _viewMenu.hidden=YES;
    _bInAppear=NO;
}

- (IBAction)OnFinish:(id)sender
{
    if ([RPRights hasRightsFunc:_storeSelected.llRights type:RPRightsFuncType_DailyStockMng])
    {
    
        if (_storeSelected==nil)
        {
            [SVProgressHUD showErrorWithStatus:NSLocalizedStringFromTableInBundle(@"No Store Selected",@"RPString", g_bundleResorce,nil)];
            return;
        }
        UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
        if (_sn==_snSum)
        {
            
            _viewFinish.frame = keywindow.frame;
            [keywindow addSubview:_viewFinish];
            if (_lbDifference.text.intValue==0)
            {
                [_viewFinish OnShow2];//平账
            }
            else
            {
                [_viewFinish OnShow1];//不平账
            }
            _viewFinish.storeSelected=_storeSelected;
            _viewFinish.sn=_sn;
            _viewFinish.delegate=self;
        }
        else
        {
            if (_lbDifference.text.intValue!=0)
            {
                _viewReason.frame = keywindow.frame;
                [keywindow addSubview:_viewReason];
                _viewReason.tvReason.text=_storeStockList.strComments;
            }
            
        }
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:NSLocalizedStringFromTableInBundle(@"You do not have the authority to do this task",@"RPString", g_bundleResorce,nil)];
    }
}

- (IBAction)OnQuit:(id)sender
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

- (IBAction)OnSelectStore:(id)sender
{
    _viewStoreList.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
    _viewStoreList.tfSearch.text=@"";
    [self.view addSubview:_viewStoreList];
    [UIView beginAnimations:nil context:nil];
    _viewStoreList.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
    _bStoreList=YES;
    [_viewStoreList reloadStore];
}


-(IBAction)OnShowHideThumb:(id)sender
{
    NSInteger nOffsetShowHide = 94;
    
    [UIView beginAnimations:nil context:nil];
    
    if (_bHideMode)
    {
        _viewThumbFrame.frame = CGRectMake(_viewThumbFrame.frame.origin.x, _viewThumbFrame.frame.origin.y + nOffsetShowHide, _viewThumbFrame.frame.size.width, _viewThumbFrame.frame.size.height);
        _viewReportFrame.frame = CGRectMake(_viewReportFrame.frame.origin.x, _viewReportFrame.frame.origin.y + nOffsetShowHide, _viewReportFrame.frame.size.width, _viewReportFrame.frame.size.height - nOffsetShowHide);
    }
    else
    {
        _viewThumbFrame.frame = CGRectMake(_viewThumbFrame.frame.origin.x, _viewThumbFrame.frame.origin.y - nOffsetShowHide, _viewThumbFrame.frame.size.width, _viewThumbFrame.frame.size.height);
        _viewReportFrame.frame = CGRectMake(_viewReportFrame.frame.origin.x, _viewReportFrame.frame.origin.y - nOffsetShowHide, _viewReportFrame.frame.size.width, _viewReportFrame.frame.size.height + nOffsetShowHide);
    }
    
    if (_timerShowHide) {
        [_timerShowHide invalidate];
    }
    
    
    _btShowHide.frame = CGRectMake(_btShowHide.frame.origin.x, _viewThumbFrame.frame.origin.y +_viewThumbFrame.frame.size.height - _btShowHide.frame.size.height, _btShowHide.frame.size.width, _btShowHide.frame.size.height);
        
    [UIView commitAnimations];
        
    _bHideMode = !_bHideMode;
}

-(void)OnScrollReportTable:(BOOL)bUp
{
    if (bUp) {
        [_btShowHide setImage:[UIImage imageNamed:@"button_moveup.png"] forState:UIControlStateNormal];
    }
    else
    {
        [_btShowHide setImage:[UIImage imageNamed:@"button_movedown.png"] forState:UIControlStateNormal];
    }
    
    BOOL bShow = NO;
    if (_bHideMode && !bUp)
        bShow = YES;
    if (!_bHideMode && bUp)
        bShow = YES;
    
    [UIView beginAnimations:nil context:nil];
    
    if (_timerShowHide) {
        [_timerShowHide invalidate];
    }
    
    if (bShow)
    {
        _btShowHide.frame = CGRectMake(_btShowHide.frame.origin.x, _viewThumbFrame.frame.origin.y + _viewThumbFrame.frame.size.height, _btShowHide.frame.size.width, _btShowHide.frame.size.height);
        _timerShowHide = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(onShowHideTimer) userInfo:nil repeats:NO];
    }
    else
        _btShowHide.frame = CGRectMake(_btShowHide.frame.origin.x, _viewThumbFrame.frame.origin.y +_viewThumbFrame.frame.size.height - _btShowHide.frame.size.height, _btShowHide.frame.size.width, _btShowHide.frame.size.height);
    
    [UIView commitAnimations];
}

-(void)OnDeleteCurrentCount:(NSString *)strCountId UserId:(NSString *)userId
{
    if ([userId isEqualToString:[RPSDK defaultInstance].userLoginDetail.strUserId]||[RPRights hasRightsFunc:[RPSDK defaultInstance].llRights type:RPRightsFuncType_DailyStockMng])
    
    {
        [[RPSDK defaultInstance]DeleteStockDetail:strCountId Type:@"count" Success:^(id idResult) {
            [SVProgressHUD showSuccessWithStatus:NSLocalizedStringFromTableInBundle(@"Successfully deleted",@"RPString", g_bundleResorce,nil)];
            _sn=0;
            _isLatest=YES;
            _isQuery=NO;
            [self loadData];
        } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
            [SVProgressHUD showErrorWithStatus:NSLocalizedStringFromTableInBundle(@"Delete failed",@"RPString", g_bundleResorce,nil)];
        }];
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:NSLocalizedStringFromTableInBundle(@"You do not have the authority to do this task",@"RPString", g_bundleResorce,nil)];
    }
}
-(void)OnDeleteIOCount:(NSString *)strCountId Type:(NSInteger)type UserId:(NSString *)userId
{
    if ([userId isEqualToString:[RPSDK defaultInstance].userLoginDetail.strUserId]||[RPRights hasRightsFunc:[RPSDK defaultInstance].llRights type:RPRightsFuncType_DailyStockMng])
        
    {
        NSString *s=[[NSString alloc]init];
        if (type==1)
        {
            s=@"in";
        }
        else
        {
            s=@"out";
        }
        [[RPSDK defaultInstance]DeleteStockDetail:strCountId Type:s Success:^(id idResult) {
            [SVProgressHUD showSuccessWithStatus:NSLocalizedStringFromTableInBundle(@"Successfully deleted",@"RPString", g_bundleResorce,nil)];
            _sn=0;
            _isLatest=YES;
            _isQuery=NO;
            [self loadData];
        } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
            [SVProgressHUD showErrorWithStatus:NSLocalizedStringFromTableInBundle(@"Delete failed",@"RPString", g_bundleResorce,nil)];
        }];
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:NSLocalizedStringFromTableInBundle(@"You do not have the authority to do this task",@"RPString", g_bundleResorce,nil)];
    }
}
- (void)onShowHideTimer
{
    [UIView beginAnimations:nil context:nil];
    
    _btShowHide.frame = CGRectMake(_btShowHide.frame.origin.x, _viewThumbFrame.frame.origin.y +_viewThumbFrame.frame.size.height - _btShowHide.frame.size.height, _btShowHide.frame.size.width, _btShowHide.frame.size.height);
    
    [UIView commitAnimations];
}

-(void)dismissView:(UIView *)view
{
    [UIView beginAnimations:nil context:nil];
    view.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
    [view endEditing:YES];
}

-(void)OnSelectedStore:(StoreDetailInfo *)store
{
    [self dismissView:_viewStoreList];
    _bStoreList=NO;
    _storeSelected = store;
    _lbBrandName.text=_storeSelected.strBrandName;
    _lbStoreName.text=_storeSelected.strStoreName;
//    _btSelectStore.titleLabel.text=@"";
    [_btSelectStore setTitle:@"" forState:UIControlStateNormal];
    _sn=0;
    _isLatest=YES;
    _isQuery=NO;
    [self loadData];
    
}
-(NSString *)ThumbStringFromInterger:(NSInteger)nCount
{
//    if (nCount > 10000)
//    {
//        float f = (float)nCount / 10000;
//        return [NSString stringWithFormat:@"%0.1fM",f];
//    }
    
    if (nCount >= 10000)
    {
        float f = (float)nCount / 1000;
        return [NSString stringWithFormat:@"%0.1fK",f];
    }
    
    return [NSString stringWithFormat:@"%d",nCount];
}
-(void)loadData
{
//    if (_tfSearch.text==nil)
//    {
        _tfSearch.text=@"";
//    }
    NSString * strDesc = NSLocalizedStringFromTableInBundle(@"",@"RPString", g_bundleResorce,nil);
    [SVProgressHUD showWithStatus:strDesc];
    [[RPSDK defaultInstance]GetStoreStock:_storeSelected.strStoreId SN:_sn IsLatest:_isLatest IsQuery:_isQuery Query:@"" Success:^(NSMutableArray * arrayResult) {
        [SVProgressHUD dismiss];
        _storeStockList=[arrayResult objectAtIndex:0];
        _sn=_storeStockList.SN;
        
//        _lbLast.text=[NSString stringWithFormat:@"%i",_storeStockList.lastAmount];
//        _lbIn.text=[NSString stringWithFormat:@"%i",_storeStockList.inAmount];
//        _lbOut.text=[NSString stringWithFormat:@"%i",_storeStockList.outAmount];
//        _lbCurrent.text=[NSString stringWithFormat:@"%i",_storeStockList.countAmount];
        
        _lbLast.text=[self ThumbStringFromInterger:_storeStockList.lastAmount];

        _lbIn.text=[self ThumbStringFromInterger:_storeStockList.inAmount];

        _lbOut.text=[self ThumbStringFromInterger:_storeStockList.outAmount];

        _lbCurrent.text=[self ThumbStringFromInterger:_storeStockList.countAmount];

        NSInteger difference=_storeStockList.countAmount-(_storeStockList.lastAmount+_storeStockList.inAmount-_storeStockList.outAmount);
        _lbDifference.text=[NSString stringWithFormat:@"%i",difference];
        
        if (_isLatest)
        {
            _snSum=_storeStockList.SN;
//            _lbCurrentDate.text=NSLocalizedStringFromTableInBundle(@"CURRENT",@"RPString", g_bundleResorce,nil);
            _lbCurrentCount.text=[NSString stringWithFormat:@"%i",_storeStockList.countAmount];
            _lbCurrentDif.text=_lbDifference.text;
            if (difference==0)
            {
                _ivYes.hidden=NO;
                _lbCurrentDif.hidden=YES;
            }
            else
            {
                _ivYes.hidden=YES;
                _lbCurrentDif.hidden=NO;
            }
            
        }
        
        if (_sn==1)
        {
            _ivLeft.hidden=YES;
        }
        else
        {
            _ivLeft.hidden=NO;
        }
        if (_sn==_snSum)
        {
            _ivRight.hidden=YES;
        }
        else
        {
            _ivRight.hidden=NO;
        }
        
        [self loadDetail];
        
        if (_sn==_snSum)
        {
            [self changeColor:YES];
        }
        else
        {
            [self changeColor:NO];
        }
        
    } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
        [SVProgressHUD showErrorWithStatus:NSLocalizedStringFromTableInBundle(@"failure",@"RPString", g_bundleResorce,nil)];
    }];
    
    
}

-(void)loadDetail
{
    [SVProgressHUD showWithStatus:@""];
    [[RPSDK defaultInstance]GetStoreStockDetail:_storeSelected.strStoreId SN:_sn Success:^(NSMutableArray *array) {
        _arrayDSDetail=array;
        _tbReport.arrayStockDetail=_arrayDSDetail;
        [_tbReport reloadData];
        [SVProgressHUD dismiss];
    } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
        [SVProgressHUD showErrorWithStatus:NSLocalizedStringFromTableInBundle(@"failure",@"RPString", g_bundleResorce,nil)];
    }];
}
-(BOOL)OnBack
{
    if (_bStoreList)
    {
        [self dismissView:_viewStoreList];
        _bStoreList=NO;
        return NO;
    }
    else
    {
        return YES;
    }
}

- (IBAction)OnShowSearchView:(id)sender
{
    if (_storeSelected==nil)
    {
        [SVProgressHUD showErrorWithStatus:NSLocalizedStringFromTableInBundle(@"No Store Selected",@"RPString", g_bundleResorce,nil)];
        return;
    }
    
    _viewMenu.hidden=YES;
    _btShowSearch.selected=!_btShowSearch.selected;
    if (_btShowSearch.selected)
    {
        [UIView beginAnimations:nil context:nil];
        _viewLeft.frame=CGRectMake(_viewLeft.frame.origin.x-236, _viewLeft.frame.origin.y, _viewLeft.frame.size.width, _viewLeft.frame.size.height);
        [UIView commitAnimations];
        [self loadSearchData];
    }
    else
    {
        [UIView beginAnimations:nil context:nil];
        _viewLeft.frame=CGRectMake(_viewLeft.frame.origin.x+236, _viewLeft.frame.origin.y, _viewLeft.frame.size.width, _viewLeft.frame.size.height);
        [UIView commitAnimations];
    }
    
}

- (IBAction)OnDeleteSearch:(id)sender
{
    _tfSearch.text=@"";
    [self loadSearchData];
}

- (IBAction)OnCurrent:(id)sender
{
    _sn=0;
    _isLatest=YES;
    _isQuery=NO;
    [self loadData];
    [self OnShowSearchView:nil];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RPStockSearchCell *cell=[tableView dequeueReusableCellWithIdentifier:@"RPStockSearchCell"];
    if (cell==nil)
    {
        NSArray *arrayNib=[[NSBundle mainBundle]loadNibNamed:@"RPStockSearchCell" owner:self options:nil];
        cell=[arrayNib objectAtIndex:0];
    }
    cell.storeStockList=[_arrayStoreStock objectAtIndex:indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _sn=((StoreStockList *)[_arrayStoreStock objectAtIndex:indexPath.row]).SN;
    _isLatest=NO;
    _isQuery=NO;
    [self loadData];
    [self OnShowSearchView:nil];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 38;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _arrayStoreStock.count;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [self loadSearchData];
}

-(void)endCount
{
    _sn=0;
    _isLatest=YES;
    _isQuery=NO;
    [self loadData];
}
-(void)endAddRecord
{
    _sn=0;
    _isLatest=YES;
    _isQuery=NO;
    [self loadData];
}
-(void)endFinish
{
    _sn=0;
    _isLatest=YES;
    _isQuery=NO;
    [self loadData];
}

- (IBAction)OnHelp:(id)sender
{
    [RPGuide ShowGuide:self.view];
}
@end
