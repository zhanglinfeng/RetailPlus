//
//  RPMenuView.h
//  RetailPlus
//
//  Created by lin dong on 13-8-12.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    TASKCOMMAND_Inspection = 100,
    TASKCOMMAND_Maintenance,
    TASKCOMMAND_ConstructionVisiting,
    TASKCOMMAND_KPIDataEntry,
    TASKCOMMAND_BoutiqueVisiting,
    TASKCOMMAND_LogBook,
    TASKCOMMAND_CourtesyCall,
    TASKCOMMAND_Training,
    TASKCOMMAND_LIVEVIDEO,
    TASKCOMMAND_CodeQuery,
    TASKCOMMAND_Visual,
    TASKCOMMAND_ConfCall,
    TASKCOMMAND_RetailConsulting,
    TASKCOMMAND_DailyStock,
    TASKCOMMAND_Elearning
}TaskCommand;

@protocol RPMenuViewDelegate<NSObject>
    -(void)OnHideMenu;
    -(void)OnSelTask:(TaskCommand)cmd;
@end

@interface RPTaskBTN : NSObject
    @property (nonatomic,retain) NSString       * strImageName;
    @property (nonatomic,retain) NSString       * strTitle;
    @property (nonatomic,retain) NSString       * strBuyString;
    @property (nonatomic)        TaskCommand    cmd;
    @property (nonatomic)        BOOL           bOwned;
@end

@interface RPTaskGroup : NSObject
    @property (nonatomic,retain) NSString       * strGroupName;
    @property (nonatomic,retain) NSMutableArray * arrayTask;
@end

@interface RPMenuView : UIView
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
    NSMutableArray      * _arrayLock;
    
    NSInteger           _nTouchBegin;
    CGRect              _rcOriginalViewFrame;
    
    RPTaskGroup             * _group1;
    RPTaskGroup             * _group2;
    RPTaskGroup             * _group3;
    RPTaskGroup             * _group4;
    RPTaskGroup             * _group5;
}

@property (nonatomic,assign) id<RPMenuViewDelegate> delegate;

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
