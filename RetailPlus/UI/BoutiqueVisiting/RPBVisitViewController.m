//
//  RPBVisitViewController.m
//  RetailPlus
//
//  Created by zhanglinfeng on 14-2-26.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPBVisitViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImageView+WebCache.h"
#import "SVProgressHUD.h"
#import "RPBlockUIAlertView.h"
extern NSBundle * g_bundleResorce;
@interface RPBVisitViewController ()

@end

@implementation RPBVisitViewController
@synthesize storeSelected = _storeSelected;
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
    NSArray *array = [g_bundleResorce loadNibNamed:@"CustomView" owner:self options:nil];
    _viewStoreList = [array objectAtIndex:1];
    _viewStoreList.delegate = self;
    _viewStoreList.sitType = SituationType_BVisit;
    
    self.strTaskName = NSLocalizedStringFromTableInBundle(@"BOUTIQUE VISIT",@"RPString", g_bundleResorce,nil);
    
    _step = BVISITSTEP_STOREDETAIL;
    
    _viewTemplate.vcFrame = self.vcFrame;
    _viewTemplate.delegate=self;
    array = [g_bundleResorce loadNibNamed:@"RPStoreCardView" owner:self options:nil];
    _viewStoreCard = [array objectAtIndex:0];
    CGSize szScreen = [[UIScreen mainScreen] bounds].size;
    _viewStoreCard.frame = CGRectMake(8, 15, 304, szScreen.height - 125);
    _viewStoreCard.delegate = self;
    [self.view insertSubview:_viewStoreCard belowSubview:_viewBottom];
    [_viewStoreCard Hide:YES];
    
    _bModified = NO;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)OnTemplateVisitEnd:(NSString *)reportId
{
    [self dismissView:_viewTemplate];
    _step = BVISITSTEP_STOREDETAIL;
    _bConfirmQuit = YES;
    if (reportId.length<1) {
        [self.delegate OnTaskEnd];
    }
    else
    {
        NSString * strOK = NSLocalizedStringFromTableInBundle(@"OK",@"RPString", g_bundleResorce,nil);
        NSString *strCancel=NSLocalizedStringFromTableInBundle(@"CANCEL",@"RPString", g_bundleResorce,nil);
        NSString * strDesc = NSLocalizedStringFromTableInBundle(@"Assign tasks at once?",@"RPString", g_bundleResorce,nil);
        RPBlockUIAlertView *alertView=[[RPBlockUIAlertView alloc]initWithTitle:nil message:strDesc cancelButtonTitle:strCancel clickButton:^(NSInteger indexButton) {
            if (indexButton==1) {
                [self dismissView:_viewTemplate];
                _bConfirmQuit=NO;
                _viewDistributionList.frame = CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height);
                
                [self.view addSubview:_viewDistributionList];
                //    _viewDistributionList.vcFrame=self.vcFrame;
                //    _viewDistributionList.delegate=self;
                [UIView beginAnimations:nil context:nil];
                _viewDistributionList.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
                [UIView commitAnimations];
                _viewDistributionList.reportId=reportId;
                _step=BVISITSTEP_TASK;
            }
            else
            {
                [self.delegate OnTaskEnd];
            }
        }otherButtonTitles:strOK, nil];
        [alertView show];
    }
   
    
}
//-(void)OnGoTask:(NSString *)reportId
//{
//    [self dismissView:_viewTemplate];
//    _viewDistributionList.frame = CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height);
//    
//    [self.view addSubview:_viewDistributionList];
////    _viewDistributionList.vcFrame=self.vcFrame;
////    _viewDistributionList.delegate=self;
//    [UIView beginAnimations:nil context:nil];
//    _viewDistributionList.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
//    [UIView commitAnimations];
//    _step=BVISITSTEP_TASK;
//}
//-(void)OnTask:(NSString *)reportId
//{
//    [self dismissView:_viewDetail];
//    _viewDistributionList.frame = CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height);
//    
//    [self.view addSubview:_viewDistributionList];
//    //    _viewDistributionList.vcFrame=self.vcFrame;
//    //    _viewDistributionList.delegate=self;
//    [UIView beginAnimations:nil context:nil];
//    _viewDistributionList.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
//    [UIView commitAnimations];
//    _step=BVISITSTEP_TASK;
//}
-(void)OnIssueTrackEnd
{
    _step = BVISITSTEP_STOREDETAIL;
    _bConfirmQuit = YES;
    [self.delegate OnTaskEnd];
}
-(void)OnVisitEnd:(NSString *)reportId
{
    [self dismissView:_viewDetail];
    [self OnTemplateVisitEnd:reportId];
}
-(void)setStoreSelected:(StoreDetailInfo *)storeSelected
{   _storeSelected = storeSelected;
    [self OnSelectedStore:storeSelected];
}

