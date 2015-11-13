//
//  RPDomainListCell.h
//  RetailPlus
//
//  Created by lin dong on 14-9-16.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RPDomainListCellDelegate <NSObject>

    -(void)OnSelectDomain:(DomainInfo *)info;

@end

@interface RPDomainListCell : UITableViewCell
{
    IBOutlet UILabel    * _lbDomainName;
    IBOutlet UIButton    * _btnSelectDomain;
}

@property (nonatomic,assign) id<RPDomainListCellDelegate> delegate;

@property (nonatomic) BOOL bCanSelDomain;
@property (nonatomic,assign) DomainInfo * info;
@end
