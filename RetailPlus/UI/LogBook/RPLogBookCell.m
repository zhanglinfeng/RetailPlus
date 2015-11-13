//
//  RPLogBookCell.m
//  RetailPlus
//
//  Created by lin dong on 14-3-4.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPLogBookCell.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "RPLogBookCommentCell.h"
#import "SVProgressHUD.h"
#import "RPBlockUIAlertView.h"

extern NSBundle * g_bundleResorce;
#define COMMENTCELL_HEIGHT   42

@implementation RPLogBookCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}
-(void)awakeFromNib
{
    
    _btPost.userInteractionEnabled = NO;
    _btFocus.userInteractionEnabled = NO;
    _viewTag.layer.cornerRadius = 4;
    _ivPostUser.layer.cornerRadius=6;
    _ivPostUser.layer.borderWidth=1;
    _ivPostUser.layer.borderColor=[[UIColor colorWithWhite:0.7 alpha:1]CGColor];
    _btLogBookImage1.layer.cornerRadius=6;
    _btLogBookImage1.layer.borderWidth=1;
    _btLogBookImage1.layer.borderColor=[[UIColor colorWithWhite:0.7 alpha:1]CGColor];
    _btLogBookImage2.layer.cornerRadius=6;
    _btLogBookImage2.layer.borderWidth=1;
    _btLogBookImage2.layer.borderColor=[[UIColor colorWithWhite:0.7 alpha:1]CGColor];
    _btLogBookImage3.layer.cornerRadius=6;
    _btLogBookImage3.layer.borderWidth=1;
    _btLogBookImage3.layer.borderColor=[[UIColor colorWithWhite:0.7 alpha:1]CGColor];
}
+ (NSInteger)calcLabelHeight:(NSString *)strText
{
    NSInteger nLableHeight = 68;

    CGSize size = [strText sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(300, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    if ((size.height + 20) > 68) {
        nLableHeight = size.height + 20;
    }
    else
    {
        nLableHeight = (size.height + 20);
    }
    
    return nLableHeight;
}


+ (NSInteger)calcCellHeight:(LogBookDetail *)detail
{
    NSInteger nLableHeight = [RPLogBookCell calcLabelHeight:detail.strDesc];
    
    NSInteger nCommentHeight = 0;
    if (detail.bExpand) {
        NSInteger nCount = detail.arrayComment.count;
        if (nCount == 0) {
            nCount = 1;
        }
        nCommentHeight = nCount * COMMENTCELL_HEIGHT;
    }
    
    if (detail.arrayImageSmall.count == 0)
        return 8 + 18  + 66 + 38 + 12 + nLableHeight + nCommentHeight ;
    
    return 8 + 18 + 66 + 90 + 38 + 12 + nLableHeight + nCommentHeight ;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(NSString *)getDate:(NSDate *)date
{
    NSString *s;
    NSDate *nowTime =[NSDate date];
    NSCalendar*calendar=[NSCalendar currentCalendar];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    NSDateComponents*components1 =[calendar components:(NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit) fromDate:nowTime];
    
    NSDateComponents*components2 =[calendar components:(NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit) fromDate:date];
    if ([components1 year]==[components2 year]&&[components1 month]==[components2 month]&&[components1 day]==[components2 day])
    {
        NSString *str=NSLocalizedStringFromTableInBundle(@"Today",@"RPString", g_bundleResorce,nil);
        s=[NSString stringWithFormat:@"%@ %02d:%02d",str,[components2 hour],[components2 minute]];
    }
    else
    {
        s=[dateFormatter stringFromDate:date];
    }
    return s;
}
-(void)setStoreSelected:(StoreDetailInfo *)storeSelected
{
    _storeSelected=storeSelected;
}
-(void)setDetail:(LogBookDetail *)detail
{
    NSString* strOther = NSLocalizedStringFromTableInBundle(@"Other",@"RPString", g_bundleResorce,nil);
    _detail = detail;
    if (detail.strTagDesc.length==0) {
        _lbTag.text = strOther;
    }else{
        _lbTag.text = detail.strTagDesc;
//        //labe最多显示20个字符
//        if (_lbTag.text.length > 20) {
//            NSRange range = {0,20};
//            NSString* str = [_lbTag.text substringWithRange:range];
//            _lbTag.text = [str stringByAppendingString:@""];
//        }
    }
    CGSize lbTagSize = [_lbTag.text sizeWithFont:[UIFont systemFontOfSize:8.0] constrainedToSize:CGSizeMake( MAXFLOAT,18)];
    if (lbTagSize.width < 38) {//label的最小宽度
        lbTagSize.width = 38;
    }
    
    _viewTag.frame = CGRectMake(5, 8, lbTagSize.width+10, 50);
    _lbTag.frame = CGRectMake(5, 0, lbTagSize.width, 18);
    
    if ([detail.strTagId isEqualToString:self.themeId] ) {
        _viewTag.backgroundColor = [UIColor colorWithRed:225.0/255 green:130.0/255 blue:0 alpha:1];
    }
    
      _viewFrame.layer.cornerRadius = 8;
    
    [_ivPostUser setImageWithURLString:detail.userPost.strPortraitImg placeholderImage:[UIImage imageNamed:@"icon_userimage01_224.png"]];
    
    if (detail.bMyPost)
    {
        
        
//        [_btDelete setBackgroundImage:[UIImage imageNamed:@"button_delete_post_actv@2x.png"] forState:UIControlStateNormal];
        _btDelete.alpha=1;
        _btDelete.userInteractionEnabled=YES;
    }
    else
    {
//        [_btDelete setBackgroundImage:[UIImage imageNamed:@"button_delete_post_noactv@2x.png"] forState:UIControlStateNormal];
        _btDelete.alpha=0.4;
        _btDelete.userInteractionEnabled=NO;
    }
    _lbDateTime.text=[self getDate:detail.dtPostTime];
    _lbPostUser.text=[NSString stringWithFormat:@"%@",detail.userPost.strFirstName];
    _lbTitle.text=detail.strTitle;
    _lbCommentUserCount.text=[NSString stringWithFormat:@"%d",detail.nCommentCount];
    switch (detail.userPost.rank) {
        case Rank_Manager:
            _lbPostUser.textColor = [UIColor colorWithRed:150.0f/255 green:70.0f/255 blue:150.0f/255 alpha:1];
            break;
        case Rank_StoreManager:
            _lbPostUser.textColor = [UIColor colorWithRed:230.0f/255 green:110.0f/255 blue:10.0f/255 alpha:1];
            break;
        case Rank_Assistant:
            _lbPostUser.textColor = [UIColor colorWithRed:50.0f/255 green:105.0f/255 blue:175.0f/255 alpha:1];
            break;
        case Rank_Vendor:
            _lbPostUser.textColor = [UIColor colorWithRed:150.0f/255 green:170.0f/255 blue:20.0f/255 alpha:1];
            break;
        default:
            break;
    }
//    _btPost.hidden=!detail.bMyPost;
//    _btFocus.hidden = !detail.bFocus;
    if (detail.bMyPost)
    {
        _btPost.alpha=1;
    }
    else
    {
        _btPost.alpha=0.2;
    }
    if (detail.bFocus)
    {
        _btFocus.alpha=1;
    }
    else
    {
        _btFocus.alpha=0.2;
    }
    [_btFocusCheck setSelected:_detail.bFocus];
    
    if (detail.arrayImageSmall.count==0)
    {
//        [_btLogBookImage1 setImage:[UIImage imageNamed:@"icon_empty_photo@2x.png"] forState:UIControlStateNormal];
//        [_btLogBookImage2 setImage:[UIImage imageNamed:@"icon_userimage01_224.png"] forState:UIControlStateNormal];
//        [_btLogBookImage3 setImage:[UIImage imageNamed:@"icon_userimage01_224.png"] forState:UIControlStateNormal];
        _btLogBookImage1.hidden = YES;
        _btLogBookImage2.hidden = YES;
        _btLogBookImage3.hidden = YES;
    }
    else if(detail.arrayImageSmall.count==1)
    {
        [_btLogBookImage1 setImageWithURLString:[detail.arrayImageSmall objectAtIndex:0] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"icon_empty_photo@2x.png"]];
//        [_btLogBookImage2 setImage:[UIImage imageNamed:@"icon_userimage01_224.png"] forState:UIControlStateNormal];
//        [_btLogBookImage3 setImage:[UIImage imageNamed:@"icon_userimage01_224.png"] forState:UIControlStateNormal];
        _btLogBookImage2.hidden=YES;
        _btLogBookImage3.hidden=YES;
    }
    else if(detail.arrayImageSmall.count==2)
    {
        [_btLogBookImage1 setImageWithURLString:[detail.arrayImageSmall objectAtIndex:0] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"icon_empty_photo@2x.png"]];
        [_btLogBookImage2 setImageWithURLString:[detail.arrayImageSmall objectAtIndex:1] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"icon_empty_photo@2x.png"]];
//        [_btLogBookImage3 setImage:[UIImage imageNamed:@"icon_userimage01_224.png"] forState:UIControlStateNormal];
        _btLogBookImage3.hidden=YES;
    }
    else if(detail.arrayImageSmall.count==3)
    {
        [_btLogBookImage1 setImageWithURLString:[detail.arrayImageSmall objectAtIndex:0] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"icon_empty_photo@2x.png"]];
        [_btLogBookImage2 setImageWithURLString:[detail.arrayImageSmall objectAtIndex:1] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"icon_empty_photo@2x.png"]];
        [_btLogBookImage3 setImageWithURLString:[detail.arrayImageSmall objectAtIndex:2] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"icon_empty_photo@2x.png"]];
    }
    if (detail.bRead) {
        [_btReadMark setBackgroundImage:[UIImage imageNamed:@"icon_readcheck@2x.png"] forState:UIControlStateNormal];
    }
    else
    {
        [_btReadMark setBackgroundImage:[UIImage imageNamed:@"button_read_mark@2x.png"] forState:UIControlStateNormal];
    }
    
    if (detail.bExpand)
    {
        NSInteger nCount = detail.arrayComment.count;
        if (detail.arrayComment.count == 0) {
            nCount = 1;
        }
        _tbComment.frame = CGRectMake(_tbComment.frame.origin.x, _tbComment.frame.origin.y, _tbComment.frame.size.width, COMMENTCELL_HEIGHT * nCount);
        [_btExpend setBackgroundImage:[UIImage imageNamed:@"button_hide_com@2x.png"] forState:UIControlStateNormal];
        
    }
    else
    {
        _tbComment.frame = CGRectMake(_tbComment.frame.origin.x, _tbComment.frame.origin.y, _tbComment.frame.size.width, 0);
        [_btExpend setBackgroundImage:[UIImage imageNamed:@"button_expend_com@2x.png"] forState:UIControlStateNormal];
    }
    
    CGSize size = [_detail.strDesc sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(300, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    
    _lbDesc.frame = CGRectMake(_lbDesc.frame.origin.x,_lbDesc.frame.origin.y,_lbDesc.frame.size.width,size.height + 20);
    
    NSInteger nHeight = _viewImage.frame.size.height + _viewCommand.frame.size.height + 12 + _tbComment.frame.size.height;
    NSInteger nBeginPos = _viewTop.frame.size.height + _lbDesc.frame.size.height;
    
    _viewBottom.frame = CGRectMake(_viewBottom.frame.origin.x,
                                   nBeginPos,
                                   _viewBottom.frame.size.width,
                                   nHeight);
    
    CGRect rc;
    if (_detail.arrayImageSmall.count == 0)
    {
        rc = CGRectMake(_viewFrame.frame.origin.x, _viewFrame.frame.origin.y, _viewFrame.frame.size.width, _viewTop.frame.size.height + _lbDesc.frame.size.height + _viewBottom.frame.size.height - 90);
        _viewCommand.frame = CGRectMake(0, 0, _viewCommand.frame.size.width, _viewCommand.frame.size.height);
        _tbComment.frame = CGRectMake(0, _viewCommand.frame.size.height, _tbComment.frame.size.width, _tbComment.frame.size.height);
    }
    else
    {
        rc = CGRectMake(_viewFrame.frame.origin.x, _viewFrame.frame.origin.y, _viewFrame.frame.size.width, _viewTop.frame.size.height + _lbDesc.frame.size.height + _viewBottom.frame.size.height);
        _viewCommand.frame = CGRectMake(0, 90, _viewCommand.frame.size.width, _viewCommand.frame.size.height);
        _tbComment.frame = CGRectMake(0, 90 + _viewCommand.frame.size.height, _tbComment.frame.size.width, _tbComment.frame.size.height);
    }
    _viewFrame.frame = rc;
    
    _lbDesc.text = _detail.strDesc;
    
    [_tbComment reloadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_detail.arrayComment.count == 0) {
        return 1;
    }
    return _detail.arrayComment.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_detail.arrayComment.count != 0) {
        LogBookDetail * comment = (LogBookDetail *)[_detail.arrayComment objectAtIndex:indexPath.row];
        RPLogBookCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RPLogBookCommentCell"];
        if (cell == nil)
        {
            NSArray *array=[g_bundleResorce loadNibNamed:@"RPLogBookCommentCell" owner:self options:nil];
            cell = [array objectAtIndex:0];
        }
        cell.comment = comment;
        return cell;
    }
    else
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RPLogBookNoCommentCell"];
        if (cell == nil)
        {
            NSArray *array=[g_bundleResorce loadNibNamed:@"RPLogBookCommentCell" owner:self options:nil];
            cell = [array objectAtIndex:1];
        }
        return cell;
    }
    
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return COMMENTCELL_HEIGHT;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * strDesc = NSLocalizedStringFromTableInBundle(@"You want to...",@"RPString", g_bundleResorce,nil);
    NSString *strCancel=NSLocalizedStringFromTableInBundle(@"CANCEL",@"RPString", g_bundleResorce,nil);
    NSString *strMark=NSLocalizedStringFromTableInBundle(@"Mark as \"Read\"",@"RPString", g_bundleResorce,nil);
    NSString *strMake=NSLocalizedStringFromTableInBundle(@"Make comments",@"RPString", g_bundleResorce,nil);
    NSString *strHide=NSLocalizedStringFromTableInBundle(@"Hide comments",@"RPString", g_bundleResorce,nil);
    if (_detail.bRead)
    {
        RPBlockUIAlertView *alertView=[[RPBlockUIAlertView alloc]initWithTitle:nil message:strDesc cancelButtonTitle:strCancel clickButton:^(NSInteger indexButton) {
            if (indexButton==0)
            {
                
            }
            else if(indexButton==1)
            {
                [self OnComment:nil];
            }
            else
            {
                [self OnShowComment:nil];
            }
        }otherButtonTitles:strMake,strHide, nil];
        [alertView show];
    }
    else
    {
        RPBlockUIAlertView *alertView=[[RPBlockUIAlertView alloc]initWithTitle:nil message:strDesc cancelButtonTitle:strCancel clickButton:^(NSInteger indexButton) {
            if (indexButton==0)
            {
                
            }
            else if(indexButton==1)
            {
                [self OnRead:nil];
            }
            else if(indexButton==2)
            {
                [self OnComment:nil];
            }
            else
            {
                [self OnShowComment:nil];
            }
        }otherButtonTitles:strMark,strMake,strHide, nil];
        [alertView show];
    }
}
-(void)PostCommentEnd
{
    _detail.bRead = YES;
    _detail.bExpand = YES;
    [self LoadComment];
}

