//
//  RPBigVisualDetailCell.h
//  RetailPlus
//
//  Created by zhanglinfeng on 14-6-20.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPImageMarkTouchView.h"
@protocol RPBigVisualDetailCellDelegate <NSObject>
-(void)OnGoComment:(ReplyImg*)replyImg;
@end

@protocol RPBigVisualCellDelegate <NSObject>
-(void)GoToSmall:(int)indexVMReply ImgDetailIndex:(int)indexReplyImgDetail Type:(int)type;
@end
@interface RPBigVisualDetailCell : UITableViewCell<UITableViewDataSource,UITableViewDelegate>
{
    
    IBOutlet UIImageView *_ivPic;
    IBOutlet UITableView *_tbComment;
    NSMutableArray *_arrayComment;
    NSMutableArray *_arrayImgDetail;
    NSString *_strUserName;
    Rank      _rank;
    IBOutlet RPImageMarkTouchView   * _markView;
    IBOutlet UIButton *_btComment;
    int _indexVMReply;//大图中图片在小图列表中位置
    int _indexReplyImgDetail;//大图中图片在小图列表中的嵌套的小列表中的位置
    int _positionType;//0代表小图列表滑动定位原图或回复添加的图，1代表小图列表滑动定位引用画框的图
    
}
@property (assign, nonatomic) id<RPBigVisualDetailCellDelegate> delegate;
@property (assign, nonatomic) id<RPBigVisualCellDelegate> delegateGoToSmall;
@property(nonatomic,strong)ReplyList *replyList;
@property(nonatomic,strong) ReplyImg *replyImg;
@property(nonatomic,strong)VisualDisplay *visualDisplay;
- (IBAction)OnComment:(id)sender;
-(void)SetSelectReply:(NSString *)strReplyId;
@end
