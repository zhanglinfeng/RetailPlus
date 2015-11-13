//
//  RPTrainingViewController.h
//  RetailPlus
//
//  Created by lin dong on 14-3-13.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPTaskBaseViewController.h"
#import "MJRefreshHeaderView.h"
@interface RPTrainingViewController : RPTaskBaseViewController<UITableViewDataSource,UITableViewDelegate>
{
    IBOutlet UITableView        * _tbDocs;
    IBOutlet UIView             * _viewFrame;
    IBOutlet UIButton           * _btnBack;
    NSMutableArray              * _arrayDocs;
    BOOL                        _bShowFolder;
    NSMutableArray              * _arrayFolders;
    MJRefreshHeaderView     * _headerDoc;
    TrainingFolder          * _folder;
}

- (IBAction)OnHelp:(id)sender;
- (IBAction)OnBackFolder:(id)sender;

@property (nonatomic,assign) UIViewController * vcFrame;
@end
