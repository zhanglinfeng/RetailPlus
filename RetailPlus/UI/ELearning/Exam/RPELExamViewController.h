//
//  RPELExamViewController.h
//  RetailPlus
//
//  Created by lin dong on 14-7-22.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPTaskNavViewController.h"
#import "RPExamUploadHeaderView.h"
#import "RPExamHeaderview.h"
#import "RPExamViewController.h"
#import "RPExamUploadCell.h"
//#import "RPSDKELDefine.h"
@interface RPELExamViewController : RPTaskNavViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,RPExamUploadHeaderViewDelegate,RPExamHeaderviewDelegate,RPExamViewControllerDelegate,RPExamUploadCellDelegate>
{
    RPExamViewController *_examViewController;
    IBOutlet UIView *_viewHeader;
    
    IBOutlet UIView *_viewSearch;
    IBOutlet UITableView *_tbExamList;
    IBOutlet UITextField *_tfSearch;
    NSInteger  _n;
    BOOL _bExpand;//是否展开要上传的试卷分组
//    NSMutableArray *_arrayExpand;//需要展开的试卷分组
    RPELPaperList *_paperList;
    NSMutableArray *_arrayAllPaper;
    NSMutableArray *_arraySubmitPaper;
    NSMutableArray *_arraySearch;
}
- (IBAction)OnDeleteSearch:(id)sender;

@end