-(void)OnSelectedStore:(StoreDetailInfo *)store
{
    [self dismissView:_viewStoreList];
    _step = BVISITSTEP_STOREDETAIL;
    
//    if ([store.strStoreId isEqualToString:_storeSelected.strStoreId]) return;
    
    _storeSelected = store;
    _dataVisit = [[BVisitData alloc] init];
    _dataVisit.nStatus=1;
    _dataVisit.arrayMap = store.arrayShopMap;
    _viewStoreCard.store = _storeSelected;
    
    _dataVisit.reporters = [[InspReporters alloc] init];
    
    _dataVisit.reporters.arraySection = [[NSMutableArray alloc] init];
    InspReporterSection * section = [[InspReporterSection alloc] init];
    
    section.strTitle1 = [NSString stringWithFormat:@"Visiting Report:%@ %@",store.strBrandName,store.strStoreName];
    
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"dd-MM-yyyy"];
    section.strTitle2 = [NSString stringWithFormat:@"%@,by %@",[dateformatter stringFromDate:[NSDate date]],[RPSDK defaultInstance].userLoginDetail.strFirstName];
    section.arrayUser = [[NSMutableArray alloc] init];
    [_dataVisit.reporters.arraySection addObject:section];
    
    [SVProgressHUD showWithStatus:@""];
    [[RPSDK defaultInstance] GetReportToUser:ReportToUserSaveType_BVisit VendorId:@"" Success:^(NSMutableArray * arrayUser) {
        if (arrayUser.count > 0) {
            section.arrayUser = arrayUser;
        }
        else
        {
//            InspReporterUser * user = [[InspReporterUser alloc] init];
//            user.bSelected = YES;
//            user.bUserCollegue = YES;
//            user.collegue = [RPSDK defaultInstance].userLoginDetail;
//            [section.arrayUser addObject:user];
        }
        [SVProgressHUD dismiss];
    } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
//        InspReporterUser * user = [[InspReporterUser alloc] init];
//        user.bSelected = YES;
//        user.bUserCollegue = YES;
//        user.collegue = [RPSDK defaultInstance].userLoginDetail;
//        [section.arrayUser addObject:user];
        [SVProgressHUD dismiss];
    }];

}

//-(IBAction)OnSelectStore:(id)sender
//{
//    _viewStoreList.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
//    [self.view insertSubview:_viewStoreList belowSubview:_viewBottom];
//    
//    [UIView beginAnimations:nil context:nil];
//    _viewStoreList.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
//    [UIView commitAnimations];
//    
//    [_viewStoreList reloadStore];
//    
//    _step = BVISITSTEP_SELECTSHOP;
//}

-(void)ShowDetail
{
    _viewTemplate.storeSelected = _storeSelected;
    _viewTemplate.dataVisit = _dataVisit;
    
    _viewTemplate.frame = CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    [self.view addSubview:_viewTemplate];
    
    [UIView beginAnimations:nil context:nil];
    _viewTemplate.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
    
    _step = BVISITSTEP_TEMPLATE;
    _bModified=YES;
}

