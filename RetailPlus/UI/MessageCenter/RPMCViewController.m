//
//  RPMCViewController.m
//  RetailPlus
//
//  Created by lin dong on 13-9-10.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import "RPMCViewController.h"
#import "RPMCReportCell.h"
#import "SVProgressHUD.h"
#import "RPWebDocViewController.h"
#import "RPBlockUIAlertView.h"
#import "RPAppDelegate.h"
#import "RPMainViewController.h"


extern NSBundle * g_bundleResorce;

@interface RPMCViewController ()

@end

@implementation RPMCViewController

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
    _ivRecMark.hidden = YES;
    _ivRecMark.layer.cornerRadius = 2.0;
    _viewBroadCast.delegate = self;
    
}


-(void)PostCommentEnd
{
    NSUserDefaults * ud = [NSUserDefaults standardUserDefaults];
    NSString * recordPath = [ud objectForKey:@"mp3RecPath"];
    NSInteger messageLength = [ud integerForKey:@"textFiledLength"];
    NSData * recData = [NSData dataWithContentsOfFile:recordPath];
    if (recData || messageLength) {
        _ivRecMark.hidden = NO;
    }else{
        _ivRecMark.hidden = YES;
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    if (!_bInited) {
        _svFrame.contentSize = CGSizeMake(_svFrame.frame.size.width * 3, _svFrame.frame.size.height);
        [_btnMsg setSelected:YES];
        [_svFrame setContentOffset:CGPointMake(0, 0)];
        _bInited = YES;
        
        _arrayReport = [[NSMutableArray alloc] init];
        _arrayMessage = [[NSMutableArray alloc] init];
        _arrayTask = [[NSMutableArray alloc] init];
        
        [self addFooter];
        [self addHeader];
        
        [_tbMsg reloadData];
        [self ReloadHead];
    }
    
    if (_timer == nil) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:30
                                                  target:self
                                                selector:@selector(timerExceeded)
                                                userInfo:nil
                                                repeats:YES];
    }
    
    CGSize szScreen = [[UIScreen mainScreen] bounds].size;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0)
    {
        _viewBorder.frame = CGRectMake(0, 0, szScreen.width, szScreen.height - 20);
    }
}

- (void)timerExceeded {
    [self ReloadHeadData];
}

- (void)addFooter
{
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    footer.scrollView = _tbTask;
    footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        [refreshView endRefreshing];
        [self ReloadEndMessage:ICType_Task];
    };
    _footerTask = footer;
    
    footer = [MJRefreshFooterView footer];
    footer.scrollView = _tbReport;
    footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        [refreshView endRefreshing];
        [self ReloadEndMessage:ICType_Report];
    };
    _footerReport = footer;
    
    footer = [MJRefreshFooterView footer];
    footer.scrollView = _tbMsg;
    footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        [refreshView endRefreshing];
        [self ReloadEndMessage:ICType_Message];
    };
    _footerMsg = footer;
}

- (void)addHeader
{
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    header.scrollView = _tbMsg;
    header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        [refreshView endRefreshing];
        [self ReloadBefMessage:ICType_Message];
    };
    _headerMsg = header;
    
    header = [MJRefreshHeaderView header];
    header.scrollView = _tbReport;
    header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        [refreshView endRefreshing];
        [self ReloadBefMessage:ICType_Report];
    };
    _headerReport = header;

    header = [MJRefreshHeaderView header];
    header.scrollView = _tbTask;
    header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        [refreshView endRefreshing];
        [self ReloadBefMessage:ICType_Task];
    };
    _headerTask = header;
}

-(void)ReloadMessage
{
    [self ReloadBefMessage:_curType];
}

