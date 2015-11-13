//
//  RPVisualMerchandisingDetailView.m
//  RetailPlus
//
//  Created by zhanglinfeng on 14-6-17.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPVisualMerchandisingDetailView.h"
//#import "RPVisualDetailCell.h"

#import "RPVisualStateCell.h"
#import "RPBlockUIAlertView.h"
#import "SVProgressHUD.h"
extern NSBundle * g_bundleResorce;
@implementation RPVisualMerchandisingDetailView

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
    UIPanGestureRecognizer *panRecognizer=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handleRecognier:)];
    [panRecognizer setCancelsTouchesInView:YES];
    panRecognizer.cancelsTouchesInView=NO;//为yes只响应优先级最高的事件，Button高于手势，textfield高于手势，textview高于手势，手势高于tableview。为no同时都响应，默认为yes
    [self addGestureRecognizer:panRecognizer];
    
    secondFrameOreginX=_viewRight.frame.origin.x;
    secondFrameOreginY=_viewRight.frame.origin.y;
    
    _viewRemark.frame=CGRectMake(_viewRemark.frame.origin.x, -_viewRemark.frame.size.height, _viewRemark.frame.size.width, _viewRemark.frame.size.height);
    _viewFrame.layer.cornerRadius=10;
    _tbBigPic.pagingEnabled=YES;
    
    _viewBackground.layer.shadowOffset = CGSizeMake(-4, 0);
//    _viewBackground.layer.shadowRadius =3.0;
    _viewBackground.layer.shadowColor =[UIColor blackColor].CGColor;
    _viewBackground.layer.shadowOpacity =0.8;

}
-(void)handleRecognier:(UIPanGestureRecognizer *)recognizer
{
    if (recognizer.state==UIGestureRecognizerStateBegan)
    {
        originalLocation=[recognizer locationInView:self];
        currentLocation=[recognizer locationInView:self];
    }
    if (recognizer.state==UIGestureRecognizerStateChanged)
    {
        currentLocation=[recognizer locationInView:self];
    }
    //    NSLog(@"%f--%f",originalLocation.x,currentLocation.x);
    
    if (secondFrameOreginX>=0)
    {
        //左移
        if (currentLocation.x<originalLocation.x)
        {
            secondFrameOreginX=secondFrameOreginX-(originalLocation.x-currentLocation.x);
            originalLocation.x=currentLocation.x;
            if (secondFrameOreginX<74)
            {
                secondFrameOreginX=74;
            }
            CGRect viewFrame=CGRectMake(secondFrameOreginX, secondFrameOreginY, _viewRight.frame.size.width, _viewRight.frame.size.height);
            [_viewRight setFrame:viewFrame];
        }
        //右移
        if (currentLocation.x>originalLocation.x)
        {
            secondFrameOreginX+=(currentLocation.x-originalLocation.x);
            originalLocation.x=currentLocation.x;
            if (secondFrameOreginX>244)
            {
                secondFrameOreginX=244;
            }
            CGRect viewFrame=CGRectMake(secondFrameOreginX, secondFrameOreginY, _viewRight.frame.size.width, _viewRight.frame.size.height);
            [_viewRight setFrame:viewFrame];
        }
    }
    else
    {
        secondFrameOreginX=0;
//        [self viewWillAppear:YES];
    }
    
    if (recognizer.state==UIGestureRecognizerStateEnded)
    {
        if (secondFrameOreginX<=self.frame.size.width/2+20)
        {
            //动画移动secondView
            CGRect rect=CGRectMake(74, 42, _viewRight.frame.size.width, _viewRight.frame.size.height);
            [self viewSlideAnimation:_viewRight Rect:rect];
            secondFrameOreginX=_viewRight.frame.origin.x;
        }
        if (secondFrameOreginX>self.frame.size.width/2+20)
        {
            CGRect rect=CGRectMake(244, 42, _viewRight.frame.size.width, _viewRight.frame.size.height);
            [self viewSlideAnimation:_viewRight Rect:rect];
            secondFrameOreginX=_viewRight.frame.origin.x;
        }
    }
    
}