-(IBAction)OnInspDetail:(id)sender
{
    if (_storeSelected == nil) {
        [SVProgressHUD showErrorWithStatus:NSLocalizedStringFromTableInBundle(@"No Store Selected",@"RPString", g_bundleResorce,nil)];
        return;
    }
    [self OnSelectedStore:_storeSelected];
    [self ShowDetail];
//    BVisitData * data = [[RPSDK defaultInstance] GetTaskCacheData:_storeSelected.strStoreId CacheType:CACHETYPE_BVISITING];
//    if (data)
//    {
//        NSString * strDesc = NSLocalizedStringFromTableInBundle(@"Existing cache,if you continue, the cache will be empty",@"RPString", g_bundleResorce,nil);
//        NSString * strOK = NSLocalizedStringFromTableInBundle(@"CONTINUE",@"RPString", g_bundleResorce,nil);
//        NSString * strCancel = NSLocalizedStringFromTableInBundle(@"CANCEL",@"RPString", g_bundleResorce,nil);
//        
//        RPBlockUIAlertView *alertView = [[RPBlockUIAlertView alloc] initWithTitle:nil message:strDesc cancelButtonTitle:strCancel clickButton:^(NSInteger indexButton){
//            if (indexButton == 1)
//            {
//                [[RPSDK defaultInstance]ClearCacheData:_storeSelected.strStoreId CacheType:CACHETYPE_BVISITING];
//                [self ShowDetail];
//            }
//        } otherButtonTitles:strOK,nil];
//        [alertView show];
//    }
//    else
//    {
//        [self ShowDetail];
//    }
    
}

-(void)dismissView:(UIView *)view
{
    [UIView beginAnimations:nil context:nil];
    view.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
    [view endEditing:YES];
}

-(BOOL)OnBack
{
    [SVProgressHUD dismiss];
    if (_bConfirmQuit) {
        return YES;
    }
    
    switch (_step)
    {
        case BVISITSTEP_TEMPLATE:
            if ([_viewTemplate OnBack])
            {
                [self dismissView:_viewTemplate];
                _step = BVISITSTEP_STOREDETAIL;
            }
            break;
        case BVISITSTEP_SELECTSHOP:
            [_viewStoreList dismiss];
            [self dismissView:_viewStoreList];
            _step = BVISITSTEP_STOREDETAIL;
            break;
        case BVISITSTEP_DETAIL:
            if ([_viewDetail OnBack]) {
                [self dismissView:_viewDetail];
                _step = BVISITSTEP_STOREDETAIL;
            }
            break;
        case BVISITSTEP_HISTORY:
            [self dismissView:_viewHistory];
            _step = BVISITSTEP_STOREDETAIL;
            break;
        case BVISITSTEP_ISSUETRACK:
            if ([_viewIssueTrack OnBack])
            {
                [self dismissView:_viewIssueTrack];
                _step = BVISITSTEP_STOREDETAIL;
            }
            break;
        case BVISITSTEP_TASK:
            if ([_viewDistributionList OnBack])
            {
                [self dismissView:_viewDistributionList];
                _step = BVISITSTEP_STOREDETAIL;
            }
            break;
        default:
        {
            if (!_bModified)
            {
                _bConfirmQuit = YES;
                [self.delegate OnTaskEnd];
            }
            else
            {
//                NSString * strDesc = NSLocalizedStringFromTableInBundle(@"Current data will be erased!\r\nConfirm to exit Boutique Visit?",@"RPString", g_bundleResorce,nil);
//                NSString * strOK = NSLocalizedStringFromTableInBundle(@"OK",@"RPString", g_bundleResorce,nil);
//                NSString * strCancel = NSLocalizedStringFromTableInBundle(@"CANCEL",@"RPString", g_bundleResorce,nil);
//                
//                RPBlockUIAlertView *alertView = [[RPBlockUIAlertView alloc] initWithTitle:nil message:strDesc cancelButtonTitle:strCancel clickButton:^(NSInteger indexButton){
//                    if (indexButton == 1)
//                    {
                        _bConfirmQuit = YES;
                        [self.delegate OnTaskEnd];
//                    }
//                } otherButtonTitles:strOK,nil];
//                [alertView show];
            }
        }
            return NO;
            break;
    };
    return NO;
}
//-(void)OnVisitEnd
//{
//    [self dismissView:_viewDetail];
//    _step = BVISITSTEP_STOREDETAIL;
//    _bConfirmQuit = YES;
//    [self.delegate OnTaskEnd];
//}

