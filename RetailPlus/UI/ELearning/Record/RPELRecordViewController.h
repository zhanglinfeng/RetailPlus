//
//  RPELRecordViewController.h
//  RetailPlus
//
//  Created by lin dong on 14-7-22.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPTaskNavViewController.h"
#import "RPELRecordHeadView.h"

@interface RPELRecordViewController : RPTaskNavViewController<UITableViewDataSource,UITableViewDelegate,RPELRecordHeadViewDelegate>
{
    IBOutlet UIView             * _viewFrame;
    IBOutlet UILabel            * _lbLearnRec;
    IBOutlet UILabel            * _lbExamRec;
    IBOutlet UIView             * _viewLearnTip;
    IBOutlet UIView             * _viewExamTip;
    IBOutlet UIView             * _viewLearnBg;
    IBOutlet UIView             * _viewExamBg;
    
    IBOutlet UITableView        * _tbLearnRec;
    IBOutlet UITableView        * _tbExamRec;
    
    BOOL                        _bLearnMode;
    
    NSArray                     * _arrayLearnCataRec;
    NSArray                     * _arrayExamCataRec;
}
@end