-(IBAction)OnComment:(id)sender
{
    _viewComment.detail = _detail;
    _viewComment.storeSelected=_storeSelected;
    _viewComment.delegate = self;
    [_viewComment ShowCommentView];
}

-(void)LoadComment
{
    if (_detail.bExpand) {
        [SVProgressHUD showWithStatus:@""];
        [_detail.arrayComment removeAllObjects];
        _detail.nCommentCount = 0;
        
        [[RPSDK defaultInstance]GetLogBookCommentList:_storeSelected.strStoreId LogBookId:_detail.strID Success:^(NSMutableArray *array) {
            _detail.arrayComment=array;
            _detail.nCommentCount = array.count;
            [_delegate UpdateDetailTable];
            [SVProgressHUD dismiss];
        } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
            [_delegate UpdateDetailTable];
            [SVProgressHUD dismiss];
        }];
    }
    else
        [_delegate UpdateDetailTable];
}

-(IBAction)OnShowComment:(id)sender
{
    _detail.bExpand = !_detail.bExpand;
    [self LoadComment];
}

-(IBAction)OnRead:(id)sender
{
    if (_detail.bRead) {
        return;
    }
    [SVProgressHUD showWithStatus:@""];
    [[RPSDK defaultInstance] CommentLogBook:_storeSelected.strStoreId LogBookID:_detail.strID Comment:@"" Success:^(id idResult) {
        _detail.bRead = YES;
        _detail.bExpand = YES;
        [self LoadComment];
    } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
        [SVProgressHUD dismiss];
    }];
    
}

