//
//  RPMaintenAddView.h
//  RetailPlus
//
//  Created by lin dong on 13-9-16.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import "RPMaintenContactView.h"
#import "RPInspReporterView.h"

@protocol RPMaintenAddViewDelegate <NSObject>
-(void)OnMaintenEnd;
@end

@interface RPMaintenAddView : UIView<RPInspReporterViewDelegate,UITextViewDelegate>
{
    IBOutlet UIView               * _viewBorder;
    IBOutlet UIView               * _viewRemark;
    
    IBOutlet RPMaintenContactView * _viewContact1;
    IBOutlet RPMaintenContactView * _viewContact2;
    IBOutlet UITextView           * _tvRemark;
    
    IBOutlet RPInspReporterView   * _viewReporter;
    BOOL                          _bShowReporterView;
    IBOutlet UIView *_viewTap;
}

@property (nonatomic,assign) id<RPMaintenAddViewDelegate>   delegate;
@property (nonatomic,retain) NSMutableArray                 * arrayContact;
@property (nonatomic,assign) MaintenanceData                * dataMainten;
@property (nonatomic,assign) StoreDetailInfo                * storeSelected;

-(IBAction)OnConfirm:(id)sender;

-(BOOL)OnBack;
- (IBAction)OnHelp:(id)sender;
@end
