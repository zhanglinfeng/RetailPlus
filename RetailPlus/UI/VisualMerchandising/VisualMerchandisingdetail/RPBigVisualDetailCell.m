//
//  RPBigVisualDetailCell.m
//  RetailPlus
//
//  Created by zhanglinfeng on 14-6-20.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPBigVisualDetailCell.h"
#import "RPBigVisualCommentCell.h"
#import "UIImageView+WebCache.h"
#import "RPBigImgCommentCell.h"
@implementation RPBigVisualDetailCell

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
-(void)setReplyImg:(ReplyImg *)replyImg
{
    _arrayComment=[[NSMutableArray alloc]init];
    _arrayImgDetail=[[NSMutableArray alloc]init];
    _replyImg=replyImg;
    if (_replyImg.strImgPath)
    {
        [_ivPic setImageWithURLString:_replyImg.strImgPath];
    }
  
    for (int i=0; i<_replyList.arrayReply.count; i++)
    {
        NSArray *array=((VMReply*)[_replyList.arrayReply objectAtIndex:i]).arrayimgReply;
        for (int j = 0; j<array.count; j++)
        {
            
            if ([_replyImg.strImgId isEqualToString: ((ReplyImgDetail*)[array objectAtIndex:j]).strImgId])
            {
                VMReply *vmReply=[_replyList.arrayReply objectAtIndex:i];
                if (vmReply.type==0||vmReply.type==1)
                {
                    _indexVMReply=i;
                    _indexReplyImgDetail=j;
                }
                if (vmReply.type==2) {
                    [_arrayComment addObject:vmReply];
                    [_arrayImgDetail addObject:[array objectAtIndex:j]];
                }
                
            }
        }
        
    }
}
-(void)setVisualDisplay:(VisualDisplay *)visualDisplay
{
    _visualDisplay=visualDisplay;
    if (_visualDisplay.states==2)
    {
        _btComment.userInteractionEnabled=NO;
        _btComment.alpha=0.3;
    }
    else
    {
        _btComment.userInteractionEnabled=YES;
        _btComment.alpha=1;
    }
}
-(void)SetSelectReply:(NSString *)strReplyId
{
    for (int i=0; i<_arrayComment.count; i++)
    {
        if ([strReplyId isEqualToString:((VMReply*)[_arrayComment objectAtIndex:i]).strVisualDisplayId])
        {
            [self ShowMarkImg:i];
            NSIndexPath *index = [NSIndexPath indexPathForRow:i+1 inSection:0];
            [_tbComment selectRowAtIndexPath:index animated:YES scrollPosition:UITableViewScrollPositionTop];
            break;
        }
        else
        {
            NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:0];
            [_tbComment selectRowAtIndexPath:index animated:YES scrollPosition:UITableViewScrollPositionTop];
            [_markView SetRect:CGRectMake(0, 0, 0, 0) ScaleX:_ivPic.image.size.width / _markView.frame.size.width ScaleY:_ivPic.image.size.height / _markView.frame.size.height];
        }
    }
    
}

-(void)ShowMarkImg:(NSInteger)nIndex
{
    ReplyImgDetail *imgDetail=[_arrayImgDetail objectAtIndex:nIndex];
    CGRect rect=CGRectMake(imgDetail.regX, imgDetail.regY, imgDetail.regWidth, imgDetail.regHeigth);
    [_markView SetRect:rect ScaleX:_ivPic.image.size.width / _markView.frame.size.width ScaleY:_ivPic.image.size.height / _markView.frame.size.height];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0)
    {
        RPBigImgCommentCell *cell=[tableView dequeueReusableCellWithIdentifier:@"RPBigImgCommentCell"];
        if (cell==nil)
        {
            NSArray *arrayNib=[[NSBundle mainBundle] loadNibNamed:@"RPVisualDetailCell" owner:self options:nil];
            cell=[arrayNib objectAtIndex:6];
        }
        cell.lbComment.text=_replyImg.strComments;
        cell.lbUserName.text=_replyImg.strUserName;
        cell.rank=_replyImg.rank;
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:50.0f/255 green:50.0f/255 blue:50.0f/255 alpha:1];
        return cell;
    }
    else
    {
//        _arrayComment
        RPBigVisualCommentCell *cell=[tableView dequeueReusableCellWithIdentifier:@"RPBigVisualCommentCell"];
        if (cell==nil)
        {
            NSArray *arrayNib=[[NSBundle mainBundle] loadNibNamed:@"RPVisualDetailCell" owner:self options:nil];
            cell=[arrayNib objectAtIndex:5];
        }
        cell.vmReply=[_arrayComment objectAtIndex:indexPath.row-1];
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:50.0f/255 green:50.0f/255 blue:50.0f/255 alpha:1];
        return cell;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _arrayComment.count+1;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row>0)
    {
        [self ShowMarkImg:indexPath.row-1];
        for (int i=0; i<_replyList.arrayReply.count; i++)
        {
            if ([((VMReply *)[_arrayComment objectAtIndex:indexPath.row-1]).strVisualDisplayId isEqualToString:((VMReply *)[_replyList.arrayReply objectAtIndex:i]).strVisualDisplayId])
            {
                [self.delegateGoToSmall GoToSmall:i ImgDetailIndex:-1 Type:1];
            }
        }
        
    }
    else
    {
        [_markView SetRect:CGRectMake(0, 0, 0, 0) ScaleX:_ivPic.image.size.width / _markView.frame.size.width ScaleY:_ivPic.image.size.height / _markView.frame.size.height];
        [self.delegateGoToSmall GoToSmall:_indexVMReply ImgDetailIndex:_indexReplyImgDetail Type:0];
    }
    
}

- (IBAction)OnComment:(id)sender
{
    [self.delegate OnGoComment:_replyImg];
}
@end
