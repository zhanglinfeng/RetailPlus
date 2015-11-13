//
//  RPVisualMerchandisingDetailView.h
//  RetailPlus
//
//  Created by zhanglinfeng on 14-6-17.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPVisualAddPicture.h"
#import <QuartzCore/QuartzCore.h>
#import "RPBigVisualDetailCell.h"
#import "RPVisualCommentView.h"
#import "MarkViewController.h"
#import "RPVisualDetailCell.h"
#import "RPVisualCommentCell.h"
@protocol RPVisualMerchandisingDetailViewDelegate<NSObject>
-(void)endVisualDetail;
@end
@interface RPVisualMerchandisingDetailView : UIView<UITableViewDataSource,UITableViewDelegate,RPVisualAddPictureDelegate,RPBigVisualDetailCellDelegate,MarkViewControllerDelegate,RPVisualCommentViewDelegate,RPVisualDetailCellDelegate,RRPVisualCommentCellDelegate,RPBigVisualCellDelegate>
{
    BOOL  _bVisualCommentView;
    IBOutlet RPVisualAddPicture *_viewAddPicture;
    BOOL _bViewAddPicture;
    BOOL _bLocationView;
    IBOutlet UIView *_viewRight;
    CGPoint originalLocation;//手势原始位置
    CGPoint currentLocation;//手势当前位置
    float secondFrameOreginX;//滑动后View位置x坐标
    float secondFrameOreginY;//滑动后View位置y坐标
    IBOutlet UIView *_viewRemark;
    
    IBOutlet UIButton *_btRemark;
    IBOutlet UILabel *_lbTitle;
    IBOutlet UIView *_viewFrame;
    IBOutlet UITableView *_tbBigPic;
    IBOutlet UITableView *_tbVisualList;
    IBOutlet RPVisualCommentView *_viewComment;
    MarkViewController          * _markViewController;
    int   _bigPicIndex;//点击引用，定位大图
    NSString *_imgDetailId;//点击引用，用于和大图引用匹配画框的id
    IBOutlet UIButton *_btLocation;
    IBOutlet UIButton *_btAdd;
    int _selectIndex;//大tableview选中行
    int _selectPicIndex;//小tableview选中行
    IBOutlet UIView *_viewBackground;
    IBOutlet UILabel *_lbState;
}
@property(nonatomic,assign)id<RPVisualMerchandisingDetailViewDelegate>delegate;
@property (nonatomic,strong) FollowStore * followStore;
@property (nonatomic,strong) StoreDetailInfo * storeInfo;
@property(nonatomic,strong)VisualDisplay *visualDisplay;
@property(nonatomic,strong)ReplyList *replyList;
@property (nonatomic,assign) UIViewController * vcFrame;
-(BOOL)OnBack;
- (IBAction)OnAddPicture:(id)sender;
- (IBAction)OnPass:(id)sender;
- (IBAction)OnReject:(id)sender;
- (IBAction)OnPending:(id)sender;
- (IBAction)OnRemarkView:(id)sender;
- (IBAction)OnLocation:(id)sender;
- (IBAction)OnHelp:(id)sender;
@end
