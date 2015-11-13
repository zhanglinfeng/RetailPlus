//
//  RPTaskLiveView.m
//  RetailPlus
//
//  Created by Brilance on 14-9-15.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPTaskLiveView.h"
#import "RPTaskCell.h"
#import "SVProgressHUD.h"
#import "MJRefreshHeaderView.h"

@implementation RPTaskLiveView
extern NSBundle * g_bundleResorce;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)awakeFromNib
{
    _viewTaskBG.layer.cornerRadius=10;
    _viewTaskBG.layer.shadowOffset = CGSizeMake(0, 1);
    _viewTaskBG.layer.shadowRadius =3.0;
    _viewTaskBG.layer.shadowColor =[UIColor blackColor].CGColor;
    _viewTaskBG.layer.shadowOpacity =0.5;
    _viewFilterBtn.layer.cornerRadius = 5.0;
    _viewSearchFrame.layer.masksToBounds=YES;
    _viewSearchFrame.layer.cornerRadius=6;
    _ivMarkUnFinished.layer.cornerRadius = 1;
    _ivMarkFinished.layer.cornerRadius = 1;
    
    _search = [[RPSearch alloc] InitWithParent:_viewSearchFrame Delegate:self];
    _curColor = COLOR_ALL;
    _bSponsor = YES;
    _bOperator = YES;
    [self ReloadData];
    [self addHeader];
    [_tbTask registerNib:[UINib nibWithNibName:@"RPTaskCell" bundle:nil] forCellReuseIdentifier:@"TaskCell"];

    [self showRedPoint];
    _getPointTimer=[NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(showRedPoint) userInfo:nil repeats:YES];
}

-(void)showRedPoint
{
    //有新任务时显示小红点
    [[RPSDK defaultInstance] HasNewTaskSuccess:^(NSDictionary* idResult) {
        if ([idResult[@"NewUnderway"] boolValue]==YES)
            _ivMarkUnFinished.hidden = NO;
        else
            _ivMarkUnFinished.hidden = YES;
            
        if ([idResult[@"NewFinished"] boolValue]==YES)
            _ivMarkFinished.hidden = NO;
        else
            _ivMarkFinished.hidden = YES;
            
    } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
        //
    }];
}

- (void)addHeader
{
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    header.scrollView = _tbTask;
    header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        [refreshView endRefreshing];
        [self ReloadData];
    };
    _headerInternal = header;
    
}


-(void)OnSearchChange:(NSString *)strSearch
{
    [self endEditing:YES];
    [self ReloadData];
}



-(void)ReloadData
{
    [SVProgressHUD showWithStatus:@""];
    [[RPSDK defaultInstance] GetTaskList:[_search GetSearchString] IsFinished:_bFiltFinish IsInitiator:_bSponsor IsExecutor:_bOperator Color:_curColor TaskType:TASK_BVisit Success:^(NSArray* idResult) {
        _arrayInfos = idResult;
        [_tbTask reloadData];
        [SVProgressHUD dismiss];
    } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
        [_tbTask reloadData];
    }];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _arrayInfos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RPTaskCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TaskCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.taskInfo = _arrayInfos[indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 93;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate OnSelectTask:_arrayInfos[indexPath.row]];
    [[RPSDK defaultInstance] SetTaskRead:_arrayInfos[indexPath.row] Success:^(id idResult) {
        [_tbTask reloadData];
    } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
        
    }];
}


- (IBAction)OnFilter:(id)sender {
    [UIView beginAnimations:nil context:nil];
    if (_ivArrow.hidden) {
        _ivArrow.hidden = NO;
        _viewFilter.hidden = NO;
        _tbTask.frame = CGRectMake(0, _viewHead.frame.size.height+_viewFilter.frame.size.height, _tbTask.frame.size.width, _tbTask.frame.size.height-_viewFilter.frame.size.height);
    }else{
        _ivArrow.hidden = YES;
        _viewFilter.hidden = YES;
        _tbTask.frame = CGRectMake(0, _viewHead.frame.size.height, _tbTask.frame.size.width, _tbTask.frame.size.height+_viewFilter.frame.size.height);
    }
    [UIView commitAnimations];
    
}