-(void)ReloadBefMessage:(ICType)type
{
    UITableView * table = nil;
    NSMutableArray * arrayAdd = nil;
    switch (type) {
        case ICType_Message:
            arrayAdd = _arrayMessage;
            table = _tbMsg;
            break;
        case ICType_Report:
            arrayAdd = _arrayReport;
            table = _tbReport;
            break;
        case ICType_Task:
            arrayAdd = _arrayTask;
            table = _tbTask;
            break;
        default:
            break;
    }
    [SVProgressHUD showWithStatus:@""];
    
    NSString * strLastId = @"";
    if (arrayAdd && arrayAdd.count > 0) {
        ICDetailInfo * detail = [arrayAdd objectAtIndex:0];
        strLastId = detail.strID;
    }
    
    [[RPSDK defaultInstance] GetICList:strLastId Type:type GetNew:YES GetCount:50 Success:^(NSMutableArray * array) {
        [self CalcCellHeight:array];
        
        if (arrayAdd) {
            NSRange range = NSMakeRange(0, [array count]);
            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
            [arrayAdd insertObjects:array atIndexes:indexSet];
        }
        else
        {
            switch (type) {
                case ICType_Message:
                     _arrayMessage = [[NSMutableArray alloc] initWithArray:array];
                    break;
                case ICType_Report:
                     _arrayReport = [[NSMutableArray alloc] initWithArray:array];
                    break;
                case ICType_Task:
                    _arrayTask = [[NSMutableArray alloc] initWithArray:array];
                    break;
                default:
                    break;
            }
        }
        
        [table reloadData];
        [SVProgressHUD dismiss];
        [self ReloadHeadData];
    } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
        [table reloadData];
        [SVProgressHUD dismiss];
    }];
}

-(void)ReloadEndMessage:(ICType)type
{
    UITableView * table = nil;
    NSMutableArray * arrayAdd = nil;
    switch (type) {
        case ICType_Message:
            arrayAdd = _arrayMessage;
            table = _tbMsg;
            break;
        case ICType_Report:
            arrayAdd = _arrayReport;
            table = _tbReport;
            break;
        case ICType_Task:
            arrayAdd = _arrayTask;
            table = _tbTask;
            break;
        default:
            break;
    }
    [SVProgressHUD showWithStatus:@""];
    
    NSString * strLastId = @"";
    if (arrayAdd && arrayAdd.count > 0) {
        LogBookDetail * detail = [arrayAdd objectAtIndex:(arrayAdd.count - 1)];
        strLastId = detail.strID;
    }
    
    [[RPSDK defaultInstance] GetICList:strLastId Type:type GetNew:NO GetCount:50 Success:^(NSMutableArray * array) {
        [self CalcCellHeight:array];
        
        if (arrayAdd)
            [arrayAdd addObjectsFromArray:array];
        else
        {
            switch (type) {
                case ICType_Message:
                    _arrayMessage = [[NSMutableArray alloc] initWithArray:array];
                    break;
                case ICType_Report:
                    _arrayReport = [[NSMutableArray alloc] initWithArray:array];
                    break;
                case ICType_Task:
                    _arrayTask = [[NSMutableArray alloc] initWithArray:array];
                    break;
                default:
                    break;
            }
        }
        
        [table reloadData];
        [SVProgressHUD dismiss];
        [self ReloadHeadData];
    } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
        [table reloadData];
        [SVProgressHUD dismiss];
    }];
}

-(void)CalcCellHeight:(NSMutableArray *)array
{
    for (ICDetailInfo * info in array) {
        info.nCellHeight = [RPMCReportCell CalcCellHeight:info];
    }
}

-(void)ClearMessage
{
    [_arrayReport removeAllObjects];
    [_arrayMessage removeAllObjects];
    [_arrayTask removeAllObjects];
    [_tbMsg reloadData];
    [_tbReport reloadData];
    [_tbTask reloadData];
}

