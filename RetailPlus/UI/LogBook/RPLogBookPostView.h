//
//  RPLogBookPostView.h
//  RetailPlus
//
//  Created by lin dong on 14-3-4.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPShowImgView.h"
@protocol RPLogBookPostViewDelegate<NSObject>
-(void)postViewEnd;
@end
@interface RPLogBookPostView : UIView<UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    IBOutlet UIView *_viewBackground;
    IBOutlet UIView *_viewTitle;
    IBOutlet UIView *_viewText;
    IBOutlet UITextView *_tvTitle;
    IBOutlet UITextView *_tvText;
    IBOutlet UIButton *_btPic1;
    IBOutlet UIButton *_btPic2;
    IBOutlet UIButton *_btPic3;
    IBOutlet UIButton *_btDelete1;
    IBOutlet UIButton *_btDelete2;
    IBOutlet UIButton *_btDelete3;
    IBOutlet UILabel *_lbTipTitle;
    IBOutlet UILabel *_lbTipText;
    IBOutlet UILabel *_lbTextNumber;
    IBOutlet UILabel *_lbThemeName;
    
    NSInteger               _nCurrentImgButtonIndex;
    BOOL                    _bPic1;//yes表示Button中有图
    BOOL                    _bPic2;
    BOOL                    _bPic3;
    NSMutableArray          *_arrayImg;
    RPShowImgView           * _viewShowImg;
    BOOL                    _bShowBig;//是否展示大图
    UIButton                *_button;//显示大图的那个Button
    IBOutlet UIView *_viewFrame;

    NSString                * _strTagID;
    
    
}
@property(nonatomic,assign)id<RPLogBookPostViewDelegate>delegate;
@property (nonatomic,assign) StoreDetailInfo    * storeSelected;
@property (nonatomic,assign) UIViewController   * vcFrame;
- (IBAction)OnOK:(id)sender;
-(IBAction)OnImageButton:(UIButton *)sender;
-(IBAction)OnImageDeleteButton:(UIButton *)sender;
- (IBAction)OnThemeCategories:(UIButton *)sender;
-(BOOL)OnBack;


@end
