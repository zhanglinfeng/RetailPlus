//
//  RPAddExhibitView.h
//  RetailPlus
//
//  Created by zhanglinfeng on 14-6-16.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPExhibitLocationView.h"
#import "RPExhibitCell.h"
#import "MarkViewController.h"
#import "RPExhibitMessageCell.h"
@protocol RPAddExhibitViewDelegate <NSObject>
-(void)OnEndAdd;
@end
@interface RPAddExhibitView : UIView<UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,RPExhibitCellDelegate,MarkViewControllerDelegate,RPExhibitMessageCellDelegate>
{
    IBOutlet UIView *_viewFrame;
    
    IBOutlet RPExhibitLocationView *_viewLocation;
    BOOL     _bLocationView;
    IBOutlet UITextField *_tfTitle;
    IBOutlet UITableView *_tbPicture;
    NSMutableArray *_arrayImg;
    NSString *_strComment;
    float _x;
    float _y;
    MarkViewController          * _markViewController;
    IBOutlet UIImageView *_ivLocated;
    IBOutlet UILabel *_lbLocate;
}
@property (assign, nonatomic) id<RPAddExhibitViewDelegate> delegate;
@property (nonatomic,strong) FollowStore * followStore;
@property (nonatomic,assign) UIViewController * vcFrame;
- (IBAction)OnSelectLocation:(id)sender;
- (IBAction)OnAddPicture:(id)sender;
- (IBAction)OnOk:(id)sender;
-(BOOL)OnBack;
-(void)clearUI;
@end
