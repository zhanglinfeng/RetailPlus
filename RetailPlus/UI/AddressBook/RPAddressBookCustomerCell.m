//
//  RPAddressBookCustomerCell.m
//  RetailPlus
//
//  Created by lin dong on 13-8-28.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "UIButton+WebCache.h"
#import "RPAddressBookCustomerCell.h"

@implementation RPAddressBookCustomerCell

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
    _viewLink.layer.cornerRadius=3;
    _viewContact.delegate = self;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setCustomer:(Customer *)customer
{
    _customer = customer;
    
    _lbName.text = [NSString stringWithFormat:@"%@",customer.strFirstName];

    [_btnPic setImageWithURLString:customer.strCustImg forState:UIControlStateNormal];
    
    if ((id)customer.strAddress != [NSNull null]) _lbAddress.text = customer.strAddress;
    _lbAddress.adjustsFontSizeToFitWidth=YES;
    if (customer.isVip) {
        _ivVip.hidden = NO;
    }
    else
    {
        _ivVip.hidden = YES;
    }
    
    if (customer.strRelationUserName.length > 0) {
        _lbRelationUser.text = customer.strRelationUserName;
        switch (customer.rankRelationUser) {
            case Rank_Manager:
                _viewLink.backgroundColor = [UIColor colorWithRed:150.0f/255 green:70.0f/255 blue:150.0f/255 alpha:1];
                break;
            case Rank_StoreManager:
                _viewLink.backgroundColor = [UIColor colorWithRed:230.0f/255 green:110.0f/255 blue:10.0f/255 alpha:1];
                break;
            case Rank_Assistant:
                _viewLink.backgroundColor = [UIColor colorWithRed:50.0f/255 green:105.0f/255 blue:175.0f/255 alpha:1];
                break;
            case Rank_Vendor:
                _viewLink.backgroundColor = [UIColor colorWithRed:150.0f/255 green:170.0f/255 blue:20.0f/255 alpha:1];
                break;
            default:
                break;
        }
    }
    else
    {
        _lbRelationUser.text = @"";
        _viewLink.backgroundColor = [UIColor lightGrayColor];
    }
    
    [_lbRelationUser Start];
}

-(IBAction)OnPic:(id)sender
{
    UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
    _viewContact.vcFrame = self.vcFrame;
    [keywindow addSubview:_viewContact];
    
    CGRect rc = [self convertRect:_btnPic.frame toView:_viewContact];
    _viewContact.customer = self.customer;
    [_viewContact Show:_customer.strCustImg Position:rc.origin];
}

-(IBAction)OnRelation:(id)sender
{
    [self.delegate OnSearchRelationUser:_customer];
}

-(void)OnEditCustomer:(Customer *)customer
{
    [self.delegate OnEditCustomer:customer];
}

-(void)OnCustomerPurchase:(Customer *)customer
{
    [self.delegate OnCustomerPurchase:customer];
}
@end
