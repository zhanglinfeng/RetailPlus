//
//  RPCodeQueryHistoryView.h
//  RetailPlus
//
//  Created by zhanglinfeng on 14-5-5.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPCodeResultView.h"
@protocol RPCodeQueryHistoryViewDelegate<NSObject>
-(void)endCodeHistory;
@end
@interface RPCodeQueryHistoryView : UIView<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,RPCodeResultViewDelegate>
{
    IBOutlet UIView              *_viewHeader;
    
    IBOutlet UIView              *_viewSearch;
    IBOutlet UITextField         *_tfSearch;
    IBOutlet UITableView         *_tbCodeHistory;
    
    IBOutlet UIButton            *_btMenu;
    IBOutlet UIButton *_btSelect;
    NSMutableArray               *_arrayDelete;
    BOOL                         _bResultView;
    IBOutlet RPCodeResultView *_viewResult;
}
@property(nonatomic,weak)id<RPCodeQueryHistoryViewDelegate>delegate;
@property(nonatomic,strong)NSArray *arrayHistory;
- (IBAction)OnDeleteSearch:(id)sender;
- (IBAction)OnMenu:(id)sender;
- (IBAction)OnDelete:(id)sender;
- (IBAction)OnSelected:(id)sender;
- (IBAction)OnQuit:(id)sender;
-(BOOL)OnBack;
@end
