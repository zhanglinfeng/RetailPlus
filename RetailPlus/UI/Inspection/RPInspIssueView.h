//
//  RPInspIssueView.h
//  RetailPlus
//
//  Created by lin dong on 13-8-20.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MarkViewController.h"
#import "RPShowImgView.h"
#import "RPMarkImageViewController.h"

@protocol RPInspIssueViewDelegate <NSObject>
    -(void)OnModifyIssueEnd;
    -(void)OnDeleteIssue;
@end

@interface RPInspIssueView : UIView<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,UITextViewDelegate,MarkViewControllerDelegate,RPMarkImageViewControllerDelegate>
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
    
    IBOutlet UIView         * _viewPos;
    IBOutlet UIImageView    * _ivShopMap;
    IBOutlet UIView         * _ivLocationCanvas;   //定位的坐标

    UIButton                    * _btnLocationCanvas;
    MarkViewController          * _markViewController;
    RPMarkImageViewController   * _markImageViewController;
    
    NSInteger               _nCurrentImgButtonIndex;
    BOOL                    _bModifyMode;
    
    BOOL                    _bShowCanvasView;
    BOOL                    _bShowImgDetailView;
    BOOL                    _bImagePickEndShowMarkImgCtrl;
    
    RPShowImgView           * _viewShowImg;
    
    NSInteger               _nScrollHeightExShopMap;
}

@property (nonatomic,assign) id<RPInspIssueViewDelegate> delegate;
@property (nonatomic,assign) UIViewController   * vcFrame;
@property (nonatomic,retain) InspIssue          * issue;
@property (nonatomic,retain) InspCatagory       * catagory;
@property (nonatomic,retain) NSString           * strShopMapUrl;
@property (nonatomic,retain) UIImage            * imgShopMap;

@property (nonatomic,readonly) BOOL             bModifyMode;
@property (nonatomic)          BOOL             bMarkRectInImage;

-(void)UpdateUI;

-(IBAction)OnImageButton:(UIButton *)sender;
-(IBAction)OnImageDeleteButton:(UIButton *)sender;
-(IBAction)OnOk:(id)sender;
-(IBAction)OnDeleteIssue:(id)sender;

-(BOOL)OnBack;

@end
