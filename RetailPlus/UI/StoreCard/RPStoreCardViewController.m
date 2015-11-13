//
//  RPStoreCardViewController.m
//  RetailPlus
//
//  Created by lin dong on 13-9-3.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "RPStoreCardViewController.h"
#import "UIImageView+WebCache.h"
#import "RPVideoPlayViewController.h"
#import "SVProgressHUD.h"
#import "RPOwnedModel.h"

extern NSBundle * g_bundleResorce;

@interface RPStoreCardViewController ()

@end

@implementation RPStoreCardViewController

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
    
    self.strTaskName = NSLocalizedStringFromTableInBundle(@"STORE CARD",@"RPString", g_bundleResorce,nil);
    _viewTask.layer.cornerRadius = 10;
    
    NSArray *array = [g_bundleResorce loadNibNamed:@"RPStoreCardView" owner:self options:nil];
    _viewStoreCard = [array objectAtIndex:0];
    
    _svTask.contentSize = CGSizeMake(_svTask.frame.size.width, 290);
    
    CGSize szScreen = [[UIScreen mainScreen] bounds].size;
    
    _viewStoreCard.frame = CGRectMake(0, 0, _viewTask.frame.size.width, szScreen.height - 120);
    [_viewTask addSubview:_viewStoreCard];
    [_viewStoreCard Hide:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setStore:(StoreDetailInfo *)store
{
    _store = store;
    _viewStoreCard.store = store;
    
    if (store.isOwn)
        _svTask.hidden = NO;
    else
        _svTask.hidden = YES;
    //提交验收报告
    if ([RPRights hasRightsFunc:_store.llRights type:RPRightsFuncType_SubmitInspectionReport] && [RPOwnedModel hasModelFunc:[RPSDK defaultInstance].llOwnedModel type:OwnedModelType_Inspection])
    {
        _btHandover.alpha=1;
        _lbHandover.alpha=1;
        _btHandover.userInteractionEnabled=YES;
    }
    else
    {
        _btHandover.alpha=0.2;
        _lbHandover.alpha=0.2;
        _btHandover.userInteractionEnabled=NO;
        if (![RPOwnedModel hasModelFunc:[RPSDK defaultInstance].llOwnedModel type:OwnedModelType_Inspection])
        {
            UIImageView * iv = [[UIImageView alloc] initWithFrame:_btHandover.frame];
            iv.image = [UIImage imageNamed:@"button_lockedfunction.png"];
            [_btHandover.superview addSubview:iv];
        }
    }
    
    //提交巡店报告
    if ([RPRights hasRightsFunc:_store.llRights type:RPRightsFuncType_SubmitCVisitReport] && [RPOwnedModel hasModelFunc:[RPSDK defaultInstance].llOwnedModel type:OwnedModelType_Visiting])
    {
        _btInspection.alpha=1;
        _lbInspection.alpha=1;
        _btInspection.userInteractionEnabled=YES;
    }
    else
    {
        _btInspection.alpha=0.2;
        _lbInspection.alpha=0.2;
        _btInspection.userInteractionEnabled=NO;
        if (![RPOwnedModel hasModelFunc:[RPSDK defaultInstance].llOwnedModel type:OwnedModelType_Visiting])
        {
            UIImageView * iv = [[UIImageView alloc] initWithFrame:_btInspection.frame];
            iv.image = [UIImage imageNamed:@"button_lockedfunction.png"];
            [_btInspection.superview addSubview:iv];
        }
    }
    //提交维修报告
    if ([RPRights hasRightsFunc:_store.llRights type:RPRightsFuncType_SubmitMaintainReport] && [RPOwnedModel hasModelFunc:[RPSDK defaultInstance].llOwnedModel type:OwnedModelType_Maintenance])
    {
        _btMaintenance.alpha=1;
        _lbMaintenance.alpha=1;
        _btMaintenance.userInteractionEnabled=YES;
    }
    else
    {
        _btMaintenance.alpha=0.2;
        _lbMaintenance.alpha=0.2;
        _btMaintenance.userInteractionEnabled=NO;
        if (![RPOwnedModel hasModelFunc:[RPSDK defaultInstance].llOwnedModel type:OwnedModelType_Maintenance])
        {
            UIImageView * iv = [[UIImageView alloc] initWithFrame:_btMaintenance.frame];
            iv.image = [UIImage imageNamed:@"button_lockedfunction.png"];
            [_btMaintenance.superview addSubview:iv];
        }
    }
    //提交零售巡店报告
    if ([RPRights hasRightsFunc:_store.llRights type:RPRightsFuncType_SubmitBVisitReport] && [RPOwnedModel hasModelFunc:[RPSDK defaultInstance].llOwnedModel type:OwnedModelType_BVisiting])
    {
        _btBVisit.alpha=1;
        _lbBVisit.alpha=1;
        _btBVisit.userInteractionEnabled=YES;
    }
    else
    {
        _btBVisit.alpha=0.2;
        _lbBVisit.alpha=0.2;
        _btBVisit.userInteractionEnabled=NO;
        if (![RPOwnedModel hasModelFunc:[RPSDK defaultInstance].llOwnedModel type:OwnedModelType_BVisiting])
        {
            UIImageView * iv = [[UIImageView alloc] initWithFrame:_btBVisit.frame];
            iv.image = [UIImage imageNamed:@"button_lockedfunction.png"];
            [_btBVisit.superview addSubview:iv];
        }
    }
    //视频直播
    if ([RPRights hasRightsFunc:_store.llRights type:RPRightsFuncType_LiveVideo] && [RPOwnedModel hasModelFunc:[RPSDK defaultInstance].llOwnedModel type:OwnedModelType_LiveVideo])
    {
        _btVideo.alpha=1;
        _lbVideo.alpha=1;
        _btVideo.userInteractionEnabled=YES;
    }
    else
    {
        _btVideo.alpha=0.2;
        _lbVideo.alpha=0.2;
        _btVideo.userInteractionEnabled=NO;
        if (![RPOwnedModel hasModelFunc:[RPSDK defaultInstance].llOwnedModel type:OwnedModelType_LiveVideo])
        {
            UIImageView * iv = [[UIImageView alloc] initWithFrame:_btVideo.frame];
            iv.image = [UIImage imageNamed:@"button_lockedfunction.png"];
            [_btVideo.superview addSubview:iv];
        }
    }
    //kpi
    if (([RPRights hasRightsFunc:_store.llRights type:RPRightsFuncType_InputKPITraffic]||[RPRights hasRightsFunc:_store.llRights type:RPRightsFuncType_InputKPISales]) && [RPOwnedModel hasModelFunc:[RPSDK defaultInstance].llOwnedModel type:OwnedModelType_KPI])
    {
        _btKpi.alpha=1;
        _lbKpi.alpha=1;
        _btKpi.userInteractionEnabled=YES;
    }
    else
    {
        _btKpi.alpha=0.2;
        _lbKpi.alpha=0.2;
        _btKpi.userInteractionEnabled=NO;
        if (![RPOwnedModel hasModelFunc:[RPSDK defaultInstance].llOwnedModel type:OwnedModelType_KPI])
        {
            UIImageView * iv = [[UIImageView alloc] initWithFrame:_btKpi.frame];
            iv.image = [UIImage imageNamed:@"button_lockedfunction.png"];
            [_btKpi.superview addSubview:iv];
        }
    }
    
    //交接记录
    if ([RPRights hasRightsFunc:_store.llRights type:RPRightsFuncType_LogBook] && [RPOwnedModel hasModelFunc:[RPSDK defaultInstance].llOwnedModel type:OwnedModelType_Logbook])
    {
        _btLogBook.alpha=1;
        _lbLogBook.alpha=1;
        _btLogBook.userInteractionEnabled=YES;
    }
    else
    {
        _btLogBook.alpha=0.2;
        _lbLogBook.alpha=0.2;
        _btLogBook.userInteractionEnabled=NO;
        if (![RPOwnedModel hasModelFunc:[RPSDK defaultInstance].llOwnedModel type:OwnedModelType_Logbook])
        {
            UIImageView * iv = [[UIImageView alloc] initWithFrame:_btLogBook.frame];
            iv.image = [UIImage imageNamed:@"button_lockedfunction.png"];
            [_btLogBook.superview addSubview:iv];
        }
    }
    
    //点数本
    if ([RPOwnedModel hasModelFunc:[RPSDK defaultInstance].llOwnedModel type:OwnedModelType_DailyStock])
    {
        _btnDailyStock.alpha=1;
        _lbDailyStock.alpha=1;
        _btnDailyStock.userInteractionEnabled=YES;
    }
    else
    {
        _btnDailyStock.alpha=0.2;
        _lbDailyStock.alpha=0.2;
        _btnDailyStock.userInteractionEnabled=NO;
        if (![RPOwnedModel hasModelFunc:[RPSDK defaultInstance].llOwnedModel type:OwnedModelType_DailyStock])
        {
            UIImageView * iv = [[UIImageView alloc] initWithFrame:_btLogBook.frame];
            iv.image = [UIImage imageNamed:@"button_lockedfunction.png"];
            [_btnDailyStock.superview addSubview:iv];
        }
    }
}

-(IBAction)OnCVisit:(id)sender
{
    [self.delegate OnStoreCVisit:_store];
//    RPVideoPlayViewController * vcWeb = [[RPVideoPlayViewController alloc] initWithNibName:NSStringFromClass([RPVideoPlayViewController class]) bundle:nil];
//    //vcSignUp.delegate = self;
//    vcWeb.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
//    [self.vcCtrl presentViewController:vcWeb animated:YES completion:^{
//        
//    }];
}

-(IBAction)OnHandOver:(id)sender
{
    [self.delegate OnStoreHandover:_store];
}

-(IBAction)OnMaintenance:(id)sender
{
    [self.delegate OnStoreMaintenance:_store];
}

-(IBAction)OnBVisit:(id)sender
{
    [self.delegate OnStoreBVisit:_store CacheDataId:nil NeedLoadData:NO];
}

-(IBAction)OnLogbook:(id)sender
{
    [self.delegate OnStoreLogbook:_store];
}

-(IBAction)OnKPIEntry:(id)sender
{
    [self.delegate OnStoreKPIEntry:_store];
}

-(IBAction)OnLiveVideo:(id)sender
{
    [self.delegate OnLiveVideo:_store];
}

-(IBAction)OnEdit:(id)sender
{
    [self.delegate OnEditStore:_store];
}

- (IBAction)OnDailyStock:(id)sender
{
    [self.delegate OnDailyStock:_store];
}
@end
