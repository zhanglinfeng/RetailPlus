//
//  RPVisualCommentCell.m
//  RetailPlus
//
//  Created by zhanglinfeng on 14-6-17.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPVisualCommentCell.h"
#import "UIImageView+WebCache.h"
#import "RPBlockUIAlertView.h"
#import "SVProgressHUD.h"
extern NSBundle * g_bundleResorce;
@implementation RPVisualCommentCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
    _viewFrame.layer.cornerRadius=6;
    _viewFrame.layer.borderColor=[UIColor lightGrayColor].CGColor;
    _viewFrame.layer.borderWidth=1;
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
    _vmReply=vmReply;
    _lbName.text=vmReply.strUsername;
    _lbComment.text=vmReply.strComment;
    _lbDate.text=vmReply.strDate;
    for (int i=0; i<_replyList.arrayImg.count; i++)
    {
        if ([((ReplyImgDetail*)[_vmReply.arrayimgReply objectAtIndex:0]).strImgId isEqualToString: ((ReplyImg*)[_replyList.arrayImg objectAtIndex:i]).strImgId])
        {
            [_ivPic setImageWithURLString:((ReplyImg*)[_replyList.arrayImg objectAtIndex:i]).strThumbPath];
        }
    }
    
    if ([_vmReply.strUserId isEqualToString:[RPSDK defaultInstance].userLoginDetail.strUserId])
    {
        _btDelete.hidden=NO;
    }
    else
    {
        _btDelete.hidden=YES;
    }
    
    
    switch (_vmReply.rank) {
        case Rank_Manager:
            _lbName.textColor = [UIColor colorWithRed:150.0f/255 green:70.0f/255 blue:150.0f/255 alpha:1];
            break;
        case Rank_StoreManager:
            _lbName.textColor = [UIColor colorWithRed:230.0f/255 green:110.0f/255 blue:10.0f/255 alpha:1];
            break;
        case Rank_Assistant:
            _lbName.textColor = [UIColor colorWithRed:50.0f/255 green:105.0f/255 blue:175.0f/255 alpha:1];
            break;
        case Rank_Vendor:
            _lbName.textColor = [UIColor colorWithRed:150.0f/255 green:170.0f/255 blue:20.0f/255 alpha:1];
            break;
        default:
            break;
    }
}
- (IBAction)OnDelete:(id)sender
{
//    if ([_vmReply.strUserId isEqualToString:[RPSDK defaultInstance].userLoginDetail.strUserId])
//    {
        NSString * strOK = NSLocalizedStringFromTableInBundle(@"OK",@"RPString", g_bundleResorce,nil);
        NSString *strCancel=NSLocalizedStringFromTableInBundle(@"CANCEL",@"RPString", g_bundleResorce,nil);
        NSString * strDesc = NSLocalizedStringFromTableInBundle(@"Confirm to delete?",@"RPString", g_bundleResorce,nil);
        RPBlockUIAlertView *alertView = [[RPBlockUIAlertView alloc] initWithTitle:nil message:strDesc cancelButtonTitle:strCancel clickButton:^(NSInteger indexButton){
            if (indexButton == 1)
            {
                [[RPSDK defaultInstance]DelReply:_vmReply.strVisualDisplayId Success:^(id idResult) {
                    [self.delegate DeleteEnd];
                } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
                    [SVProgressHUD showErrorWithStatus:NSLocalizedStringFromTableInBundle(@"failure",@"RPString", g_bundleResorce,nil)];
                }];
            }
        } otherButtonTitles:strOK,nil];
        [alertView show];
//    }
//    else
//    {
//        [SVProgressHUD showErrorWithStatus:NSLocalizedStringFromTableInBundle(@"You do not have the authority to do this task",@"RPString", g_bundleResorce,nil)];
//    }
    
    
}
-(void)setBSelected:(BOOL)bSelected
{
    _bSelected=bSelected;
    if (bSelected)
    {
        _ivSelect.hidden=NO;
//        _viewSelect.layer.borderColor=[UIColor colorWithRed:150.0f/255 green:170.0f/255 blue:20.0f/255 alpha:1].CGColor;
//        _viewSelect.layer.borderWidth=1;
        _viewSelect.backgroundColor=[UIColor colorWithRed:150.0f/255 green:170.0f/255 blue:20.0f/255 alpha:1];
        _lbComment.textColor=[UIColor whiteColor];
    }
    else
    {
        _ivSelect.hidden=YES;
//        _viewSelect.layer.borderColor=[UIColor clearColor].CGColor;
//        _viewSelect.layer.borderWidth=1;
        _viewSelect.backgroundColor=[UIColor colorWithWhite:0.9 alpha:1];
        _lbComment.textColor=[UIColor darkGrayColor];
    }
}
@end
