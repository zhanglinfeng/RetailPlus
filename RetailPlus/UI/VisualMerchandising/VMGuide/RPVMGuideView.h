//
//  RPVMGuideView.h
//  RetailPlus
//
//  Created by zhanglinfeng on 14-6-17.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPWebDocViewController.h"
@protocol RPVMGuideViewDelegate<NSObject>
-(void)endVMGuide;
@end
@interface RPVMGuideView : UIView<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,RPWebDocViewControllerDelegate>
{
    IBOutlet UITableView *_tbGuide;
    IBOutlet UIView *_viewHead;
    IBOutlet UIView *_viewSearch;
    NSMutableArray *_arrayGuide;
    NSMutableArray *_arraySearch;
    IBOutlet UITextField *_tfSearch;
}
@property(nonatomic,assign)id<RPVMGuideViewDelegate>delegate;
@property (nonatomic,assign) UIViewController * vcFrame;
- (IBAction)OnSearch:(id)sender;
- (IBAction)OnDeleteSearch:(id)sender;
- (IBAction)OnHelp:(id)sender;
-(IBAction)OnQuit:(id)sender;
@end
