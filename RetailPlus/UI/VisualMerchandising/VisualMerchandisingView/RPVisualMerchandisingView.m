//
//  RPVisualMerchandisingView.m
//  RetailPlus
//
//  Created by zhanglinfeng on 14-6-16.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPVisualMerchandisingView.h"
#import "RPVisualMerchandisingCell.h"
#import "RPBlockUIAlertView.h"
#import "SVProgressHUD.h"
extern NSBundle * g_bundleResorce;
@implementation RPVisualMerchandisingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
-(void)awakeFromNib
{
    _viewFrame.layer.cornerRadius=10;
    _label=[[UILabel alloc]initWithFrame:CGRectMake(80, 160, 160, 30)];
    _label.font=[UIFont systemFontOfSize:12];
    _label.textColor=[UIColor colorWithWhite:0.8 alpha:1];
    _label.numberOfLines=0;
    _label.backgroundColor=[UIColor clearColor];
    _label.textAlignment=NSTextAlignmentCenter;
    _label.text=NSLocalizedStringFromTableInBundle(@"Temporarily no data",@"RPString", g_bundleResorce,nil);
    [self insertSubview:_label aboveSubview:_tbVisual];
}
-(void)loadData
{
    [[RPSDK defaultInstance]GetVisualDisplayList:_followStore.strStoreId Success:^(NSMutableArray *array) {
        _arrayVisualDisplay=array;
        _btPass.selected=YES;
        _btPending.selected=YES;
        _btReject.selected=YES;
        _lbpending.textColor=[UIColor colorWithWhite:0.3 alpha:1];
        _lbReject.textColor=[UIColor colorWithWhite:0.3 alpha:1];
        _lbPass.textColor=[UIColor colorWithWhite:0.3 alpha:1];
        [self screen:_btPass.selected Reject:_btPending.selected Pending:_btReject.selected];
    } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
        
    }];
    
