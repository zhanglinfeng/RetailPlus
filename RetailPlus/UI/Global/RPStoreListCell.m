//
//  RPStoreListCell.m
//  RetailPlus
//
//  Created by lin dong on 13-8-20.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "UIImageView+WebCache.h"
#import "RPStoreListCell.h"

@implementation RPStoreListCell

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
//    _lbStore.adjustsFontSizeToFitWidth = YES;
//    _lbAddress.adjustsFontSizeToFitWidth = YES;
    
    CALayer *sublayer = _ivThumb.layer;
    sublayer.cornerRadius = 6;
    sublayer.borderColor = [UIColor lightGrayColor].CGColor;
    sublayer.borderWidth = 1;
}

-(void)setStore:(StoreDetailInfo *)store
{
    [_ivThumb setImageWithURLString:store.strStoreThumb placeholderImage:[UIImage imageNamed:@"icon_default_store_pic@2x.png"]];
 
    _lbStore.text =  [NSString stringWithFormat:@"%@ %@",store.strBrandName,store.strStoreName];
    _lbAddress.text = store.strStoreAddress;
}

@end
