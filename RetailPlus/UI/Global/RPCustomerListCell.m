//
//  RPCustomerListCell.m
//  RetailPlus
//
//  Created by zhanglinfeng on 14-3-13.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPCustomerListCell.h"
#import "UIImageView+WebCache.h"
@implementation RPCustomerListCell

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
    _lbName.adjustsFontSizeToFitWidth = YES;
    _lbAddress.adjustsFontSizeToFitWidth = YES;
    
    CALayer *sublayer = _ivThumb.layer;
    sublayer.cornerRadius = 6;
    sublayer.borderColor = [UIColor lightGrayColor].CGColor;
    sublayer.borderWidth = 1;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setCustomer:(Customer *)customer
{
    [_ivThumb setImageWithURLString:customer.strCustImg];
 
    _lbName.text =  [NSString stringWithFormat:@"%@",customer.strFirstName];
    _lbAddress.text = customer.strAddress;
}
@end
