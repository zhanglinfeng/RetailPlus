//
//  RPConfCallViewController.m
//  RetailPlus
//
//  Created by lin dong on 14-6-16.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPConfCallViewController.h"
#import "RPConfDBMng.h"
#import "RPYuanTelApi.h"
#import "SVProgressHUD.h"

extern NSBundle * g_bundleResorce;

@interface RPConfCallViewController ()

@end

@implementation RPConfCallViewController

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
    self.strTaskName = NSLocalizedStringFromTableInBundle(@"CONFERENCE CALL",@"RPString", g_bundleResorce,nil);
    
    _viewHoldConf.delegate = self;
    
    _btnSelChn.layer.cornerRadius = 6;
    _btnSelChn.layer.borderWidth = 1;
    _btnSelChn.layer.borderColor = [UIColor colorWithWhite:0.5 alpha:1].CGColor;
    [self UpdateChnTip];
    
    NSArray * arrayChn = [[RPConfDBMng defaultInstance] LoadConfAccounts:MAX_CONFACCOUNTCOUNT LoginUser:[RPSDK defaultInstance].userLoginDetail.strUserId];
    BOOL bFound = NO;
    for (RPConfAccount * account in arrayChn)
    {
        if (account.bInited) {
            bFound = YES;
            break;
        }
    }
    if (!bFound) {
        CGSize szScreen = [[UIScreen mainScreen] bounds].size;
        _viewTip.frame = CGRectMake(0, 0, szScreen.width, szScreen.height);
        [[[UIApplication sharedApplication] keyWindow] addSubview:_viewTip];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)UpdateChnTip
{
    [_btnSelChn setImage:[UIImage imageNamed:@"button_no_channel1_no.png"] forState:UIControlStateNormal];
    _lbSelChn.hidden = YES;
    
    NSArray * arrayChn = [[RPConfDBMng defaultInstance] LoadConfAccounts:MAX_CONFACCOUNTCOUNT LoginUser:[RPSDK defaultInstance].userLoginDetail.strUserId];
    for (RPConfAccount * account in arrayChn) {
        if (account.bInited && account.bChecked) {
            _lbSelChn.hidden = NO;
            _lbSelChn.text = [NSString stringWithFormat:@"#%@",account.strID];
            
            [SVProgressHUD showWithStatus:@""];
            [_btnSelChn setImage:[UIImage imageNamed:@"button_no_channel1.png"] forState:UIControlStateNormal];
            
            [[RPYuanTelApi defaultInstance] LoginConf:account.strUserName PassWord:account.strPassWord success:^(id idResult) {
                account.bLogined = YES;
                [_btnSelChn setImage:[UIImage imageNamed:@"button_channel1.png"] forState:UIControlStateNormal];
                [SVProgressHUD dismiss];
            } failed:^(NSInteger nErrorCode, NSString *strDesc) {
                account.bLogined = NO;
                [SVProgressHUD showErrorWithStatus:strDesc];
            }];
        }
    }
}

-(BOOL)OnBack
{
    switch (_step) {
        case RPCONFCALLSTEP_MNGCHN:
            if ([_viewMngChn OnBack]) {
                [UIView beginAnimations:nil context:nil];
                _viewMngChn.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
                [UIView commitAnimations];
                [self UpdateChnTip];
                _step = RPCONFCALLSTEP_MAIN;
            }
            return NO;
            break;
        case RPCONFCALLSTEP_HOLDCONF:
            if ([_viewHoldConf OnBack]) {
                [UIView beginAnimations:nil context:nil];
                _viewHoldConf.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
                [UIView commitAnimations];
                [self UpdateChnTip];
                _step = RPCONFCALLSTEP_MAIN;
            }
            return NO;
            break;
        case RPCONFCALLSTEP_BOOKCONF:
            if ([_viewBookConf OnBack]) {
                [UIView beginAnimations:nil context:nil];
                _viewBookConf.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
                [UIView commitAnimations];
                [self UpdateChnTip];
                _step = RPCONFCALLSTEP_MAIN;
            }
            return NO;
            break;
        case RPCONFCALLSTEP_CTRLCONF:
            if ([_viewCtrlConf OnBack]) {
                [UIView beginAnimations:nil context:nil];
                _viewCtrlConf.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
                [UIView commitAnimations];
                [self UpdateChnTip];
                _step = RPCONFCALLSTEP_MAIN;
            }
            return NO;
            break;
        case RPCONFCALLSTEP_CONFHISTORY:
            if ([_viewHistoryConf OnBack]) {
                [UIView beginAnimations:nil context:nil];
                _viewHistoryConf.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
                [UIView commitAnimations];
                _step = RPCONFCALLSTEP_MAIN;
            }
            return NO;
        default:
            break;
    }
    return YES;
}