-(void)OnBack
{
    [SVProgressHUD dismiss];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)hideMenu
{
    [UIView beginAnimations:nil context:nil];
    self.view.frame = CGRectMake(0,-self.view.frame.size.height-20, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
    
    [SVProgressHUD dismiss];
}

-(void)showMenu
{
    [UIView beginAnimations:nil context:nil];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
        self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    else
        self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (tableView == _tbReport) {
        
        NetworkStatus networkStatus=[RPSDK GetConnectionStatus];
        switch (networkStatus)
        {
            case NotReachable:
            {
                NSString * strDesc = NSLocalizedStringFromTableInBundle(@"Network not found",@"RPString", g_bundleResorce,nil);
                [SVProgressHUD showErrorWithStatus:strDesc];
                break;
            }
            case ReachableViaWiFi:
            {
                ICDetailInfo * info = [_arrayReport objectAtIndex:indexPath.row];
                
                RPWebDocViewController * vcWeb = [[RPWebDocViewController alloc] initWithNibName:NSStringFromClass([RPWebDocViewController class]) bundle:nil];
                vcWeb.cache = [RPSDK defaultInstance].cacheDocumentLive;
                vcWeb.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
                vcWeb.strUrl = info.strParam;
                vcWeb.strTitle = info.strSubject;
                
                RPAppDelegate * app = (RPAppDelegate *)[[UIApplication sharedApplication] delegate];
                [app.viewController presentViewController:vcWeb animated:YES completion:^{
                }];
                break;
            }
            case ReachableViaWWAN:
            {
                NSString * strOK = NSLocalizedStringFromTableInBundle(@"OK",@"RPString", g_bundleResorce,nil);
                NSString *strCancel=NSLocalizedStringFromTableInBundle(@"CANCEL",@"RPString", g_bundleResorce,nil);
                NSString * strDesc = NSLocalizedStringFromTableInBundle(@"No WLAN connection. Confirm to view document now?",@"RPString", g_bundleResorce,nil);
                RPBlockUIAlertView *alertView=[[RPBlockUIAlertView alloc]initWithTitle:nil message:strDesc cancelButtonTitle:strCancel clickButton:^(NSInteger indexButton) {
                    if (indexButton==1) {
                        ICDetailInfo * info = [_arrayReport objectAtIndex:indexPath.row];
                        
                        RPWebDocViewController * vcWeb = [[RPWebDocViewController alloc] initWithNibName:NSStringFromClass([RPWebDocViewController class]) bundle:nil];
                        vcWeb.cache = [RPSDK defaultInstance].cacheDocumentLive;
                        vcWeb.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
                        vcWeb.strUrl = info.strParam;
                        vcWeb.strTitle = info.strSubject;
                        
                        RPAppDelegate * app = (RPAppDelegate *)[[UIApplication sharedApplication] delegate];
                        [app.viewController presentViewController:vcWeb animated:YES completion:^{
                        }];
                    }
                }otherButtonTitles:strOK, nil];
                [alertView show];
                
                break;
            }
            default:
                break;
        }
        
        
        return;
    }
    return;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ICDetailInfo * detail = nil;
    if (tableView == _tbReport)
        detail = [_arrayReport objectAtIndex:indexPath.row];
    if (tableView == _tbMsg)
        detail = [_arrayMessage objectAtIndex:indexPath.row];
    if (tableView == _tbTask)
        detail = [_arrayTask objectAtIndex:indexPath.row];
    return detail.nCellHeight;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _tbReport) {
        return _arrayReport.count;
    }
    if (tableView == _tbMsg) {
        return _arrayMessage.count;
    }
    if (tableView == _tbTask) {
        return _arrayTask.count;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _tbMsg) {
        RPMCReportCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RPMCMsgCell"];
        if (cell == nil)
        {
            NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"RPMCCell" owner:self options:nil];
            cell = [array objectAtIndex:0];
        }
        cell.type = _curType;
        cell.strCurPlayRecordUrl = _strCurPlayRecordUrl;
        cell.detail = [_arrayMessage objectAtIndex:indexPath.row];
        cell.delegate = self;
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }
    
    if (tableView == _tbReport) {
        RPMCReportCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RPMCReportCell"];
        if (cell == nil)
        {
            NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"RPMCCell" owner:self options:nil];
            cell = [array objectAtIndex:0];
        }
        cell.type = _curType;
        cell.detail = [_arrayReport objectAtIndex:indexPath.row];
        cell.delegate = self;
        return cell;
    }
    
    if (tableView == _tbTask) {
        RPMCReportCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RPMCTaskCell"];
        if (cell == nil)
        {
            NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"RPMCCell" owner:self options:nil];
            cell = [array objectAtIndex:0];
        }
        cell.type = _curType;
        cell.detail = [_arrayTask objectAtIndex:indexPath.row];
        cell.delegate = self;
        return cell;
    }
    return nil;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches   anyObject];
    CGPoint pt = [touch locationInView:_viewHideBar];
    _nTouchBegin = pt.y;
    _rcOriginalViewFrame = self.view.frame;
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_nTouchBegin > 0) {
        UITouch *touch = [touches anyObject];
        CGPoint currentLocation = [touch locationInView:_viewHideBar];
        CGRect frame = self.view.frame;
        frame.origin.x = 0;
        frame.origin.y += currentLocation.y - _nTouchBegin;
        if (frame.origin.y > 0) {
            frame.origin.y = 0;
        }
        self.view.frame = frame;
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_nTouchBegin > 0) {
        UITouch *touch = [touches anyObject];
        CGPoint currentLocation = [touch locationInView:_viewHideBar];
        CGRect frame = self.view.frame;
        frame.origin.x = 0;
        frame.origin.y += currentLocation.y - _nTouchBegin;
        self.view.frame = frame;
        
       if ((self.view.frame.origin.y + self.view.frame.size.height) < (self.view.frame.size.height * 4 / 5))
           [self hideMenu];
       else
           [self showMenu];
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == _svFrame) {
        [_btnMsg setSelected:NO];
        [_btnReport setSelected:NO];
        [_btnTask setSelected:NO];
        
        if (scrollView.contentOffset.x == 0)
        {
            [_btnMsg setSelected:YES];
            if (_curType != ICType_Message) {
                _curType = ICType_Message;
                [self ReloadMessage];
            }
        }
        else if (scrollView.contentOffset.x == _svFrame.frame.size.width * 2) {
            [_btnTask setSelected:YES];
            if (_curType != ICType_Task) {
                _curType = ICType_Task;
                [self ReloadMessage];
            }
        }
        else
        {
            [_btnReport setSelected:YES];
            if (_curType != ICType_Report) {
                _curType = ICType_Report;
                [self ReloadMessage];
            }
        }
    }
}

