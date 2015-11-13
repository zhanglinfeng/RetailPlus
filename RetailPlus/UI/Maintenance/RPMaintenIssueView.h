//
//  RPMaintenIssueView.h
//  RetailPlus
//
//  Created by lin dong on 13-9-16.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import "RPInspIssueView.h"
#import "ZSYPopoverListView.h"

@interface RPMaintenIssueView : RPInspIssueView
{
    IBOutlet UIButton       * _btnVendor;
    NSInteger               _curIndex;
}

@property (nonatomic,assign) NSMutableArray                 * arrayVendor;

-(IBAction)OnSelectVendor:(id)sender;

@end
