//
//  RPInspMarkCell.m
//  RetailPlus
//
//  Created by lin dong on 13-8-19.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "RPInspMarkCell.h"
extern NSBundle * g_bundleResorce;

@implementation RPInspMarkCell

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
    CALayer * subLayer = _viewMarkDesc.layer;
    subLayer.cornerRadius = 5;
}

-(void)UpdateMark
{
    [_btnMark1 setSelected:NO];
    [_btnMark2 setSelected:NO];
    [_btnMark3 setSelected:NO];
    [_btnMark4 setSelected:NO];
    [_btnMark5 setSelected:NO];
    
    switch (_catagory.markCatagory) {
        case MARK_1:
            [_btnMark1 setSelected:YES];
            _lbMarkDesc.text = NSLocalizedStringFromTableInBundle(@"BAD",@"RPString", g_bundleResorce,nil);
            break;
        case MARK_2:
            [_btnMark1 setSelected:YES];
            [_btnMark2 setSelected:YES];
            _lbMarkDesc.text = NSLocalizedStringFromTableInBundle(@"NORMAL",@"RPString", g_bundleResorce,nil);
            break;
        case MARK_3:
            [_btnMark1 setSelected:YES];
            [_btnMark2 setSelected:YES];
            [_btnMark3 setSelected:YES];
            _lbMarkDesc.text = NSLocalizedStringFromTableInBundle(@"GOOD",@"RPString", g_bundleResorce,nil);
            break;
        case MARK_4:
            [_btnMark1 setSelected:YES];
            [_btnMark2 setSelected:YES];
            [_btnMark3 setSelected:YES];
            [_btnMark4 setSelected:YES];
            _lbMarkDesc.text = NSLocalizedStringFromTableInBundle(@"GREAT",@"RPString", g_bundleResorce,nil);
            break;
        case MARK_5:
            [_btnMark1 setSelected:YES];
            [_btnMark2 setSelected:YES];
            [_btnMark3 setSelected:YES];
            [_btnMark4 setSelected:YES];
            [_btnMark5 setSelected:YES];
            _lbMarkDesc.text = NSLocalizedStringFromTableInBundle(@"EXCELLENT",@"RPString", g_bundleResorce,nil);
            break;
        default:
            break;
    }
}

-(void)setCatagory:(InspCatagory *)catagory
{
    _catagory = catagory;
    [self UpdateMark];
}

-(IBAction)OnMark:(id)sender
{
    if (_catagory.markCatagory == MARK_1 + ((UIButton *)sender).tag - 100)
        _catagory.markCatagory = MARK_NONE;
    else
        _catagory.markCatagory = MARK_1 + ((UIButton *)sender).tag - 100;
    
    [self UpdateMark];
    [self.delegate OnMark:_catagory];
}
@end