-(IBAction)OnMngChn:(id)sender
{
    _viewMngChn.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:_viewMngChn];
    
    [UIView beginAnimations:nil context:nil];
    _viewMngChn.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];

    [_viewMngChn LoadSavedAccount];
    
    _step = RPCONFCALLSTEP_MNGCHN;
}

-(IBAction)OnHoldConf:(id)sender
{
    _viewHoldConf.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:_viewHoldConf];
    
    [UIView beginAnimations:nil context:nil];
    _viewHoldConf.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
    
    RPConf * conf = [[RPConf alloc] init];
    conf.strHostName =[NSString stringWithFormat:@"%@",[RPSDK defaultInstance].userLoginDetail.strFirstName];
    conf.strHostPhone = [RPSDK defaultInstance].userLoginDetail.strUserAcount;
    conf.strHostEmail = [RPSDK defaultInstance].userLoginDetail.strUserEmail;
    conf.arrayGuest = [[NSMutableArray alloc] init];
    
    _viewHoldConf.conf = conf;
    
    _step = RPCONFCALLSTEP_HOLDCONF;
}

-(IBAction)OnBookConf:(id)sender
{
    _viewBookConf.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:_viewBookConf];
    _viewBookConf.delegate = self;
    [UIView beginAnimations:nil context:nil];
    _viewBookConf.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
    [_viewBookConf UpdateChnTip];
    
    _step = RPCONFCALLSTEP_BOOKCONF;
}

-(IBAction)OnCtrlConf:(id)sender
{
    _viewCtrlConf.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:_viewCtrlConf];
    
    [UIView beginAnimations:nil context:nil];
    _viewCtrlConf.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
    
    _viewCtrlConf.delegate = self;
    [_viewCtrlConf UpdateChnTip];
    
    _step = RPCONFCALLSTEP_CTRLCONF;
}

-(IBAction)OnConfHistory:(id)sender
{
    _viewHistoryConf.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:_viewHistoryConf];
    _viewHistoryConf.delegate = self;
    
    [UIView beginAnimations:nil context:nil];
    _viewHistoryConf.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
    [_viewHistoryConf ReloadData];
    
    _step = RPCONFCALLSTEP_CONFHISTORY;
}

-(void)OnHoldConfEnd
{
    [UIView beginAnimations:nil context:nil];
    _viewHoldConf.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
    _step = RPCONFCALLSTEP_MAIN;
    [self UpdateChnTip];
}

-(void)OnHistoryEnd
{
    [UIView beginAnimations:nil context:nil];
    _viewHistoryConf.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
    _step = RPCONFCALLSTEP_MAIN;
}

-(void)OnRepeatConf:(RPConf *)conf
{
    [UIView beginAnimations:nil context:nil];
    _viewHistoryConf.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
    _step = RPCONFCALLSTEP_MAIN;
    
    
    _viewHoldConf.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:_viewHoldConf];
    
    [UIView beginAnimations:nil context:nil];
    _viewHoldConf.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
    
    RPConf * confSet = [[RPConf alloc] init];
    confSet.strCallTheme = conf.strCallTheme;
    confSet.strHostName = conf.strHostName;
    confSet.strHostPhone = conf.strHostPhone;
    confSet.strHostEmail = conf.strHostEmail;
    confSet.arrayGuest = [[NSMutableArray alloc] init];
    
    for (NSInteger n = 1; n < conf.arrayGuest.count; n ++) {
       [confSet.arrayGuest addObject:[conf.arrayGuest objectAtIndex:n]];
    }
    
    _viewHoldConf.conf = confSet;
    
    _step = RPCONFCALLSTEP_HOLDCONF;
}

-(void)OnCtrlConfEnd
{
    [UIView beginAnimations:nil context:nil];
    _viewCtrlConf.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
    [self UpdateChnTip];
    _step = RPCONFCALLSTEP_MAIN;
}

-(void)OnBookConfEnd
{
    [UIView beginAnimations:nil context:nil];
    _viewBookConf.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
    [self UpdateChnTip];
    _step = RPCONFCALLSTEP_MAIN;
}

- (IBAction)OnHelp:(id)sender
{
    [RPGuide ShowGuide:self.view];
}
@end
