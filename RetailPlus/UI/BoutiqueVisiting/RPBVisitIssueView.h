//
//  RPBVisitIssueView.h
//  RetailPlus
//
//  Created by zhanglinfeng on 14-2-26.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MarkViewController.h"
#import "RPShowImgView.h"
#import "RPMarkImageViewController.h"

@protocol RPBVisitIssueViewDelegate <NSObject>
-(void)OnModifyIssueEnd;
-(void)OnDeleteIssue;
@end
@interface RPBVisitIssueView : UIView<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,UITextViewDelegate,MarkViewControllerDelegate,RPMarkImageViewControllerDelegate,UITableViewDataSource,UITableViewDelegate>
{
    IBOutlet UIView         * _viewFrame;
    IBOutlet UITextField    * _tfTital;
    IBOutlet UITextView     * _tvDesc;
    IBOutlet UIButton       * _btnPic1;
    IBOutlet UIButton       * _btnPic2;
    IBOutlet UIButton       * _btnPic3;
    IBOutlet UIButton       * _btnDelPic1;
    IBOutlet UIButton       * _btnDelPic2;
    IBOutlet UIButton       * _btnDelPic3;
    IBOutlet UIView         * _viewTitalFrame;
    IBOutlet UIScrollView   * _scollFrame;
    IBOutlet UITableView    * _tbMap;
//    IBOutlet UIView         * _viewPos;
//    IBOutlet UIImageView    * _ivShopMap;
//    IBOutlet UIView         * _ivLocationCanvas;   //定位的坐标
    
//    UIButton                    * _btnLocationCanvas;
    UIImageView                 * _ivTemp;
    
    
    RPMarkImageViewController   * _markImageViewController;
    
    NSInteger               _nCurrentImgButtonIndex;
    BOOL                    _bModifyMode;
    
    
    BOOL                    _bShowImgDetailView;
    BOOL                    _bImagePickEndShowMarkImgCtrl;
    
    RPShowImgView           * _viewShowImg;
    
    NSInteger               _nScrollHeightExShopMap;
}

@property (nonatomic)BOOL                                bShowCanvasView;
@property (nonatomic,strong) MarkViewController          * markViewController;
@property (nonatomic,strong) NSString                    * strMapId;

@property (nonatomic,assign) id<RPBVisitIssueViewDelegate> delegate;
@property (nonatomic,assign) UIViewController   * vcFrame;
@property (nonatomic,retain) InspIssue          * issue;
@property (nonatomic,retain) BVisitItem       * visitItem;
@property (nonatomic,retain) NSArray          * arrayMap;

@property (nonatomic,readonly) BOOL             bModifyMode;
@property (nonatomic)          BOOL             bMarkRectInImage;

-(void)UpdateUI;

-(IBAction)OnImageButton:(UIButton *)sender;
-(IBAction)OnImageDeleteButton:(UIButton *)sender;
-(IBAction)OnOk:(id)sender;
-(IBAction)OnDeleteIssue:(id)sender;

-(BOOL)OnBack;
@end
