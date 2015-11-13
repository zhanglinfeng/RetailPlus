//
//  RPVisualCommentView.m
//  RetailPlus
//
//  Created by zhanglinfeng on 14-6-20.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPVisualCommentView.h"
#import "UIImageView+WebCache.h"
#import "RPBlockUIAlertView.h"
extern NSBundle * g_bundleResorce;
@implementation RPVisualCommentView

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
    if (!self.bReadOnly)
    {
//        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        backButton.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
//        [backButton setImage:[UIImage imageNamed:@"Submit1.png"] forState:UIControlStateNormal];
//        [backButton setImage:[UIImage imageNamed:@"Submit2.png"] forState:UIControlStateHighlighted];
//        [backButton addTarget:self action:@selector(ConfirmAction) forControlEvents:UIControlEventTouchUpInside];
//        UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
//        temporaryBarButtonItem.style = UIBarButtonItemStylePlain;
//        self.navigationItem.rightBarButtonItem =temporaryBarButtonItem;
    }
    _markView.bReadOnly = self.bReadOnly;
    
    _viewHeader.layer.cornerRadius=10;
}
-(void)setReplyImg:(ReplyImg *)replyImg
{
    _tvComment.text=@"";
    _replyImage = replyImg;
//    UIImage *img=[RPSDK loadImageFromURL:_replyImage.strImgPath];
//    _ivPic.image = img;
    [_ivPic setImageWithURLString:_replyImage.strImgPath];
    CGRect rect=CGRectMake(0, 0, 0, 0);
    [_markView SetRect:rect ScaleX:_ivPic.image.size.width / _markView.frame.size.width ScaleY:_ivPic.image.size.height / _markView.frame.size.height];
    _tvComment.placeholder=NSLocalizedStringFromTableInBundle(@"Input Message",@"RPString", g_bundleResorce,nil);
}

//暂时没用到
-(void)setBReadOnly:(BOOL)bReadOnly
{
    _bReadOnly = bReadOnly;
    _markView.bReadOnly = self.bReadOnly;
}

-(IBAction)OnConfirm:(id)sender
{
    CGRect rect=[_markView GetRect];
    _vmImage=[[VMImage alloc]init];
    _vmImage.strImgId=_replyImage.strImgId;
    _vmImage.strComments=_replyImage.strComments;
    _vmImage.regX=rect.origin.x;
    _vmImage.regY=rect.origin.y;
    _vmImage.regWidth=rect.size.width;
    _vmImage.regHeight=rect.size.height;
    NSMutableArray *array=[[NSMutableArray alloc]init];
    [array addObject:_vmImage];
    [[RPSDK defaultInstance]AddReference:self.visualDisplay.strVisualDisplayId StoreId:self.followStore.strStoreId Type:2 Comments:_tvComment.text ImageArray:array Success:^(id idResult) {
        [self.delegate OnMarkInViewEnd];
    } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
        
    }];
    
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    [UIView beginAnimations:nil context:nil];
    _viewFrame.frame=CGRectMake(_viewFrame.frame.origin.x, _viewFrame.frame.origin.y-250, _viewFrame.frame.size.width, _viewFrame.frame.size.height);
    [UIView commitAnimations];
}
-(void)textViewDidEndEditing:(UITextView *)textView
{
    [UIView beginAnimations:nil context:nil];
    _viewFrame.frame=CGRectMake(_viewFrame.frame.origin.x, _viewFrame.frame.origin.y+250, _viewFrame.frame.size.width, _viewFrame.frame.size.height);
    [UIView commitAnimations];
}

- (IBAction)OnHelp:(id)sender
{
    [RPGuide ShowGuide:self];
}
@end