//    [[RPSDK defaultInstance]GetStoreInfo:_followStore.strStoreId Success:^(StoreDetailInfo * storeInfo) {
//        _storeInfo=storeInfo;
//    } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
//        
//    }];

}
-(void)setStoreInfo:(StoreDetailInfo *)storeInfo
{
    _storeInfo=storeInfo;
}
//根据状态筛选
-(void)screen:(BOOL)isPass Reject:(BOOL)isReject Pending:(BOOL)isPending
{
    _arrayShow=[[NSMutableArray alloc]init];
    
    if(_btPending.selected||_btReject.selected||_btPass.selected)
    {
        _btMenu.selected=YES;
        for (int i=0; i<_arrayVisualDisplay.count; i++)
        {
            VisualDisplay *visualDisplay=[_arrayVisualDisplay objectAtIndex:i];
            if (visualDisplay.states==0)
            {
                if (_btPending.selected)
                {
                    [_arrayShow addObject:visualDisplay];
                }
            }
            if (visualDisplay.states==1)
            {
                if (_btReject.selected)
                {
                    [_arrayShow addObject:visualDisplay];
                }
            }
            if (visualDisplay.states==2)
            {
                if (_btPass.selected)
                {
                    [_arrayShow addObject:visualDisplay];
                }
            }
        }
    }
    else
    {
//        _arrayShow=[[NSMutableArray alloc]initWithArray:_arrayVisualDisplay];
        [_arrayShow removeAllObjects];
        _btMenu.selected=NO;
    }
    
    [_tbVisual reloadData];
}
-(void)setFollowStore:(FollowStore *)followStore
{
    _followStore=followStore;
    _lbBrandName.text=_followStore.strBrandName;
    _lbStoreName.text=_followStore.strStoreName;
    [_lbBrandName Start];
    [_lbStoreName Start];
    [self loadData];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _viewVisualDetail.frame=CGRectMake(self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
    [self addSubview:_viewVisualDetail];
    [UIView beginAnimations:nil context:nil];
    _viewVisualDetail.frame=CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [UIView commitAnimations];
    _viewVisualDetail.followStore=_followStore;
    _viewVisualDetail.storeInfo=_storeInfo;
    _viewVisualDetail.visualDisplay=[_arrayShow objectAtIndex:indexPath.row];
    _viewVisualDetail.vcFrame=self.vcFrame;
    _bVisualDetailView=YES;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_arrayShow.count==0)
    {
        _label.hidden=NO;
        
    }
    else
    {
        _label.hidden=YES;
    }
    return _arrayShow.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RPVisualMerchandisingCell *cell=[tableView dequeueReusableCellWithIdentifier:@"RPVisualMerchandisingCell"];
    if (cell==nil)
    {
        NSArray *arrayNib=[[NSBundle mainBundle]loadNibNamed:@"RPVisualMerchandisingCell" owner:self options:nil];
        cell=[arrayNib objectAtIndex:0];
    }
    cell.visualDisplay=[_arrayShow objectAtIndex:indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 84;
}
-(void)dismissView:(UIView *)view
{
    [UIView beginAnimations:nil context:nil];
    view.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
    [UIView commitAnimations];
    [view endEditing:YES];
}
-(BOOL)OnBack
{
    if (_bAddView)
    {
        if ([_viewAddExhibit OnBack])
        {
            [self dismissView:_viewAddExhibit];
//            [self loadData];
            _bAddView=NO;
        }
        return NO;
    }
    if (_bVisualDetailView)
    {
        if ([_viewVisualDetail OnBack])
        {
            [self dismissView:_viewVisualDetail];
            [self loadData];
            _bVisualDetailView=NO;
        }
        return NO;
    }
    if (_bGuide)
    {
        [self dismissView:_viewGuide];
        _bGuide=NO;
        return NO;
    }
    if (_bStoreInfoView) {
        [self dismissView:_viewStoreInfo];
        _bStoreInfoView=NO;
        return NO;
    }
    return YES;
}

- (IBAction)OnAddExhibit:(id)sender
{
    if ([RPRights hasRightsFunc:_storeInfo.llRights type:RPRightsFuncType_VisualSubmit]) {
        _viewAddExhibit.frame=CGRectMake(self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
        [self addSubview:_viewAddExhibit];
        [UIView beginAnimations:nil context:nil];
        _viewAddExhibit.frame=CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        [UIView commitAnimations];
        _viewAddExhibit.followStore=_followStore;
        _viewAddExhibit.vcFrame=self.vcFrame;
        _viewAddExhibit.delegate=self;
        [_viewAddExhibit clearUI];
        _bAddView=YES;
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:NSLocalizedStringFromTableInBundle(@"You do not have the authority to do this task",@"RPString", g_bundleResorce,nil)];
    }
    
    
    
}
-(void)OnEndAdd
{
    [self dismissView:_viewAddExhibit];
    _bAddView=NO;
    [self loadData];
}
//展开或收缩删选菜单
- (IBAction)OnShowMenu:(id)sender
{
    _bShowMenu = !_bShowMenu;
    _ivTriange.hidden=!_bShowMenu;
    _viewLine.hidden=_bShowMenu;
    
    if (_bShowMenu)
    {
        _viewMenu.hidden=NO;
        _tbVisual.frame = CGRectMake(_tbVisual.frame.origin.x,_viewHead.frame.size.height + _viewMenu.frame.size.height, _tbVisual.frame.size.width, _tbVisual.frame.size.height - _viewMenu.frame.size.height);
    }
    else
    {
        _viewMenu.hidden=YES;
        _tbVisual.frame = CGRectMake(_tbVisual.frame.origin.x,_viewHead.frame.size.height, _tbVisual.frame.size.width, _tbVisual.frame.size.height + _viewMenu.frame.size.height);
    }
}

- (IBAction)OnGuide:(id)sender
{
    _viewGuide.frame=CGRectMake(self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
    [self addSubview:_viewGuide];
    [UIView beginAnimations:nil context:nil];
    _viewGuide.frame=CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    _viewGuide.vcFrame=self.vcFrame;
    [UIView commitAnimations];
    _bGuide=YES;
}

- (IBAction)OnPass:(id)sender
{
    if (_btPending.selected||_btReject.selected)
    {
        _btPass.selected=!_btPass.selected;
        if (_btPass.selected)
        {
            _lbPass.textColor=[UIColor colorWithWhite:0.7 alpha:1];
        }
        else
        {
            _lbPass.textColor=[UIColor colorWithWhite:0.3 alpha:1];
        }
        [self screen:_btPass.selected Reject:_btReject.selected Pending:_btPending.selected];
    }
    
    
}

- (IBAction)OnReject:(id)sender
{
    if (_btPass.selected||_btPending.selected)
    {
        _btReject.selected=!_btReject.selected;
        if (_btReject.selected)
        {
            _lbReject.textColor=[UIColor colorWithWhite:0.7 alpha:1];
        }
        else
        {
            _lbReject.textColor=[UIColor colorWithWhite:0.3 alpha:1];
        }
        [self screen:_btPass.selected Reject:_btReject.selected Pending:_btPending.selected];
    }
}

- (IBAction)OnPending:(id)sender
{
    if (_btPass.selected||_btReject.selected)
    {
        _btPending.selected=!_btPending.selected;
        if (_btPending.selected)
        {
            _lbpending.textColor=[UIColor colorWithWhite:0.7 alpha:1];
        }
        else
        {
            _lbpending.textColor=[UIColor colorWithWhite:0.3 alpha:1];
        }
        [self screen:_btPass.selected Reject:_btReject.selected Pending:_btPending.selected];
    }
    
    
}

- (IBAction)OnStoreInfo:(id)sender
{
    _viewStoreInfo.frame=CGRectMake(self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
    [self addSubview:_viewStoreInfo];
    [UIView beginAnimations:nil context:nil];
    _viewStoreInfo.frame=CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [UIView commitAnimations];
    _bStoreInfoView=YES;
    _viewStoreInfo.storeInfo=_storeInfo;
}

- (IBAction)OnHelp:(id)sender
{
   [RPGuide ShowGuide:self];
}
-(IBAction)OnQuit:(id)sender
{
    [self endEditing:YES];
    NSString * strDesc = NSLocalizedStringFromTableInBundle(@"Confirm to exit?",@"RPString", g_bundleResorce,nil);
    NSString * strOK = NSLocalizedStringFromTableInBundle(@"OK",@"RPString", g_bundleResorce,nil);
    NSString * strCancel = NSLocalizedStringFromTableInBundle(@"CANCEL",@"RPString", g_bundleResorce,nil);
    
    RPBlockUIAlertView *alertView = [[RPBlockUIAlertView alloc] initWithTitle:nil message:strDesc cancelButtonTitle:strCancel clickButton:^(NSInteger indexButton){
        if (indexButton == 1) {
            [self.delegate endVisualMerchandising];
        }
    } otherButtonTitles:strOK,nil];
    [alertView show];
    
}
@end
