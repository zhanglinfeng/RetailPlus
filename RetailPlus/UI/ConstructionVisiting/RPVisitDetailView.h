//
//  RPVisitDetailView.h
//  RetailPlus
//
//  Created by lin dong on 13-9-12.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPInspReporterView.h"
#import "RPInspAddIssueCell.h"
#import "RPInspIssueView.h"
#import "RPInspIssueCell.h"

@protocol RPVisitDetailViewDelegate <NSObject>
-(void)OnVisitEnd;
-(void)backVisit;
@end

@interface RPVisitDetailView : UIView<RPInspReporterViewDelegate,UITableViewDataSource,UITableViewDelegate,RPInspAddIssueCellDelegate,RPInspIssueViewDelegate,RPInspIssueCellDelegate,UITextViewDelegate,UIScrollViewDelegate,RPInspReporterViewDelegate>
{
    IBOutlet UIView             * _viewFrame;
    IBOutlet UIView             * _viewHeadBack1;
    IBOutlet UIView             * _viewHeadBack2;
    
    IBOutlet UIScrollView       * _svFrame;
    IBOutlet UIView             * _viewComments;
    IBOutlet UIView             * _viewMark;
    UITableView                 * _tbIssue;
    IBOutlet RPInspReporterView * _viewReporter;
    IBOutlet RPInspIssueView    * _viewIssue;
    IBOutlet UIView             * _viewDesc;
    IBOutlet UITextView         * _tvDesc;
    IBOutlet UIImageView        * _ivPoint;
    
    IBOutlet UILabel            * _lbCount;
    IBOutlet UILabel            * _lbMarkDesc;
    IBOutlet UIButton           * _btnMark1;
    IBOutlet UIButton           * _btnMark2;
    IBOutlet UIButton           * _btnMark3;
    IBOutlet UIButton           * _btnMark4;
    IBOutlet UIButton           * _btnMark5;
    IBOutlet UIImageView        * _imgMark1;
    IBOutlet UIImageView        * _imgMark2;
    IBOutlet UIImageView        * _imgMark3;
    IBOutlet UIImageView        * _imgMark4;
    IBOutlet UIImageView        * _imgMark5;
    
    BOOL                        _bShowIssueView;
    BOOL                        _bShowReporterView;
}

@property (nonatomic,assign) id<RPVisitDetailViewDelegate>   delegate;
@property (nonatomic,assign) UIViewController               * vcFrame;
@property (nonatomic,assign) StoreDetailInfo                * storeSelected;
@property (nonatomic,assign) CVisitData                     * dataVisit;

-(BOOL)OnBack;
-(IBAction)OnMark:(id)sender;
-(IBAction)OnDescView:(id)sender;
-(IBAction)OnIssueView:(id)sender;
-(IBAction)OnCache:(id)sender;
- (IBAction)OnHelp:(id)sender;
@end