-(IBAction)OnSelectSection:(id)sender
{
    if (sender == _btnTask) {
        [_svFrame setContentOffset:CGPointMake(_svFrame.frame.size.width * 2, 0) animated:YES];
        return;
    }
    if (sender == _btnReport) {
        [_svFrame setContentOffset:CGPointMake(_svFrame.frame.size.width, 0) animated:YES];
        return;
    }
    if (sender == _btnMsg) {
        [_svFrame setContentOffset:CGPointMake(0, 0) animated:YES];
        return;
    }
}

-(IBAction)OnBack:(id)sender
{
    [self hideMenu];
}

-(IBAction)onBroadCast:(id)sender
{
    if ([RPRights hasRightsFunc:[RPSDK defaultInstance].llRights type:RPRightsFuncType_BroadCastMsg]) {
        _viewBroadCast.vcFrame = self;
        [_viewBroadCast ShowCommentView];
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:NSLocalizedStringFromTableInBundle(@"You do not have the authority to do this task",@"RPString", g_bundleResorce,nil)];
    }
}

//-(void)PostCommentEnd
//{
//    [self ReloadMessage];
//}

-(void)ReloadHeadData
{
    if ([RPSDK defaultInstance].userLoginDetail) {
        [[RPSDK defaultInstance] GetICUnreadCountSuccess:^(NSMutableArray * array) {
            for(ICUnread * unread in array)
            {
                switch(unread.type)
                {
                    case ICType_Message:
                        _nUnReadMessage = unread.nCount;
                        break;
                    case ICType_Report:
                        _nUnReadReport = unread.nCount;
                        break;
                    case ICType_Task:
                        _nUnReadTask = unread.nCount;
                        break;
                }
            }
            [[NSNotificationCenter defaultCenter]
             postNotificationName:kInfomationCenterNotification object:[NSNumber numberWithInteger:_nUnReadMessage + _nUnReadReport + _nUnReadTask]];
            
            [self ReloadHead];
        } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
        }];
    }
}

