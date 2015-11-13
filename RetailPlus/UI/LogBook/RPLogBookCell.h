//
//  RPLogBookCell.h
//  RetailPlus
//
//  Created by lin dong on 14-3-4.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPLogBookCommentView.h"
#import "RPLogBookShowImageView.h"

@protocol RPLogBookCellDelegate <NSObject>
-(void)UpdateDetailTable;
-(void)deleteEnd;
@end

@interface RPLogBookCell : UITableViewCell<RPLogBookCommentViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    IBOutlet UIView                 * _viewFrame;
    IBOutlet UIView                 * _viewTop;
    IBOutlet UIView                 * _viewBottom;
    IBOutlet UIView                 * _viewImage;
    IBOutlet UIView                 * _viewCommand;
    IBOutlet UIView                 * _viewCommandDetail;
    
    IBOutlet UIView                 * _viewTag;
    
    IBOutlet UILabel                *  _lbTag;
    
    IBOutlet RPLogBookCommentView   * _viewComment;
    IBOutlet RPLogBookShowImageView * _viewShowImg;
    IBOutlet UIButton *_btPost;
    IBOutlet UIButton *_btReadMark;
    IBOutlet UIButton *_btDelete;
    IBOutlet UIButton *_btFocusCheck;
    IBOutlet UIButton *_btFocus;
    
    IBOutlet UIButton *_btExpend;
    IBOutlet UILabel            * _lbDateTime;
    IBOutlet UILabel            * _lbPostUser;
    IBOutlet UIImageView        * _ivPostUser;
    IBOutlet UIButton        * _btLogBookImage1;
    IBOutlet UIButton        * _btLogBookImage2;
    IBOutlet UIButton        * _btLogBookImage3;
    IBOutlet UILabel            * _lbTitle;
    IBOutlet UILabel            * _lbDesc;
    IBOutlet UILabel            * _lbCommentUserCount;
    IBOutlet UITableView        * _tbComment;
}

@property (nonatomic,retain) id<RPLogBookCellDelegate> delegate;

@property (nonatomic)NSInteger              nCellHeight;
@property (nonatomic,retain) LogBookDetail  * detail;
@property (nonatomic,assign) StoreDetailInfo           * storeSelected;
@property (nonatomic,strong) NSString        * themeId;

+(NSInteger)calcCellHeight:(LogBookDetail *)detail;

-(IBAction)OnComment:(id)sender;
-(IBAction)OnShowComment:(id)sender;
-(IBAction)OnRead:(id)sender;
- (IBAction)showMenu:(id)sender;
- (IBAction)OnPic1:(id)sender;
- (IBAction)OnPic2:(id)sender;
- (IBAction)OnPic3:(id)sender;
- (IBAction)Ondelete:(id)sender;
- (IBAction)Onfocus:(id)sender;

@end
