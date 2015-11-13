//
//  RPAddressBookCell.m
//  RetailPlus
//
//  Created by lin dong on 13-8-16.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "UIButton+WebCache.h"
#import "RPAddressBookCell.h"

@implementation RPAddressBookCell

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
    _btnPic.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _btnPic.layer.borderWidth = 1;
    _btnPic.layer.cornerRadius = 5;
    _ivLock.layer.cornerRadius = 5;
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(locationTapped:)];
    [_viewContact addGestureRecognizer:tap];
    
    _viewContact.delegate = self;
    
    _longPress1 = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(btnLong:)];
    _longPress1.minimumPressDuration = 0.8;
    [_btnTag1 addGestureRecognizer:_longPress1];
    _longPress2 = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(btnLong:)];
    _longPress2.minimumPressDuration = 0.8;
    [_btnTag2 addGestureRecognizer:_longPress2];
    _longPress3 = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(btnLong:)];
    _longPress3.minimumPressDuration = 0.8;
    [_btnTag3 addGestureRecognizer:_longPress3];
    
    _btnTag1.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _btnTag2.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _btnTag3.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    _btnTag1.contentEdgeInsets = UIEdgeInsetsMake(0,10, 0, 0);
    _btnTag2.contentEdgeInsets = UIEdgeInsetsMake(0,10, 0, 0);
    _btnTag3.contentEdgeInsets = UIEdgeInsetsMake(0,10, 0, 0);
}

-(void)AddRemoveFilt:(NSString *)strPressFilt
{
    if (strPressFilt && strPressFilt.length > 0) {
        if (![strPressFilt isEqualToString:_strFiltString])
            [self.delegate OnSetFilt:strPressFilt];
        else
            [self.delegate OnRemoveFilt];
    }
}

-(void)btnLong:(UILongPressGestureRecognizer *)gestureRecognizer{
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        if (gestureRecognizer == _longPress1) {
            [self AddRemoveFilt:_colleague.strTag1];
        }
        if (gestureRecognizer == _longPress2) {
            [self AddRemoveFilt:_colleague.strTag2];
        }
        if (gestureRecognizer == _longPress3) {
            [self AddRemoveFilt:_colleague.strTag3];
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setTagBtnDetail:(UIButton *)btn Content:(NSString *)strContent
{
    [btn setTitle:strContent forState:UIControlStateNormal];
    if ((_strFiltString && _strFiltString.length > 0) && [strContent isEqualToString:_strFiltString])
    {
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"button_tag3.png"] forState:UIControlStateNormal];
    }
    else
    {
        [btn setTitleColor:[UIColor colorWithWhite:0.3 alpha:1] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"button_tag2.png"] forState:UIControlStateNormal];
    }
}

-(void)setColleague:(UserDetailInfo *)colleague
{
    _colleague = colleague;
    
    switch (_colleague.rank) {
        case Rank_Manager:
            _viewLevel.backgroundColor = [UIColor colorWithRed:150.0f/255 green:70.0f/255 blue:150.0f/255 alpha:1];
            break;
        case Rank_StoreManager:
            _viewLevel.backgroundColor = [UIColor colorWithRed:230.0f/255 green:110.0f/255 blue:10.0f/255 alpha:1];
            break;
        case Rank_Assistant:
            _viewLevel.backgroundColor = [UIColor colorWithRed:50.0f/255 green:105.0f/255 blue:175.0f/255 alpha:1];
            break;
        case Rank_Vendor:
            _viewLevel.backgroundColor = [UIColor colorWithRed:150.0f/255 green:170.0f/255 blue:20.0f/255 alpha:1];
            break;
        default:
            break;
    }
    
    [_btnPic setImageWithURLString:_colleague.strPortraitImg forState:UIControlStateNormal];
    
    _lbName.text = [NSString stringWithFormat:@"%@",_colleague.strFirstName];
    _lbRoleDesc.text = [NSString stringWithFormat:@"%@ %@",_colleague.strDomainName,_colleague.strRoleName];
    _lbTagViewName.text = [NSString stringWithFormat:@"%@",_colleague.strFirstName];
    
    [self setTagBtnDetail:_btnTag1 Content:_colleague.strTag1];
    [self setTagBtnDetail:_btnTag2 Content:_colleague.strTag2];
    [self setTagBtnDetail:_btnTag3 Content:_colleague.strTag3];
    
    if ((_colleague.strTag1 && _colleague.strTag1.length > 0) ||
       (_colleague.strTag1 && _colleague.strTag1.length > 0) ||
       (_colleague.strTag1 && _colleague.strTag1.length > 0)) {
        _ivHasTag.image = [UIImage imageNamed:@"icon_tag2.png"];
    }
    else
    {
       _ivHasTag.image = [UIImage imageNamed:@"icon_tag1.png"]; 
    }
    
    _ivLock.hidden = (colleague.status == UserStatus_Locked ? NO : YES);
}

- (void)locationTapped:(UITapGestureRecognizer *)tap
{
    CGRect rc = [self convertRect:_btnPic.frame fromView:_viewContact];
    _btnPic.frame = rc;
    [self addSubview:_btnPic];
    
    [_viewContact removeFromSuperview];
}

-(IBAction)OnPic:(id)sender
{
//    UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
//    _viewContact.frame = CGRectMake(0, 0, keywindow.frame.size.width, keywindow.frame.size.height);
//    _viewContact.alpha = 0;
//    [keywindow addSubview:_viewContact];
//    
//    CGRect rc = [self convertRect:_btnPic.frame toView:_viewContact];
//    _btnPic.frame = rc;
//    [_viewContact addSubview:_btnPic];
//    
//    _btnPhone.frame = rc;
//    _btnTask.frame = rc;
//    _btnMessage.frame = rc;
//    
//    [UIView beginAnimations:nil context:nil];
//    _viewContact.alpha = 1;
//    
//    _btnPhone.frame = CGRectMake(rc.origin.x + 60, rc.origin.y, rc.size.width, rc.size.height);
//    _btnTask.frame =  CGRectMake(rc.origin.x + 120, rc.origin.y, rc.size.width, rc.size.height);;
//    _btnMessage.frame =  CGRectMake(rc.origin.x + 180, rc.origin.y, rc.size.width, rc.size.height);;
//    
//    [UIView commitAnimations];
    
    
    UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
    _viewContact.vcFrame = self.vcFrame;
    [keywindow addSubview:_viewContact];
    
    CGRect rc = [self convertRect:_btnPic.frame toView:_viewContact];
    _viewContact.colleague = self.colleague;
    _viewContact.vcFrame = self.vcFrame;
    [_viewContact Show:_colleague.strPortraitImg Position:rc.origin];
    
}

-(void)OnCustomerlist:(UserDetailInfo *)colleague
{
    [self.delegate OnCustomerlist:colleague];
}

-(void)setBShowTag:(BOOL)bShowTag
{
    _viewTagFrame.hidden = !bShowTag;
    _bShowTag = bShowTag;
}

-(IBAction)OnTag:(id)sender
{
    UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
    _viewEditTag.frame = CGRectMake(0, 0, keywindow.frame.size.width, keywindow.frame.size.height);
    _viewEditTag.colleague = self.colleague;
    _viewEditTag.nTagIndex = ((UIButton *)sender).tag - 300;
    _viewEditTag.delegate = self;
    [keywindow addSubview:_viewEditTag];
}

-(void)OnEditTagEnd
{
    [self.delegate OnEditTagEnd];
}
@end
