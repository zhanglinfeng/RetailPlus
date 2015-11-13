//
//  RPAboutViewController.h
//  RetailPlus
//
//  Created by lin dong on 13-10-11.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPTaskBaseViewController.h"
#import "RPMainViewController.h"
#import "RPAccountSetupViewControllerDelegate.h"
@protocol RPAboutViewControllerDelegate<NSObject>
-(void)OnFeedback;
@end
@interface RPAboutViewController : RPTaskBaseViewController
{
    IBOutlet UIView      * _viewFrame;
    IBOutlet UILabel     * _lbVersion;
    IBOutlet UIView      * _viewTableFrame;
    
    IBOutlet UIView      * _viewNewVersion;
    IBOutlet UIView      * _viewNewVersionFrame;
    IBOutlet UITextView  * _tvNewVerDesc;
    IBOutlet UILabel     * _lbNewVersion;
    IBOutlet UIButton    * _btnUpdate;
    
    IBOutlet UILabel     * _lbServer;
    
    VersionModel         * _version;
    BOOL                _bShowUpdate;
    BOOL                _bFeedback;
}

@property (nonatomic,assign) id<RPMainViewControllerDelegate> delegate;

-(IBAction)OnRate:(id)sender;
-(IBAction)OnFunctionInstruction:(id)sender;
-(IBAction)OnCheckVersion:(id)sender;
-(IBAction)OnContactUS:(id)sender;
-(IBAction)OnUpdate:(id)sender;
-(IBAction)OnFeedback:(id)sender;
-(IBAction)OnHelp:(id)sender;
- (IBAction)OnVisitOfficialSite:(id)sender;

@end
