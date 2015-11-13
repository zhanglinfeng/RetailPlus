//
//  RPBVisitCommentsView.m
//  RetailPlus
//
//  Created by zhanglinfeng on 14-2-26.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPBVisitCommentsView.h"
#import "RPBlockUIAlertView.h"
#import "SVProgressHUD.h"
extern NSBundle * g_bundleResorce;

@implementation RPBVisitCommentsView

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
    _viewFrame.layer.cornerRadius = 8;
    _viewComments.layer.cornerRadius = 6;
    _viewComments.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _viewComments.layer.borderWidth = 1;
    
    _viewTitle.layer.cornerRadius = 6;
    _viewTitle.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _viewTitle.layer.borderWidth = 1;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAnywhereToDismissKeyboard:)];
    [self addGestureRecognizer:tap];
}

- (void)tapAnywhereToDismissKeyboard:(UIGestureRecognizer *)gestureRecognizer {
    [self endEditing:YES];
}

-(void)UpdateMark
{
    
}

//-(void)setDataInsp:(BVisitData *)dataInsp
//{
//    _dataVisit = dataInsp;
//    _tvComments.text = dataInsp.strComment;
//    [self UpdateMark];
//}
-(void)setDataVisit:(BVisitData *)dataVisit
{
    _dataVisit=dataVisit;
    _tvComments.text=dataVisit.strComment;
    _tvTitle.text = dataVisit.strTitle;
    
    if (_dataVisit.nStatus==0)
    {
        _btUnfinished.selected=YES;
    }
    else
    {
        _btUnfinished.selected=NO;
    }
}

-(BOOL)OnBack
{
    if (_tvComments.text.length>RPMAX_DESC_LENGTH)
    {
        NSString *s=NSLocalizedStringFromTableInBundle(@"Comments length should not exceed 300 characters",@"RPString", g_bundleResorce,nil);
        [SVProgressHUD showErrorWithStatus:s];
        return NO;
    }
    
    if (_tvTitle.text.length > RPMAX_TITLE_LENGTH)
    {
        NSString *s=NSLocalizedStringFromTableInBundle(@"Title length should not exceed 50 characters",@"RPString", g_bundleResorce,nil);
        [SVProgressHUD showErrorWithStatus:s];
        return NO;
    }
    
    if (_tvTitle.text.length == 0)
    {
        NSString *s=NSLocalizedStringFromTableInBundle(@"Report title can't be empty",@"RPString", g_bundleResorce,nil);
        [SVProgressHUD showErrorWithStatus:s];
        return NO;
    }
    
    _dataVisit.strComment = _tvComments.text;
    _dataVisit.strTitle = _tvTitle.text;
    [self endEditing:YES];
    return YES;
}

-(IBAction)OnOk:(id)sender
{
    if (_tvComments.text.length>RPMAX_DESC_LENGTH)
    {
        NSString *s=NSLocalizedStringFromTableInBundle(@"Comments length should not exceed 300 characters",@"RPString", g_bundleResorce,nil);
        [SVProgressHUD showErrorWithStatus:s];
        return;
    }
    
    if (_tvTitle.text.length > RPMAX_TITLE_LENGTH)
    {
        NSString *s=NSLocalizedStringFromTableInBundle(@"Title length should not exceed 50 characters",@"RPString", g_bundleResorce,nil);
        [SVProgressHUD showErrorWithStatus:s];
        return;
    }
    
    if (_tvTitle.text.length == 0)
    {
        NSString *s=NSLocalizedStringFromTableInBundle(@"Report title can't be empty",@"RPString", g_bundleResorce,nil);
        [SVProgressHUD showErrorWithStatus:s];
        return;
    }
    
    _dataVisit.strComment = _tvComments.text;
    _dataVisit.strTitle = _tvTitle.text;
    [self.delegate OnAddCommentsEnd];
}

-(IBAction)OnCache:(id)sender
{
    if (_tvComments.text.length>RPMAX_DESC_LENGTH)
    {
        NSString *s=NSLocalizedStringFromTableInBundle(@"Comments length should not exceed 300 characters",@"RPString", g_bundleResorce,nil);
        [SVProgressHUD showErrorWithStatus:s];
        return;
    }
    
    if (_tvTitle.text.length > RPMAX_TITLE_LENGTH)
    {
        NSString *s=NSLocalizedStringFromTableInBundle(@"Title length should not exceed 50 characters",@"RPString", g_bundleResorce,nil);
        [SVProgressHUD showErrorWithStatus:s];
        return;
    }
    
    if (_tvTitle.text.length == 0)
    {
        NSString *s=NSLocalizedStringFromTableInBundle(@"Report title can't be empty",@"RPString", g_bundleResorce,nil);
        [SVProgressHUD showErrorWithStatus:s];
        return;
    }
    
    _dataVisit.strComment = _tvComments.text;
    _dataVisit.strTitle = _tvTitle.text;
    
    [self.delegate OnQuitComments];
}

- (IBAction)OnHelp:(id)sender
{
    [RPGuide ShowGuide:self];
}

- (IBAction)OnUnfinished:(id)sender
{
    _btUnfinished.selected=!_btUnfinished.selected;
    if (_btUnfinished.selected)
    {
        _dataVisit.nStatus=0;
//        ((InspReporterSection*)[_dataVisit.reporters.arraySection objectAtIndex:0]).strTitle1=NSLocalizedStringFromTableInBundle(@"Boutique Visit Reportt(Unfinished)",@"RPString", g_bundleResorce,nil);
//        NSString *s=@"未完成";
//        _dataVisit.strTitle=[NSString stringWithFormat:@"%@%@",_dataVisit.strTitle,s];
//        _tvTitle.text = _dataVisit.strTitle;
    }
    else
    {
        _dataVisit.nStatus=1;
//        ((InspReporterSection*)[_dataVisit.reporters.arraySection objectAtIndex:0]).strTitle1=NSLocalizedStringFromTableInBundle(@"Boutique Visit Reportt",@"RPString", g_bundleResorce,nil);
//        _dataVisit.strTitle=[_dataVisit.strTitle stringByReplacingOccurrencesOfString:@"未完成"withString:@""];
//        _tvTitle.text = _dataVisit.strTitle;
    }
   
}
@end
