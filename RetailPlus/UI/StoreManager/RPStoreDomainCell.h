//
//  RPStoreDomainCell.h
//  RetailPlus
//
//  Created by lin dong on 14-9-16.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RPStoreDomainCell : UITableViewCell
{
    IBOutlet UILabel    * _lbDomainName;
}

@property (nonatomic,assign) DomainInfo * info;
@end