//任务未完成/已完成
- (IBAction)OnUnderWayTask:(UIButton*)sender {
    [_btnUnderWay setBackgroundImage:[UIImage imageNamed:@"button_underway1.png"] forState:UIControlStateNormal];
    _lbUnderWay.textColor = [UIColor colorWithWhite:0.5 alpha:1.0];
    
    [_btnFinished setBackgroundImage:[UIImage imageNamed:@"button_finished2.png"] forState:UIControlStateNormal];
    _lbFinished.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
    _bFiltFinish = NO;
    
    [self ReloadData];
}


- (IBAction)OnFinishedTask:(UIButton*)sender {
    [_btnFinished setBackgroundImage:[UIImage imageNamed:@"button_finished1.png"] forState:UIControlStateNormal];
    _lbFinished.textColor = [UIColor colorWithWhite:0.5 alpha:1.0];
    
    [_btnUnderWay setBackgroundImage:[UIImage imageNamed:@"button_underway2.png"] forState:UIControlStateNormal];
    _lbUnderWay.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
   
    _bFiltFinish = YES;
    
    [self ReloadData];
}

//发起人/执行人
- (IBAction)OnSponsorTask:(UIButton*)sender {

    _bSponsor = !_bSponsor;
    if (!_bSponsor) {
        _viewSponsor.backgroundColor = [UIColor colorWithWhite:0.2 alpha:1];
        _lbSponsor.textColor = [UIColor colorWithWhite:.3 alpha:1];
    }else{
        _viewSponsor.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
        _lbSponsor.textColor = [UIColor colorWithWhite:.4 alpha:1];
    }
    [self ChangeBtnSpreadBackGround];
    [self ReloadData];
}

- (IBAction)OnOperatorTask:(UIButton*)sender {
    _bOperator = !_bOperator;
    if (_bOperator) {
        _viewOperator.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
        _lbOperator.textColor = [UIColor colorWithWhite:.4 alpha:1];
    }else {
        _viewOperator.backgroundColor = [UIColor colorWithWhite:0.2 alpha:1];
        _lbOperator.textColor = [UIColor colorWithWhite:.3 alpha:1];
    }
    [self ChangeBtnSpreadBackGround];
    [self ReloadData];
}