-(void)OnSelectStore
{
    _viewStoreList.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
    _viewStoreList.tfSearch.text=@"";
    [self.view insertSubview:_viewStoreList belowSubview:_viewBottom];
    
    [UIView beginAnimations:nil context:nil];
    _viewStoreList.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
    
    [_viewStoreList reloadStore];
    
    _step = BVISITSTEP_SELECTSHOP;
}

- (IBAction)OnHelp:(id)sender
{
    [RPGuide ShowGuide:self.view];
}

-(void)continueVisit:(NSString *)strCacheDataId
{
    BVisitData * data = [[RPSDK defaultInstance] GetTaskCacheDataById:strCacheDataId CacheType:CACHETYPE_BVISITING];
    if (data) {
        data.arrayMap=_dataVisit.arrayMap;
        data.reporters = _dataVisit.reporters;
        _dataVisit = data;
        
        _viewDetail.dataVisit=_dataVisit;
        _viewDetail.storeSelected=_storeSelected;
        _viewDetail.frame = CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height);
        
        [self.view addSubview:_viewDetail];
        _viewDetail.vcFrame=self.vcFrame;
        _viewDetail.delegate=self;
        _viewDetail.strCacheDataId = strCacheDataId;
        
        [UIView beginAnimations:nil context:nil];
        _viewDetail.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        [UIView commitAnimations];
        
        _step = BVISITSTEP_DETAIL;
    }
    else
    {
        NSString * strDesc = NSLocalizedStringFromTableInBundle(@"This store have no unfinished report",@"RPString", g_bundleResorce,nil);
        [SVProgressHUD showErrorWithStatus:strDesc];
    }
    
}
- (IBAction)OnContinue:(id)sender
{
    _viewHistory.frame = CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:_viewHistory];
    
    [UIView beginAnimations:nil context:nil];
    _viewHistory.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    _viewHistory.delegate = self;
    _viewHistory.storeSelected=_storeSelected;
    [_viewHistory ReloadMyUnfinishData];
    [_viewHistory reloadOtherUnfinishData];
    [UIView commitAnimations];
    
    _step = BVISITSTEP_HISTORY;
    
//    if (_storeSelected == nil) {
//        [SVProgressHUD showErrorWithStatus:NSLocalizedStringFromTableInBundle(@"No Store Selected",@"RPString", g_bundleResorce,nil)];
//        return;
//    }
//    [self continueVisit];
}

- (IBAction)OnIssueTrack:(id)sender
{

    _viewIssueTrack.frame = CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height);
    _viewIssueTrack.delegate=self;
    [self.view addSubview:_viewIssueTrack];
    
    [UIView beginAnimations:nil context:nil];
    _viewIssueTrack.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
    [_viewIssueTrack clearUI];
    _step = BVISITSTEP_ISSUETRACK;
}

-(void)OnHistoryQuit
{
    [self dismissView:_viewHistory];
    _step = BVISITSTEP_STOREDETAIL;
    _bConfirmQuit = YES;
    [self.delegate OnTaskEnd];
}

