//
//  RPNewMenuView.h
//  RetailPlus
//
//  Created by zhanglinfeng on 14-3-10.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum
{
    N_TASKCOMMAND_Inspection = 100,
    N_TASKCOMMAND_Maintenance,
    N_TASKCOMMAND_ConstructionVisiting,
    N_TASKCOMMAND_KPIDataEntry,
    N_TASKCOMMAND_BoutiqueVisiting,
    N_TASKCOMMAND_LogBook,
    N_TASKCOMMAND_CourtesyCall,
}newTaskCommand;

@protocol RPNewMenuViewDelegate<NSObject>
-(void)OnHideNewMenu;
-(void)OnSelNewTask:(newTaskCommand)cmd;
@end

@interface RPTaskBT : NSObject
@property (nonatomic,retain) NSString       * strImageName;
@property (nonatomic,retain) NSString       * strTitle;
@property (nonatomic)        newTaskCommand    cmd;
@end

@interface RPNewTaskGroup : NSObject
@property (nonatomic,retain) NSString       * strGroupName;
@property (nonatomic,retain) NSMutableArray * arrayTask;
@end
@interface RPNewMenuView : UIView
{
    IBOutlet UIView     * _viewRightBack;
    IBOutlet UIView     * _viewHideBar;
    
    IBOutlet UIButton   * _btnGroup1;
    IBOutlet UIButton   * _btnGroup2;
    IBOutlet UIButton   * _btnGroup3;
    IBOutlet UIButton   * _btnGroup4;
    IBOutlet UIButton   * _btnGroup5;
    IBOutlet UIButton   * _btnGroup6;
    
    IBOutlet UILabel    * _lbGroupTitle;
    IBOutlet UIScrollView *_svTask;
    IBOutlet UIButton   * _btnTask1;
    IBOutlet UIButton   * _btnTask2;
    IBOutlet UIButton   * _btnTask3;
    IBOutlet UIButton   * _btnTask4;
    IBOutlet UIButton   * _btnTask5;
    IBOutlet UIButton   * _btnTask6;
    IBOutlet UIButton   * _btnTask7;
    IBOutlet UIButton   * _btnTask8;
    
    IBOutlet UIView     * _viewArrow;
    
    NSArray             * _arrayTask;
    
    NSInteger           _nTouchBegin;
    CGRect              _rcOriginalViewFrame;
    
    RPNewTaskGroup             * _group1;
    RPNewTaskGroup             * _group2;
    RPNewTaskGroup             * _group3;
    RPNewTaskGroup             * _group4;
    RPNewTaskGroup             * _group5;
}
@property (nonatomic,assign) id<RPNewMenuViewDelegate> delegate;
-(IBAction)OnSelGroup1:(id)sender;
-(IBAction)OnSelGroup2:(id)sender;
-(IBAction)OnSelGroup3:(id)sender;
-(IBAction)OnSelGroup4:(id)sender;
-(IBAction)OnSelGroup5:(id)sender;
-(IBAction)OnSelGroup6:(id)sender;

-(IBAction)OnSelTask:(id)sender;

-(void)reloadUI;
-(void)reloadUIDemo;
@end