- (IBAction)OnColorSelected:(UIButton*)sender {
    switch (sender.tag) {
        case COLORTYPE_GREY:
            sender.selected = !sender.selected;
            if (sender.selected) {
                _btnPurple.selected = NO;
                _btnRed.selected = NO;
                _btnYellow.selected = NO;
                _btnGreen.selected = NO;
                _btnBlue.selected = NO;
                _btnPurple.alpha = .2;
                _btnRed.alpha = .2;
                _btnYellow.alpha = .2;
                _btnGreen.alpha = .2;
                _btnBlue.alpha = .2;
                sender.alpha = 1.0;
            }else{
                _btnPurple.alpha = 1;
                _btnRed.alpha = 1;
                _btnYellow.alpha = 1;
                _btnGreen.alpha = 1;
                _btnBlue.alpha = 1;
            }
            
            break;
        case COLORTYPE_PURPLE:
            sender.selected = !sender.selected;
            if (sender.selected) {
                _btnGrey.selected = NO;
                _btnRed.selected = NO;
                _btnYellow.selected = NO;
                _btnGreen.selected = NO;
                _btnBlue.selected = NO;
                _btnGrey.alpha = .2;
                _btnRed.alpha = .2;
                _btnYellow.alpha = .2;
                _btnGreen.alpha = .2;
                _btnBlue.alpha = .2;
                sender.alpha = 1.0;
            }else{
                _btnGrey.alpha = 1;
                _btnRed.alpha = 1;
                _btnYellow.alpha = 1;
                _btnGreen.alpha = 1;
                _btnBlue.alpha = 1;
            }
            break;
        case COLORTYPE_RED:
            sender.selected = !sender.selected;
            if (sender.selected) {
                _btnGrey.selected = NO;
                _btnPurple.selected = NO;
                _btnYellow.selected = NO;
                _btnGreen.selected = NO;
                _btnBlue.selected = NO;
                _btnGrey.alpha = .2;
                _btnPurple.alpha = .2;
                _btnYellow.alpha = .2;
                _btnGreen.alpha = .2;
                _btnBlue.alpha = .2;
                sender.alpha = 1.0;
            }else{
                _btnGrey.alpha = 1;
                _btnPurple.alpha = 1;
                _btnYellow.alpha = 1;
                _btnGreen.alpha = 1;
                _btnBlue.alpha = 1;
            }
            break;
            case COLORTYPE_YELLOW:
            sender.selected = !sender.selected;
            if (sender.selected) {
                _btnGrey.selected = NO;
                _btnPurple.selected = NO;
                _btnRed.selected = NO;
                _btnGreen.selected = NO;
                _btnBlue.selected = NO;
                _btnGrey.alpha = .2;
                _btnPurple.alpha = .2;
                _btnRed.alpha = .2;
                _btnGreen.alpha = .2;
                _btnBlue.alpha = .2;
                sender.alpha = 1.0;
            }else{
                _btnGrey.alpha = 1;
                _btnPurple.alpha = 1;
                _btnRed.alpha = 1;
                _btnGreen.alpha = 1;
                _btnBlue.alpha = 1;
            }
            break;
            case COLORTYPE_GREEN:
            sender.selected = !sender.selected;
            if (sender.selected) {
                _btnGrey.selected = NO;
                _btnPurple.selected = NO;
                _btnRed.selected = NO;
                _btnYellow.selected = NO;
                _btnBlue.selected = NO;
                _btnGrey.alpha = .2;
                _btnPurple.alpha = .2;
                _btnRed.alpha = .2;
                _btnYellow.alpha = .2;
                _btnBlue.alpha = .2;
                sender.alpha = 1.0;
            }else{
                _btnGrey.alpha = 1;
                _btnPurple.alpha = 1;
                _btnRed.alpha = 1;
                _btnYellow.alpha = 1;
                _btnBlue.alpha = 1;
            }
            break;
            case COLORTYPE_BLUE:
            sender.selected = !sender.selected;
            if (sender.selected) {
                _btnGrey.selected = NO;
                _btnPurple.selected = NO;
                _btnRed.selected = NO;
                _btnYellow.selected = NO;
                _btnGreen.selected = NO;
                _btnGrey.alpha = .2;
                _btnPurple.alpha = .2;
                _btnRed.alpha = .2;
                _btnYellow.alpha = .2;
                _btnGreen.alpha = .2;
                sender.alpha = 1.0;
            }else{
                _btnGrey.alpha = 1;
                _btnPurple.alpha = 1;
                _btnRed.alpha = 1;
                _btnYellow.alpha = 1;
                _btnGreen.alpha = 1;
            }
            break;
        default:
            break;
    }
    if (sender.selected)
        _curColor = sender.tag;
    else
        _curColor = COLOR_ALL;
    
    [self ChangeBtnSpreadBackGround];
    [self ReloadData];
}

-(void)ChangeBtnSpreadBackGround
{
    if (_btnGrey.selected||_btnPurple.selected||_btnRed.selected||_btnYellow.selected||_btnGreen.selected||_btnBlue.selected||!_bSponsor||!_bOperator) {
        [_ivSpread setImage:[UIImage imageNamed:@"button_task_spread2.png"]];
    }else{
        [_ivSpread setImage:[UIImage imageNamed:@"button_task_spread1.png"]];
    }
}

- (void)OnUpdateTask
{
    [self ReloadData];
}

@end