- (IBAction)showMenu:(id)sender
{
    _viewCommandDetail.hidden=!_viewCommandDetail.hidden;
    _viewCommandDetail.frame=CGRectMake(320, _viewCommandDetail.frame.origin.y, _viewCommandDetail.frame.size.width, _viewCommandDetail.frame.size.height);
    [UIView beginAnimations:nil context:nil];
    _viewCommandDetail.frame=CGRectMake(126, _viewCommandDetail.frame.origin.y, _viewCommandDetail.frame.size.width, _viewCommandDetail.frame.size.height);
    [UIView commitAnimations];
    
}

- (IBAction)OnPic1:(id)sender
{
    if (_detail.arrayImageBig.count > 0) {
        [_viewShowImg ShowImageView:[_btLogBookImage1 imageForState:UIControlStateNormal] URL:[_detail.arrayImageBig objectAtIndex:0] Array:_detail.arrayImageBig];
    }
}

- (IBAction)OnPic2:(id)sender
{
    if (_detail.arrayImageBig.count > 1) {
        [_viewShowImg ShowImageView:[_btLogBookImage2 imageForState:UIControlStateNormal] URL:[_detail.arrayImageBig objectAtIndex:1]Array:_detail.arrayImageBig];
    }
}

- (IBAction)OnPic3:(id)sender
{
    if (_detail.arrayImageBig.count > 2) {
        [_viewShowImg ShowImageView:[_btLogBookImage3 imageForState:UIControlStateNormal] URL:[_detail.arrayImageBig objectAtIndex:2]Array:_detail.arrayImageBig];
    }
}