//视图移动动画
-(void)viewSlideAnimation:(UIView*)view Rect:(CGRect)rect
{
    [ UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^() {
        [view setFrame:rect];
        
    } completion:^(BOOL finished) {
        
    } ];
}
-(BOOL)OnBack
{
    if (_bVisualCommentView)
    {
        [self dismissView:_viewComment];
        _bVisualCommentView=NO;
        return NO;
    }
    if (_bViewAddPicture)
    {
        [self dismissView:_viewAddPicture];
        _bViewAddPicture=NO;
        return NO;
    }
    if (_bLocationView)
    {
        [UIView beginAnimations:nil context:nil];
        _markViewController.view.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y + self.frame.size.height, self.frame.size.width, self.frame.size.height);
        [UIView commitAnimations];
        _bLocationView = NO;
        return NO;
    }
    return YES;
}
-(void)dismissView:(UIView *)view
{
    [UIView beginAnimations:nil context:nil];
    view.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
    [UIView commitAnimations];
    [view endEditing:YES];
}
-(void)loadData
{
    [SVProgressHUD showWithStatus:@""];
    [[RPSDK defaultInstance]GetReplyList:_visualDisplay.strVisualDisplayId Success:^(ReplyList * replyList) {
        _replyList=replyList;
        _selectIndex=-1;
        [_tbVisualList reloadData];
        [_tbBigPic reloadData];
        [SVProgressHUD dismiss];
    } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
        [SVProgressHUD showErrorWithStatus:NSLocalizedStringFromTableInBundle(@"failure",@"RPString", g_bundleResorce,nil)];
    }];
}
-(void)setFollowStore:(FollowStore *)followStore
{
    _followStore=followStore;
    UIImage *img=[RPSDK loadImageFromURL:_followStore.strShopMap];
    if (img)
    {
        _btLocation.alpha=1;
    }
    else
    {
        _btLocation.alpha=0.3;
    }
}
-(void)setVisualDisplay:(VisualDisplay *)visualDisplay
{
    _visualDisplay=visualDisplay;
    _lbTitle.text=_visualDisplay.strTitle;
    switch (_visualDisplay.states)
    {
        case 0:
        {
            _btRemark.backgroundColor=[UIColor colorWithRed:250.0f/255 green:195.0f/255 blue:0.0f/255 alpha:1];
            [_btRemark setBackgroundImage:[UIImage imageNamed:@"button_status_pending@2x.png"] forState:UIControlStateNormal];
            _lbState.text=NSLocalizedStringFromTableInBundle(@"PENDING",@"RPString", g_bundleResorce,nil);
        }
            break;
        case 1:
        {
            _btRemark.backgroundColor=[UIColor colorWithRed:190.0f/255 green:60.0f/255 blue:70.0f/255 alpha:1];
            [_btRemark setBackgroundImage:[UIImage imageNamed:@"button_status_reject@2x.png"] forState:UIControlStateNormal];
            _lbState.text=NSLocalizedStringFromTableInBundle(@"REJECT",@"RPString", g_bundleResorce,nil);
        }
            break;
        case 2:
        {
            _btRemark.backgroundColor=[UIColor colorWithRed:150.0f/255 green:170.0f/255 blue:20.0f/255 alpha:1];
            [_btRemark setBackgroundImage:[UIImage imageNamed:@"button_status_pass@2x.png"] forState:UIControlStateNormal];
            _lbState.text=NSLocalizedStringFromTableInBundle(@"PASS",@"RPString", g_bundleResorce,nil);
        }
            break;
        default:
            break;
    }
    
    [self loadData];
    [self authority];
}
- (IBAction)OnAddPicture:(id)sender
{
    if ([RPRights hasRightsFunc:self.storeInfo.llRights type:RPRightsFuncType_VisualReply]) {
        _viewAddPicture.frame=CGRectMake(self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
        [self addSubview:_viewAddPicture];
        [UIView beginAnimations:nil context:nil];
        _viewAddPicture.frame=CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        [UIView commitAnimations];
        _viewAddPicture.followStore=_followStore;
        _viewAddPicture.visualDisplay=self.visualDisplay;
        _viewAddPicture.vcFrame=self.vcFrame;
        _viewAddPicture.delegate=self;
        [_viewAddPicture clearUI];
        _bViewAddPicture=YES;
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:NSLocalizedStringFromTableInBundle(@"You do not have the authority to do this task",@"RPString", g_bundleResorce,nil)];
    }
    
    
    
}
-(void)OnEndAdd
{
    [self dismissView:_viewAddPicture];
    _bViewAddPicture=NO;
    [self loadData];
}