-(void)OnSelectCacheData:(NSString *)strCacheDataId store:(StoreDetailInfo *)store
{
    [self dismissView:_viewHistory];
    _step = BVISITSTEP_STOREDETAIL;
    [self OnSelectedStore:store];
    [self continueVisit:strCacheDataId];
}
//进入编辑收到的未完成报告界面
-(void)OnEditOtherReport:(BVisitListModel *)bVisitModel Store:(StoreDetailInfo *)storeInfo
{
    [self dismissView:_viewHistory];
    _step = BVISITSTEP_STOREDETAIL;
    [self OnSelectedStore:storeInfo];
    
    _dataVisit = bVisitModel.bVisitData;
    _dataVisit.nStatus=1;
    _viewDetail.dataVisit = _dataVisit;
//    _viewDetail.dataVisit=[self BVisitListModelToBVisitData:bVisitModel];
    _viewDetail.storeSelected=_storeSelected;
    _viewDetail.frame = CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    [self.view addSubview:_viewDetail];
    _viewDetail.vcFrame=self.vcFrame;
    _viewDetail.delegate=self;
    
    _viewDetail.strCacheDataId = [[RPSDK defaultInstance] SaveBVisitCacheData:_storeSelected.strStoreId Desc:_storeSelected.strStoreName Data:_dataVisit isNormalExit:YES];
    
    [UIView beginAnimations:nil context:nil];
    _viewDetail.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
    
    _step = BVISITSTEP_DETAIL;
}
//用BVisitListModel的数据拼凑出BVisitData得结构，以供继续编辑他人的零售巡店
//-(BVisitData *)BVisitListModelToBVisitData:(BVisitListModel *)bVisitModel
//{
//    BVisitData *dataVisit=[[BVisitData alloc]init];
//    dataVisit.strSourceReportId=bVisitModel.strReportId;
//    dataVisit.strTemplateId=bVisitModel.strTemplateId;
//    dataVisit.strTemplateName=bVisitModel.strTemplateName;
//    dataVisit.strTemplateDesc=bVisitModel.strTemplateDesc;
//    dataVisit.strCategoryTag=bVisitModel.strCategoryTag;
//    dataVisit.arrayCatagory=[[NSMutableArray alloc]init];
//        //先加一个分类再说
//        BVisitCategory *bVisitCategory=[[BVisitCategory alloc]init];
//        bVisitCategory.strCategoryName=((BVisitIssueData*)[bVisitModel.BVisitData.arrayIssuesData objectAtIndex:0]).strCategoryName;
//            //先在分类里加一个条目再说
//            BVisitItem *bVisitItem=[[BVisitItem alloc]init];
//            bVisitItem.strItemId=((BVisitIssueData*)[bVisitModel.BVisitData.arrayIssuesData objectAtIndex:0]).strItemId;
//            bVisitItem.strItemTitle=((BVisitIssueData*)[bVisitModel.BVisitData.arrayIssuesData objectAtIndex:0]).strItemTitle;
//            bVisitItem.strItemDesc=((BVisitIssueData*)[bVisitModel.BVisitData.arrayIssuesData objectAtIndex:0]).strItemDesc;
//            bVisitItem.fWeight=((BVisitIssueData*)[bVisitModel.BVisitData.arrayIssuesData objectAtIndex:0]).fWeight;
//            bVisitItem.mark=((BVisitIssueData*)[bVisitModel.BVisitData.arrayIssuesData objectAtIndex:0]).nScore;
//            bVisitItem.arrayIssue=((BVisitIssueData*)[bVisitModel.BVisitData.arrayIssuesData objectAtIndex:0]).arrayIssue;
//            bVisitItem.bMark=NO;
//        bVisitCategory.arrayItem=[[NSMutableArray alloc]init];
//        [bVisitCategory.arrayItem addObject:bVisitItem];
////        bVisitCategory.fPoint=
//    [dataVisit.arrayCatagory addObject:bVisitCategory];
//    
//    for (int i=1; i< bVisitModel.BVisitData.arrayIssuesData.count;i++)
//    {
//        for (int j=0;j<dataVisit.arrayCatagory.count;j++)
//        {
//            //如果dataVisit.arrayCatagory数组里该名称的分类存在，就在该分类里加条目
//            if ([((BVisitIssueData*)[bVisitModel.BVisitData.arrayIssuesData objectAtIndex:i]).strCategoryName isEqualToString:((BVisitCategory*)[dataVisit.arrayCatagory objectAtIndex:j]).strCategoryName] )
//            {
//                BVisitItem *bVisitItem=[[BVisitItem alloc]init];
//                bVisitItem.strItemId=((BVisitIssueData*)[bVisitModel.BVisitData.arrayIssuesData objectAtIndex:i]).strItemId;
//                bVisitItem.strItemTitle=((BVisitIssueData*)[bVisitModel.BVisitData.arrayIssuesData objectAtIndex:i]).strItemTitle;
//                bVisitItem.strItemDesc=((BVisitIssueData*)[bVisitModel.BVisitData.arrayIssuesData objectAtIndex:i]).strItemDesc;
//                bVisitItem.fWeight=((BVisitIssueData*)[bVisitModel.BVisitData.arrayIssuesData objectAtIndex:i]).fWeight;
//                bVisitItem.mark=((BVisitIssueData*)[bVisitModel.BVisitData.arrayIssuesData objectAtIndex:i]).nScore;
//                bVisitItem.arrayIssue=((BVisitIssueData*)[bVisitModel.BVisitData.arrayIssuesData objectAtIndex:i]).arrayIssue;
//                bVisitItem.bMark=NO;
//                
//                [((BVisitCategory*)[dataVisit.arrayCatagory objectAtIndex:j]).arrayItem addObject:bVisitItem];
//            }
//            else//如果dataVisit.arrayCatagory数组里不存在该分类，则在dataVisit.arrayCatagory里加一个分类
//            {
//                BVisitCategory *bVisitCategory=[[BVisitCategory alloc]init];
//                bVisitCategory.strCategoryName=((BVisitIssueData*)[bVisitModel.BVisitData.arrayIssuesData objectAtIndex:i]).strCategoryName;
//                //分类里加一个条目
//                BVisitItem *bVisitItem=[[BVisitItem alloc]init];
//                bVisitItem.strItemId=((BVisitIssueData*)[bVisitModel.BVisitData.arrayIssuesData objectAtIndex:i]).strItemId;
//                bVisitItem.strItemTitle=((BVisitIssueData*)[bVisitModel.BVisitData.arrayIssuesData objectAtIndex:i]).strItemTitle;
//                bVisitItem.strItemDesc=((BVisitIssueData*)[bVisitModel.BVisitData.arrayIssuesData objectAtIndex:i]).strItemDesc;
//                bVisitItem.fWeight=((BVisitIssueData*)[bVisitModel.BVisitData.arrayIssuesData objectAtIndex:i]).fWeight;
//                bVisitItem.mark=((BVisitIssueData*)[bVisitModel.BVisitData.arrayIssuesData objectAtIndex:i]).nScore;
//                bVisitItem.arrayIssue=((BVisitIssueData*)[bVisitModel.BVisitData.arrayIssuesData objectAtIndex:i]).arrayIssue;
//                bVisitItem.bMark=NO;
//                bVisitCategory.arrayItem=[[NSMutableArray alloc]init];
//                [bVisitCategory.arrayItem addObject:bVisitItem];
//                [dataVisit.arrayCatagory addObject:bVisitCategory];
//            }
//        }
//        
//    }
////    dataVisit.arrayMap=
//    dataVisit.strComment=
//    dataVisit.strTitle=bVisitModel.strReportTitle;
////    dataVisit.reporters=
//    dataVisit.fPoint=bVisitModel.fPoint;
//    dataVisit.nStatus=0;
//    
//    
//    NSInteger nCurrent=0;//当前分类里条目个数
//    NSInteger nAll=0;//总条目个数
//    for (int i=0; i<dataVisit.arrayCatagory.count; i++)
//    {
//       nCurrent=((BVisitCategory *)[dataVisit.arrayCatagory objectAtIndex:i]).arrayItem.count;
//        nAll+=nCurrent;
//    }
//    
//    for (int i=0; i<dataVisit.arrayCatagory.count; i++)
//    {
//        nCurrent=((BVisitCategory *)[dataVisit.arrayCatagory objectAtIndex:i]).arrayItem.count;
//        
//        float nCatagory= ((float)nCurrent/nAll)*100;//该分组的满分
//        float rat;//得分率
//        NSInteger n=0;//计算正确地个数
//        NSInteger m=0;//改分类条目地个数
//        for (BVisitItem *bVisitItem in ((BVisitCategory *)[dataVisit.arrayCatagory objectAtIndex:i]).arrayItem)
//        {
//            if (bVisitItem.mark==BVisitMark_YES) {
//                n++;
//            }
//            m++;
//            rat=(float)n/m;
//        }
//        ((BVisitCategory *)[dataVisit.arrayCatagory objectAtIndex:i]).fPoint=rat*nCatagory;
//        
//    }
//    
//    return dataVisit;
//}
@end
