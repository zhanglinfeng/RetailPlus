//
//  RPVisualDetailCell.h
//  RetailPlus
//
//  Created by zhanglinfeng on 14-6-17.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol RPVisualDetailCellDelegate <NSObject>
-(void)GoToImg:(ReplyImg*)image PicIndex:(int)index;
-(void)DeleteReplyEnd;
@end
@interface RPVisualDetailCell : UITableViewCell<UITableViewDelegate,UITableViewDataSource>
{
    IBOutlet UILabel *_lbPoster;
    IBOutlet UITableView *_tbPic;
    IBOutlet UILabel *_lbcontent;
    IBOutlet UIView *_viewFrame;
    NSMutableArray *_arrayImg;
    IBOutlet UILabel *_lbDate;
//    int _indexSelect;
    IBOutlet UIButton *_btDelete;
}
@property(nonatomic,assign)id<RPVisualDetailCellDelegate> delegate;
@property(nonatomic,strong)VMReply *vmReply;
@property(nonatomic,strong)ReplyList *replyList;
@property(nonatomic,assign)int indexSelect;
@property(nonatomic)BOOL bSelected;
- (IBAction)OnDelete:(id)sender;
@end
