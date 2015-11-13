//
//  RPExamViewController.h
//  RetailPlus
//
//  Created by zhanglinfeng on 14-7-24.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPTaskNavViewController.h"
#import "EasyTableView.h"
//#import "RPSDKELDefine.h"
#import "RPItemFinishedView.h"
#import "RPExamDetailView.h"
@protocol RPExamViewControllerDelegate
-(void)addPaperTemp:(RPELPaper *)paper;
@end
@interface RPExamViewController : RPTaskNavViewController<EasyTableViewDelegate,RPItemFinishedViewDelegate,RPExamDetailViewDelegate>
{
    
    IBOutlet UIView *_viewFrame;
    IBOutlet UIView *_viewExam;
    EasyTableView *_tbOptions;
    IBOutlet UILabel *_lbCurrentCount;
    IBOutlet UILabel *_lbTotalCount;
    IBOutlet UIView *_viewExamInfoBG;
    IBOutlet UIView *_viewExamInfo;
    IBOutlet UILabel *_lbExamInfo;
    IBOutlet RPItemFinishedView *_viewFinished;
    BOOL _bFinishedView;
    IBOutlet UILabel *_lbQuestionType;
    IBOutlet UIImageView *_ivAnswerType;
    IBOutlet UILabel *_lbPaperCode;
    IBOutlet UILabel *_lbPaperTitle;
    IBOutlet UIView *_viewCheckColor;
    IBOutlet UIButton *_btOK;
    
    UIImageView     * _ivTemp;
    BOOL            _bFirstAppear;
    IBOutlet UIImageView *_ivLeft;
    IBOutlet UIImageView *_ivRight;
}
@property(nonatomic,weak)id<RPExamViewControllerDelegate>delegateSubmit;
@property(nonatomic,strong)RPELPaper *paper;
- (IBAction)OnOK:(id)sender;
- (IBAction)OnSubmit:(id)sender;
- (IBAction)OnShowTip:(id)sender;
@end
