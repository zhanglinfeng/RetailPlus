//
//  RPBookConfStartView.h
//  RetailPlus
//
//  Created by lin dong on 14-6-19.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPYuanTelApi.h"

@protocol RPBookConfStartViewDelegate <NSObject>
-(void)OnStartBookEnd;
@end

@interface RPBookConfStartView : UIView<UITableViewDataSource,UITableViewDelegate>
{
    IBOutlet UIView         * _viewFrame;
    IBOutlet UILabel        * _lbConfTheme;
    IBOutlet UILabel        * _lbCount;
    IBOutlet UILabel        * _lbDateTime;
    IBOutlet UITableView    * _tbMember;
}

@property (nonatomic,retain) id<RPBookConfStartViewDelegate> delegate;
@property (nonatomic,retain) RPConfBook * confbook;

-(IBAction)OnStart:(id)sender;
-(IBAction)OnDelete:(id)sender;

@end