-(void)ReloadHead
{
    NSString * strMsg = NSLocalizedStringFromTableInBundle(@"Message",@"RPString", g_bundleResorce,nil);
    if (_nUnReadMessage > 0)
    {
        [_btnMsg setTitle:[NSString stringWithFormat:@"%@(%d)",strMsg,_nUnReadMessage] forState:UIControlStateNormal];
        [_btnMsg setTitle:[NSString stringWithFormat:@"%@(%d)",strMsg,_nUnReadMessage] forState:UIControlStateSelected];
    }
    else
    {
        [_btnMsg setTitle:[NSString stringWithFormat:@"%@",strMsg] forState:UIControlStateNormal];
        [_btnMsg setTitle:[NSString stringWithFormat:@"%@",strMsg] forState:UIControlStateSelected];
    }
    
    NSString * strReport = NSLocalizedStringFromTableInBundle(@"Reports",@"RPString", g_bundleResorce,nil);
    if (_nUnReadReport > 0)
    {
        [_btnReport setTitle:[NSString stringWithFormat:@"%@(%d)",strReport,_nUnReadReport] forState:UIControlStateNormal];
        [_btnReport setTitle:[NSString stringWithFormat:@"%@(%d)",strReport,_nUnReadReport] forState:UIControlStateSelected];
    }
    else
    {
        [_btnReport setTitle:[NSString stringWithFormat:@"%@",strReport] forState:UIControlStateNormal];
        [_btnReport setTitle:[NSString stringWithFormat:@"%@",strReport] forState:UIControlStateSelected];
    }
    
    NSString * strTask = NSLocalizedStringFromTableInBundle(@"Tasks",@"RPString", g_bundleResorce,nil);
    if (_nUnReadTask > 0)
    {
        [_btnTask setTitle:[NSString stringWithFormat:@"%@(%d)",strTask,_nUnReadTask] forState:UIControlStateNormal];
        [_btnTask setTitle:[NSString stringWithFormat:@"%@(%d)",strTask,_nUnReadTask] forState:UIControlStateSelected];
    }
    else
    {
        [_btnTask setTitle:[NSString stringWithFormat:@"%@",strTask] forState:UIControlStateNormal];
        [_btnTask setTitle:[NSString stringWithFormat:@"%@",strTask] forState:UIControlStateSelected];
    }
    
    _lbTitle.text = NSLocalizedStringFromTableInBundle(@"INFOMATION CENTER",@"RPString", g_bundleResorce,nil);
}

-(void)OnSelectUserImg:(UserDetailInfo *)user
{
    [_delegate OnICSelectUser:user];
}

-(void)OnPlayRecord:(NSString *)strUrl
{
    if ([strUrl isEqualToString:_strCurPlayRecordUrl]) {
        if (_moviePlayer) {
            [_moviePlayer stop];
   //         _moviePlayer = nil;
            _strCurPlayRecordUrl = nil;
            [_tbMsg reloadData];
        }
    }
    else
    {
        if (_moviePlayer)
        {
            [_moviePlayer stop];
            _moviePlayer = nil;
        }
        
        _strCurPlayRecordUrl = strUrl;
        _moviePlayer = [[ MPMoviePlayerController alloc] initWithContentURL:[NSURL URLWithString:_strCurPlayRecordUrl]];
        [_moviePlayer prepareToPlay];
        [_moviePlayer play];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayerLoadStateChanged:) name:MPMoviePlayerLoadStateDidChangeNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayerPlayEnd:) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
        [_tbMsg reloadData];
    }
}

- (void) moviePlayerLoadStateChanged:(NSNotification*)notification
{
    NSTimeInterval time = _moviePlayer.duration;
    if (time == 0) {
        [_moviePlayer stop];
        _moviePlayer = nil;
        _strCurPlayRecordUrl = nil;
        [_tbMsg reloadData];
    }
}

- (void) moviePlayerPlayEnd:(NSNotification*)notification
{
    [_moviePlayer stop];
  //  _moviePlayer = nil;
    _strCurPlayRecordUrl = nil;
    [_tbMsg reloadData];
}

@end
