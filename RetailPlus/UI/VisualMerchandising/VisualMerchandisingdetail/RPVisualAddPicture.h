//
//  RPVisualAddPicture.h
//  RetailPlus
//
//  Created by zhanglinfeng on 14-6-17.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPExhibitCell.h"
#import "RPExhibitMessageCell.h"
@protocol RPVisualAddPictureDelegate <NSObject>
-(void)OnEndAdd;
@end
@interface RPVisualAddPicture : UIView<UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,RPExhibitCellDelegate,RPExhibitMessageCellDelegate>
{
    IBOutlet UIView *_viewHeader;
    
    IBOutlet UITableView *_tbPicture;
    NSMutableArray *_arrayImg;
    NSString *_strComment;
}
@property (nonatomic,strong) FollowStore * followStore;
@property(nonatomic,strong)VisualDisplay *visualDisplay;
@property (nonatomic,assign) UIViewController * vcFrame;
@property (assign, nonatomic) id<RPVisualAddPictureDelegate> delegate;
- (IBAction)OnAddPic:(id)sender;
- (IBAction)OnOK:(id)sender;
-(void)clearUI;
@end
