//
//  RPBVisitMarkCell.m
//  RetailPlus
//
//  Created by zhanglinfeng on 14-2-26.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "RPBVisitMarkCell.h"
#import "SVProgressHUD.h"
extern NSBundle * g_bundleResorce;

@implementation RPBVisitMarkCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)awakeFromNib
{
    
    _switch = [[RPSwitchView alloc] initWithFrame:CGRectMake(0, 0, _viewSwitch.frame.size.width, _viewSwitch.frame.size.height)];
    _switch.delegate = self;
    [_viewSwitch addSubview:_switch];
    _switch.imgBack = [UIImage imageNamed:@"image_switcher_check@2x.png"];
   [_switch SetOn:YES];
    
    _coverageView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, _viewSwitch.frame.size.width, _viewSwitch.frame.size.height)];
    _coverageView.backgroundColor=[UIColor colorWithWhite:0.9 alpha:0.8];
    [_viewSwitch addSubview:_coverageView];
    _coverageView.hidden=YES;
    
    _lbCheck.text=NSLocalizedStringFromTableInBundle(@"CHECK:",@"RPString", g_bundleResorce,nil);
    _lbOpen.text=NSLocalizedStringFromTableInBundle(@"TOUCH TO OPEN",@"RPString", g_bundleResorce,nil);
    _lbNA.text=NSLocalizedStringFromTableInBundle(@"N/A",@"RPString", g_bundleResorce,nil);
}
-(void)SelectSwitch:(RPSwitchView *)view isOn:(BOOL)bOn
{
    _bCheck=!bOn;
    if (_visitItem.mark==BVisitMark_NONE)
    {
        _visitItem.mark=BVisitMark_NONE;
        
    }
    else
    {
        if (_bCheck)
        {
            _visitItem.mark=BVisitMark_YES;
        }
        else
        {
            _visitItem.mark=BVisitMark_NO;
        }
    }
    [self.delegate OnMark:_visitItem];
}
-(void)UpdateMark
{
    switch (_visitItem.mark) {
        case BVisitMark_NO:
        {
            _coverageView.hidden=YES;
            [_btNA setBackgroundImage:[UIImage imageNamed:@"button_na_bv_noactive@2x.png"] forState:UIControlStateNormal];
            _lbNA.textColor=[UIColor colorWithWhite:0.8 alpha:1];
             [_switch SetOn:YES];
        }
            break;
        case BVisitMark_NONE:
        {
            _coverageView.hidden=NO;
            [_btNA setBackgroundImage:[UIImage imageNamed:@"button_na_bv_active@2x.png"] forState:UIControlStateNormal];
            _lbNA.textColor=[UIColor colorWithWhite:0.4 alpha:1];
            [_switch SetOn:YES];
        }
            break;
        case BVisitMark_YES:
        {
            _coverageView.hidden=YES;
            [_btNA setBackgroundImage:[UIImage imageNamed:@"button_na_bv_noactive@2x.png"] forState:UIControlStateNormal];
            _lbNA.textColor=[UIColor colorWithWhite:0.8 alpha:1];
             [_switch SetOn:NO];
        }
            break;
        case BVisitMark_EMPTY:
        {
            _coverageView.hidden=YES;
            _btClose.selected=YES;
             _viewClose.hidden=NO;
            [_btNA setBackgroundImage:[UIImage imageNamed:@"button_na_bv_noactive@2x.png"] forState:UIControlStateNormal];
            _lbNA.textColor=[UIColor colorWithWhite:0.8 alpha:1];
            [_switch SetOn:YES];
        }
            break;
        default:
        {
            _coverageView.hidden=YES;
            [_btNA setBackgroundImage:[UIImage imageNamed:@"button_na_bv_noactive@2x.png"] forState:UIControlStateNormal];
            _lbNA.textColor=[UIColor colorWithWhite:0.8 alpha:1];
        }
            break;
    }
}
-(void)setVisitItem:(BVisitItem *)visitItem
{
    _visitItem=visitItem;
    if (_visitItem.mark==BVisitMark_NO) {
        _bCheck=NO;
    }
    else
    {
        _bCheck=YES;
    }
    [self UpdateMark];
}
- (IBAction)OnNA:(id)sender
{
    if (_visitItem.mark!=BVisitMark_NONE)
    {
        _visitItem.mark=BVisitMark_NONE;

    }
    else
    {
        _visitItem.mark=BVisitMark_YES;
    }
    [self.delegate OnMark:_visitItem];

}


- (IBAction)OnAddIssue:(id)sender
{
    
    [self.delegate OnAddIssue:_visitItem];
}

- (IBAction)OnCloseIssue:(id)sender
{
    if (_visitItem.arrayIssue.count<1)
    {
        _btClose.selected=!_btClose.selected;
        if (_btClose.selected)
        {
            _viewClose.hidden=NO;
            _visitItem.mark=BVisitMark_EMPTY;
        }
        else
        {
            _viewClose.hidden=YES;
            _visitItem.mark=BVisitMark_YES;
        }
        [self.delegate OnMark:_visitItem];
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:NSLocalizedStringFromTableInBundle(@"Can't be closed with issues",@"RPString", g_bundleResorce,nil)];
    }
    
   
}

- (IBAction)OnOpenIssue:(id)sender
{
    _btClose.selected=NO;
    _viewClose.hidden=YES;
    _visitItem.mark=BVisitMark_YES;
    [self.delegate OnMark:_visitItem];
}
@end
