//
//  RPVisualStateCell.m
//  RetailPlus
//
//  Created by zhanglinfeng on 14-6-17.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPVisualStateCell.h"
extern NSBundle * g_bundleResorce;
@implementation RPVisualStateCell

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
    _viewFrame.layer.cornerRadius=6;
    _viewFrame.layer.borderColor=[UIColor lightGrayColor].CGColor;
    _viewFrame.layer.borderWidth=1;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setVmReply:(VMReply *)vmReply
{
    _vmReply=vmReply;
    _lbName.text=vmReply.strUsername;
    _lbDate.text=vmReply.strDate;
    if (vmReply.states==0)
    {
        _lbState.text=NSLocalizedStringFromTableInBundle(@"Change the project status to approval",@"RPString", g_bundleResorce,nil);
        [_ivState setImage:[UIImage imageNamed:@"icon_noted_pending@2x.png"]];
    }
    else if(vmReply.states==1)
    {
        _lbState.text=NSLocalizedStringFromTableInBundle(@"Change the project status to unqualified",@"RPString", g_bundleResorce,nil);
        [_ivState setImage:[UIImage imageNamed:@"icon_noted_reject@2x.png"]];
    }
    else
    {
        _lbState.text=NSLocalizedStringFromTableInBundle(@"Change the project status to pass",@"RPString", g_bundleResorce,nil);
        [_ivState setImage:[UIImage imageNamed:@"icon_noted_pass@2x.png"]];
    }
    
    
    switch (_vmReply.rank) {
        case Rank_Manager:
            _lbName.textColor = [UIColor colorWithRed:150.0f/255 green:70.0f/255 blue:150.0f/255 alpha:1];
            break;
        case Rank_StoreManager:
            _lbName.textColor = [UIColor colorWithRed:230.0f/255 green:110.0f/255 blue:10.0f/255 alpha:1];
            break;
        case Rank_Assistant:
            _lbName.textColor = [UIColor colorWithRed:50.0f/255 green:105.0f/255 blue:175.0f/255 alpha:1];
            break;
        case Rank_Vendor:
            _lbName.textColor = [UIColor colorWithRed:150.0f/255 green:170.0f/255 blue:20.0f/255 alpha:1];
            break;
        default:
            break;
    }
}
@end
