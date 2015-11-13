//
//  RPTrafficViewController.h
//  RetailPlus
//
//  Created by lin dong on 13-8-14.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPTaskBaseViewController.h"
#import "RPTrafficTableView.h"
#import "RPTrafficGraphView.h"

@interface RPTrafficViewController : RPTaskBaseViewController
{
    IBOutlet UIView             * _viewGap;
    IBOutlet UIView             * _viewFrame;
    IBOutlet RPTrafficTableView * _tableView;
    IBOutlet RPTrafficGraphView * _graphView;
    
    CGRect                      _rcGraph;
    CGRect                      _rcTable;
    BOOL                        _bGraphViewHide;
}

-(IBAction)OnShowHideGraph:(id)sender;

@end