- (IBAction)Ondelete:(id)sender
{
    NSString * strOK = NSLocalizedStringFromTableInBundle(@"OK",@"RPString", g_bundleResorce,nil);
    NSString *strCancel=NSLocalizedStringFromTableInBundle(@"CANCEL",@"RPString", g_bundleResorce,nil);
    NSString * strDesc = NSLocalizedStringFromTableInBundle(@"Confirm to delete?",@"RPString", g_bundleResorce,nil);
    RPBlockUIAlertView *alertView = [[RPBlockUIAlertView alloc] initWithTitle:nil message:strDesc cancelButtonTitle:strCancel clickButton:^(NSInteger indexButton){
        if (indexButton == 1)
        {
            [[RPSDK defaultInstance]DeleteLogBook:_detail.strID Success:^(id idResult) {
                [_delegate deleteEnd];
            } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
                [SVProgressHUD showErrorWithStatus:NSLocalizedStringFromTableInBundle(@"failure",@"RPString", g_bundleResorce,nil)];
            }];
        }
    } otherButtonTitles:strOK,nil];
    [alertView show];
}

- (IBAction)Onfocus:(id)sender
{
    [SVProgressHUD showWithStatus:@""];
    [[RPSDK defaultInstance] FocusLogBook:_detail.strID Focus:!(_detail.bFocus) Success:^(id idResult) {
        _detail.bFocus = !_detail.bFocus;
        self.detail = _detail;
        [SVProgressHUD dismiss];
        [_delegate deleteEnd];//与删除共用一个刷新
    } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
        [SVProgressHUD dismiss];
    }];
}
@end
