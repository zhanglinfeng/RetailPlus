//
//  RPLogBookDetailView.h
//  RetailPlus
//
//  Created by lin dong on 14-3-3.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPLogBookPostView.h"
#import "RPLogBookSearchView.h"
#import "RPLogBookCell.h"
#import "RPLogBookSearchDetailView.h"
#import "MJRefreshFooterView.h"
#import "MJRefreshHeaderView.h"
#import "UIMarqueeLabel.h"
@protocol RPLogBookDetailViewDelegate <NSObject>
-(void)OnLogBookEnd;
@end
@interface RPLogBookDetailView : UIView<UITableViewDataSource,UITableViewDelegate,RPLogBookCellDelegate,RPLogBookPostViewDelegate,RPLogBookSearchViewDelegate,RPLogBookSearchDetailViewDelegate>
{
    IBOutlet   UIView       * _viewFrame;
    IBOutlet   UIMarqueeLabel      * _lbStoreTitle;
    IBOutlet   UIMarqueeLabel      * _lbStoreName;
    IBOutlet   UIView       * _viewHead;
    IBOutlet   UIView       * _viewFilter;
    IBOutlet   UIView       * _viewFilterGuide;
    IBOutlet   UIView       * _viewThemeSelection;
    IBOutlet   UILabel      * _lbThemeName;
    
    
    IBOutlet   UITableView  * _tbDetail;
    IBOutlet UIButton *_btFilter;
    IBOutlet UIButton *_btMyPost;
    IBOutlet UIButton *_btUnread;
    IBOutlet UIButton *_btMyFocus;
    
    MJRefreshFooterView     * _footer;
    MJRefreshHeaderView     * _header;
    
    NSMutableArray          * _arrayLogBook;
    BOOL                    bShowFilter;
    BOOL                    bFilterMyPost;
    BOOL                    bFilterUnRead;
    BOOL                    bFilterFocus;
    NSString                * _strTagID;
    
    IBOutlet RPLogBookPostView *_viewBookPost;
    IBOutlet RPLogBookSearchView *_viewBookSearch;
    IBOutlet RPLogBookSearchDetailView *_viewSearchDetail;
    BOOL                             _bBookPost;
    BOOL                             _bBookSearch;
    IBOutlet UIImageView *_ivTriange;
    IBOutlet UIView *_viewLine;
}
@property (nonatomic,assign) id<RPLogBookDetailViewDelegate>   delegate;
@property (nonatomic,assign) UIViewController               * vcFrame;
@property (nonatomic,assign) StoreDetailInfo                * storeSelected;
- (IBAction)OnHelp:(id)sender;
-(IBAction)OnQuit:(id)sender;
-(BOOL)OnBack;

-(IBAction)OnFilter:(id)sender;
-(IBAction)OnSearch:(id)sender;
-(IBAction)OnMyPost:(id)sender;
-(IBAction)OnUnread:(id)sender;
-(IBAction)OnAddLogBook:(id)sender;
- (IBAction)OnFresh:(id)sender;
- (IBAction)OnThemeSelected:(id)sender;

@end
