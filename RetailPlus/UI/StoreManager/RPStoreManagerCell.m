//
//  RPStoreManagerCell.m
//  RetailPlus
//
//  Created by lin dong on 13-9-3.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "UIButton+WebCache.h"
#import "RPStoreManagerCell.h"

@implementation RPStoreManagerCell

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
    _btnPic.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _btnPic.layer.borderWidth = 1;
    _btnPic.layer.cornerRadius = 5;
}

-(void)setStore:(StoreDetailInfo *)store
{
    [_btnPic setImageWithURLString:store.strStoreThumb forState:UIControlStateNormal];
    
    _lbAddress.text = store.strStoreAddress;
    if (store.strCity.length > 0) {
        _lbAddress.text = [NSString stringWithFormat:@"%@ %@",store.strCity,store.strStoreAddress];
    }
    
    _lbStoreName.text = [NSString stringWithFormat:@"%@ %@",store.strBrandName,store.strStoreName];
    _ivInfoComplete.hidden = !store.isPerfect;
    _ivStoreUser.hidden = !store.isOwn;
}

@end