//判断添加和引用权限
-(void)authority
{
    if (_visualDisplay.states==2)
    {
        _btAdd.userInteractionEnabled=NO;
        _btAdd.alpha=0.3;
    }
    else
    {
        _btAdd.userInteractionEnabled=YES;
        _btAdd.alpha=1;
    }
}

-(void)upDateState:(int)state
{
    if (_visualDisplay.states==state)
    {
        return;
    }
    [[RPSDK defaultInstance]UpdateVisualDisplayStatus:_visualDisplay.strVisualDisplayId Status:state Success:^(id idResult) {
        _visualDisplay.states=state;
        [self authority];
        [self loadData];
        switch (state)
        {
            case 0:
            {
                _btRemark.backgroundColor=[UIColor colorWithRed:250.0f/255 green:195.0f/255 blue:0.0f/255 alpha:1];
                [_btRemark setBackgroundImage:[UIImage imageNamed:@"button_status_pending@2x.png"] forState:UIControlStateNormal];
                _lbState.text=NSLocalizedStringFromTableInBundle(@"PENDING",@"RPString", g_bundleResorce,nil);
            }
                break;
            case 1:
            {
                _btRemark.backgroundColor=[UIColor colorWithRed:190.0f/255 green:60.0f/255 blue:70.0f/255 alpha:1];
                [_btRemark setBackgroundImage:[UIImage imageNamed:@"button_status_reject@2x.png"] forState:UIControlStateNormal];
                _lbState.text=NSLocalizedStringFromTableInBundle(@"REJECT",@"RPString", g_bundleResorce,nil);
            }
                break;
            case 2:
            {
                _btRemark.backgroundColor=[UIColor colorWithRed:150.0f/255 green:170.0f/255 blue:20.0f/255 alpha:1];
                [_btRemark setBackgroundImage:[UIImage imageNamed:@"button_status_pass@2x.png"] forState:UIControlStateNormal];
                _lbState.text=NSLocalizedStringFromTableInBundle(@"PASS",@"RPString", g_bundleResorce,nil);
            }
                break;
            default:
                break;
        }
        
    } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
       [SVProgressHUD showErrorWithStatus:NSLocalizedStringFromTableInBundle(@"failure",@"RPString", g_bundleResorce,nil)]; 
    }];
}
- (IBAction)OnPass:(id)sender
{
    
    [self OnRemarkView:nil];
    [self upDateState:2];
}

- (IBAction)OnReject:(id)sender
{
    
    [self OnRemarkView:nil];
    [self upDateState:1];
}

- (IBAction)OnPending:(id)sender
{
    
    [self OnRemarkView:nil];
    [self upDateState:0];
}

- (IBAction)OnRemarkView:(id)sender
{
    if ([RPRights hasRightsFunc:self.storeInfo.llRights type:RPRightsFuncType_VisualModifyStatus]) {
        _btRemark.selected=!_btRemark.selected;
        if (_btRemark.selected)
        {
            [UIView beginAnimations:nil context:nil];
            _viewRemark.frame=CGRectMake(_viewRemark.frame.origin.x, 42, _viewRemark.frame.size.width, _viewRemark.frame.size.height);
            [UIView commitAnimations];
        }
        else
        {
            [UIView beginAnimations:nil context:nil];
            _viewRemark.frame=CGRectMake(_viewRemark.frame.origin.x,-_viewRemark.frame.size.height, _viewRemark.frame.size.width, _viewRemark.frame.size.height);
            [UIView commitAnimations];
        }
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:NSLocalizedStringFromTableInBundle(@"You do not have the authority to do this task",@"RPString", g_bundleResorce,nil)];
    }
    
    
}

