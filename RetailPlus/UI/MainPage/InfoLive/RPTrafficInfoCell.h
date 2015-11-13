//
//  RPTrafficInfoCell.h
//  RetailPlus
//
//  Created by zwhe on 14-1-23.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIMarqueeLabel.h"
@interface RPTrafficInfoCell : UITableViewCell
{
    IBOutlet UIMarqueeLabel *_lb1;
    
    IBOutlet UILabel *_lb2;
    IBOutlet UILabel *_lb3;
    IBOutlet UIView *_view1;
    IBOutlet UIView *_view2;
    IBOutlet UIView *_viewList1;
    IBOutlet UIView *_viewList2;
    IBOutlet UIView *_viewList3;
    IBOutlet UIImageView * _ivHasChild;
}

@property (nonatomic) BOOL bSelected;
@property(nonatomic,strong)KPIDomainData*kpiDomainData;
@property(nonatomic ,copy)NSString *string1;
@property(nonatomic ,copy)NSString *string2;
@property(nonatomic,assign)long long maxTraffic;
@property(nonatomic,assign)long long maxConversion;
@property(nonatomic,assign)long long maxTraQty;
@property(nonatomic,assign)long long maxProQty;
@property(nonatomic,assign)long long maxAmount;

@end
