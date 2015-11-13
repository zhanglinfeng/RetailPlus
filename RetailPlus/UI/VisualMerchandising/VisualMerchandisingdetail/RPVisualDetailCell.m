//
//  RPVisualDetailCell.m
//  RetailPlus
//
//  Created by zhanglinfeng on 14-6-17.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPVisualDetailCell.h"
#import "RPVisualPictureCell.h"
#import "RPBlockUIAlertView.h"
#import "SVProgressHUD.h"
extern NSBundle * g_bundleResorce;
@implementation RPVisualDetailCell

- (void)awakeFromNib
{
    // Initialization code
    _viewFrame.layer.cornerRadius=6;
    _viewFrame.layer.borderColor=[UIColor lightGrayColor].CGColor;
    _viewFrame.layer.borderWidth=1;
    _tbPic.scrollEnabled=NO;//不可滑动
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setReplyList:(ReplyList *)replyList
{
    _replyList=replyList;
}
-(void)setVmReply:(VMReply *)vmReply
{
    _arrayImg=[[NSMutableArray alloc]init];
    _vmReply=vmReply;
    _lbPoster.text=_vmReply.strUsername;
    _lbcontent.text=_vmReply.strComment;
    _lbDate.text=_vmReply.strDate;
    for (int i=0; i<_vmReply.arrayimgReply.count; i++)
    {
        for (int j=0; j<_replyList.arrayImg.count; j++)
        {
            if ([((ReplyImgDetail*)[_vmReply.arrayimgReply objectAtIndex:i]).strImgId isEqualToString: ((ReplyImg*)[_replyList.arrayImg objectAtIndex:j]).strImgId])
            {
                [_arrayImg addObject:[_replyList.arrayImg objectAtIndex:j]];
            }
        }
    }
    if (_vmReply.type==0)
    {
        _btDelete.hidden=YES;
    }
    else if (_vmReply.type==1)
    {
        if ([_vmReply.strUserId isEqualToString:[RPSDK defaultInstance].userLoginDetail.strUserId])
        {
            _btDelete.hidden=NO;
        }
        else
        {
            _btDelete.hidden=YES;
        }
    }
    
    
    switch (_vmReply.rank) {
        case Rank_Manager:
            _lbPoster.textColor = [UIColor colorWithRed:150.0f/255 green:70.0f/255 blue:150.0f/255 alpha:1];
            break;
        case Rank_StoreManager:
            _lbPoster.textColor = [UIColor colorWithRed:230.0f/255 green:110.0f/255 blue:10.0f/255 alpha:1];
            break;
        case Rank_Assistant:
            _lbPoster.textColor = [UIColor colorWithRed:50.0f/255 green:105.0f/255 blue:175.0f/255 alpha:1];
            break;
        case Rank_Vendor:
            _lbPoster.textColor = [UIColor colorWithRed:150.0f/255 green:170.0f/255 blue:20.0f/255 alpha:1];
            break;
        default:
            break;
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _arrayImg.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 48;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RPVisualPictureCell*cell=[tableView dequeueReusableCellWithIdentifier:@"RPVisualPictureCell"];
    if (cell==nil) {
        NSArray *arrayNib=[[NSBundle mainBundle]loadNibNamed:@"RPVisualDetailCell" owner:self options:nil];
        cell=[arrayNib objectAtIndex:3];
    }
//    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
//    cell.selectedBackgroundView.backgroundColor = [UIColor clearColor];
//    UIImageView *ivTriangle=[[UIImageView alloc]initWithFrame:CGRectMake(0, 6, 28, 28)];
//    ivTriangle.image=[UIImage imageNamed:@"icon_active_arrow@2x.png"];
//    [cell.selectedBackgroundView addSubview:ivTriangle];
    cell.bSelected = (self.indexSelect==indexPath.row) ? YES : NO;
    cell.replyImg=[_arrayImg objectAtIndex:indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _indexSelect=indexPath.row;
//    [_tbPic reloadData];
    ReplyImg *replyImg=[_arrayImg objectAtIndex:indexPath.row];
    [self.delegate GoToImg:replyImg PicIndex:_indexSelect];
}
-(void)setBSelected:(BOOL)bSelected
{
    _bSelected=bSelected;
    if (bSelected)
    {
        
    }
    else
    {
        _indexSelect=-1;
    }
}
- (IBAction)OnDelete:(id)sender
{
    NSString * strOK = NSLocalizedStringFromTableInBundle(@"OK",@"RPString", g_bundleResorce,nil);
    NSString *strCancel=NSLocalizedStringFromTableInBundle(@"CANCEL",@"RPString", g_bundleResorce,nil);
    NSString * strDesc = NSLocalizedStringFromTableInBundle(@"Confirm to delete?",@"RPString", g_bundleResorce,nil);
    RPBlockUIAlertView *alertView = [[RPBlockUIAlertView alloc] initWithTitle:nil message:strDesc cancelButtonTitle:strCancel clickButton:^(NSInteger indexButton){
        if (indexButton == 1)
        {
            [[RPSDK defaultInstance]DelReply:_vmReply.strVisualDisplayId Success:^(id idResult) {
                [self.delegate DeleteReplyEnd];
            } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
                [SVProgressHUD showErrorWithStatus:NSLocalizedStringFromTableInBundle(@"failure",@"RPString", g_bundleResorce,nil)];
            }];
        }
    } otherButtonTitles:strOK,nil];
    [alertView show];
}
@end
