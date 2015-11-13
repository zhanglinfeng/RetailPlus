//
//  RPLogBookSearchView.h
//  RetailPlus
//
//  Created by lin dong on 14-3-4.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPLogBookSearchDetailView.h"
#import "MJRefreshFooterView.h"
#import "RPSwitchView.h"
@protocol RPLogBookSearchViewDelegate <NSObject>
-(void)OnLogBookEnd;
@end
@interface RPLogBookSearchView : UIView<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,RPSwitchViewDelegate,RPLogBookSearchDetailViewDelegate>
{
    IBOutlet UIView *_viewBackground;
    
    IBOutlet UITextField *_tfSearch;
    IBOutlet UIView *_viewSearch;
    IBOutlet UITableView *_tbLogBook;
    IBOutlet RPLogBookSearchDetailView *_viewSearchDetail;
    BOOL _bSearchDetail;
    NSMutableArray *_arraySearch;
    MJRefreshFooterView     * _footer;
    IBOutlet UIView *_viewSwitch;
    IBOutlet UILabel *_lbState;//显示搜索范围
    RPSwitchView          * _switchSearchScope;
    BOOL            _bAllStore;
}
@property (nonatomic,assign) id<RPLogBookSearchViewDelegate>   delegate;
@property (nonatomic,assign) StoreDetailInfo            * storeSelected;
-(BOOL)OnBack;
- (IBAction)OnHelp:(id)sender;
-(IBAction)OnQuit:(id)sender;
- (IBAction)OnSearch:(id)sender;
- (IBAction)OnDelete:(id)sender;

@end