- (IBAction)OnLocation:(id)sender
{
    [self endEditing:YES];
    _markViewController = nil;
    UIImage *img=[RPSDK loadImageFromURL:self.followStore.strShopMap];
    if (img)
    {
        _markViewController = [[MarkViewController alloc] initWithNibName:nil bundle:nil cadImage:img curentPoint:CGPointMake(_visualDisplay.x, _visualDisplay.y) isMarked:YES];
        _markViewController.delegate = self;
        _markViewController.view.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y + self.frame.size.height, self.frame.size.width, self.frame.size.height);
        [self.superview addSubview:_markViewController.view];
        
        [UIView beginAnimations:nil context:nil];
        _markViewController.view.frame = self.frame;
        [UIView commitAnimations];
        _bLocationView = YES;
//        _ivLocated.hidden=YES;
    }
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height-42)];
    [_markViewController.view addSubview:view];
}
-(void)Markend:(CGPoint)point isMarked:(BOOL)bMarked
{
    [UIView beginAnimations:nil context:nil];
    _markViewController.view.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y + self.frame.size.height, self.frame.size.width, self.frame.size.height);
    [UIView commitAnimations];
    _bLocationView = NO;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==_tbVisualList)
    {
        VMReply *vmReply=[_replyList.arrayReply objectAtIndex:indexPath.row];
        if (vmReply.type==0||vmReply.type==1)//原帖或者回复
        {
            RPVisualDetailCell *cell=[tableView dequeueReusableCellWithIdentifier:@"RPVisualDetailCell"];
            if (cell==nil)
            {
                NSArray *arrayNib=[[NSBundle mainBundle] loadNibNamed:@"RPVisualDetailCell" owner:self options:nil];
                cell=[arrayNib objectAtIndex:0];
            }
            cell.delegate=self;
            cell.replyList=_replyList;
            cell.vmReply=vmReply;
            cell.indexSelect=_selectPicIndex;
            cell.bSelected = (_selectIndex==indexPath.row) ? YES : NO;
            
            return cell;
        }
        else if(vmReply.type==3)//标记状态
        {
            RPVisualStateCell *cell=[tableView dequeueReusableCellWithIdentifier:@"RPVisualStateCell"];
            if (cell==nil)
            {
                NSArray *arrayNib=[[NSBundle mainBundle] loadNibNamed:@"RPVisualDetailCell" owner:self options:nil];
                cell=[arrayNib objectAtIndex:2];
            }
            cell.vmReply=vmReply;
            return cell;
        }
        else//引用
        {
            RPVisualCommentCell *cell=[tableView dequeueReusableCellWithIdentifier:@"RPVisualCommentCell"];
            if (cell==nil)
            {
                NSArray *arrayNib=[[NSBundle mainBundle] loadNibNamed:@"RPVisualDetailCell" owner:self options:nil];
                cell=[arrayNib objectAtIndex:1];
            }
            cell.delegate=self;
            cell.replyList=_replyList;
            cell.vmReply=vmReply;
            cell.bSelected = (_selectIndex==indexPath.row) ? YES : NO;
            return cell;
        }
    }
    else
    {
        ReplyImg *replyImg=[_replyList.arrayImg objectAtIndex:indexPath.row];
        RPBigVisualDetailCell *cell=[tableView dequeueReusableCellWithIdentifier:@"RPBigVisualDetailCell"];
        if (cell==nil) {
            NSArray *arrayNib=[[NSBundle mainBundle]loadNibNamed:@"RPVisualDetailCell" owner:self options:nil];
            cell=[arrayNib objectAtIndex:4];
        }
        cell.replyList=_replyList;
        cell.replyImg=replyImg;
        cell.visualDisplay=_visualDisplay;
        cell.delegate=self;
        cell.delegateGoToSmall=self;
        if (indexPath.row==_bigPicIndex)
        {
            [cell SetSelectReply:_imgDetailId];
        }
        return cell;
    }
    
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==_tbVisualList)
    {
        VMReply*vmReply=[_replyList.arrayReply objectAtIndex:indexPath.row];
        if (vmReply.type==2)//引用
        {
            for (int i=0; i<_replyList.arrayImg.count; i++)
            {
                if ([((ReplyImgDetail *)[vmReply.arrayimgReply objectAtIndex:0]).strImgId isEqualToString: ((ReplyImg*)[_replyList.arrayImg objectAtIndex:i]).strImgId])
                {
                    //            [self GoToImg:[_replyList.arrayImg objectAtIndex:i]];
                    _bigPicIndex=i;
                    _imgDetailId=vmReply.strVisualDisplayId;
                    [_tbBigPic reloadData];
                    [_tbBigPic setContentOffset:CGPointMake(0, i*_tbBigPic.frame.size.height) animated:YES];
                    
                    
                }
            }
             _selectIndex=indexPath.row;
        }
       
    }
    
    [_tbVisualList reloadData];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==_tbVisualList)
    {
        VMReply *vmReply=[_replyList.arrayReply objectAtIndex:indexPath.row];
        if (vmReply.type==0||vmReply.type==1)
        {
            return 96+vmReply.arrayimgReply.count*48;
        }
        else if(vmReply.type==3)
        {
            return 68;
        }
        else
        {
            return 88;
        }
    }
    else
    {
        return _tbBigPic.frame.size.height;
    }
    
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==_tbVisualList)
    {
        return _replyList.arrayReply.count;
    }
    else
    {
        return _replyList.arrayImg.count;
    }
}
-(void)OnGoComment:(ReplyImg *)replyImg
{
    _viewComment.frame=CGRectMake(self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
    [self addSubview:_viewComment];
    [UIView beginAnimations:nil context:nil];
    _viewComment.frame=CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [UIView commitAnimations];
    _viewComment.visualDisplay=_visualDisplay;
    _viewComment.followStore=_followStore;
    _viewComment.replyImg=replyImg;
    _viewComment.delegate=self;
    _bVisualCommentView=YES;
}
-(void)OnMarkInViewEnd
{
    [self dismissView:_viewComment];
    [self loadData];
    _bVisualCommentView=NO;
}
//左边滑到相应图片
-(void)GoToImg:(ReplyImg *)image PicIndex:(int)index
{
    _selectPicIndex=index;
    
    //找到左边对应图的VMReply  id
    for (int i=0; i<_replyList.arrayReply.count; i++)
    {
        NSArray *array=((VMReply*)[_replyList.arrayReply objectAtIndex:i]).arrayimgReply;
        for (int j = 0; j<array.count; j++)
        {
            if ([image.strImgId isEqualToString: ((ReplyImgDetail*)[array objectAtIndex:j]).strImgId])
            {
                //只找到新加或回复中与该图片id匹配的图片所在VMReply 的id
                if (((VMReply*)[_replyList.arrayReply objectAtIndex:i]).type==0||((VMReply*)[_replyList.arrayReply objectAtIndex:i]).type==1)
                {
                    _imgDetailId=((VMReply*)[_replyList.arrayReply objectAtIndex:i]).strVisualDisplayId;
                }
                
            }
        }
        
    }
    
    //找到左边图片对应行
    for (int i=0; i<_replyList.arrayImg.count; i++)
    {
        if ([image.strImgId isEqualToString:((ReplyImg*)[_replyList.arrayImg objectAtIndex:i]).strImgId])
        {
//            [_tbVisualList reloadData];//暂时不用
            _bigPicIndex=i;
            [_tbBigPic reloadData];
            [_tbBigPic setContentOffset:CGPointMake(0, i*_tbBigPic.frame.size.height) animated:YES];
        }
    }
    
    //找到新帖或回复标三角的行
    for (int i=0; i<_replyList.arrayReply.count; i++)
    {
        NSArray *array=((VMReply*)[_replyList.arrayReply objectAtIndex:i]).arrayimgReply;
        for (int j = 0; j<array.count; j++)
        {
            
            if ([image.strImgId isEqualToString: ((ReplyImgDetail*)[array objectAtIndex:j]).strImgId])
            {
                VMReply *vmReply=[_replyList.arrayReply objectAtIndex:i];
                if (vmReply.type==0||vmReply.type==1)
                {
                    _selectIndex=i;
                    [_tbVisualList reloadData];
                }
                
            }
        }
        
    }
    
    
}
//右边滑到相应图片
-(void)GoToSmall:(int)indexVMReply ImgDetailIndex:(int)indexReplyImgDetail Type:(int)type
{
    _selectIndex=indexVMReply;
    _selectPicIndex=indexReplyImgDetail;
    [_tbVisualList reloadData];
    NSIndexPath *idxPath = [NSIndexPath indexPathForRow:indexVMReply inSection:0];
    [_tbVisualList scrollToRowAtIndexPath:idxPath
                          atScrollPosition:UITableViewScrollPositionTop
                                  animated:YES];
}
//删除引用后刷新
-(void)DeleteEnd
{
    [self loadData];
}
//删除回复后刷新
-(void)DeleteReplyEnd
{
    [self loadData];
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
            [self.delegate endVisualDetail];
        }
    } otherButtonTitles:strOK,nil];
    [alertView show];
    
}
@end
