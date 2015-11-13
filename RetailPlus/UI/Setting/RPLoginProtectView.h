//
//  RPLoginProtectView.h
//  RetailPlus
//
//  Created by lin dong on 13-11-20.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPAccountSetupViewControllerDelegate.h"

@interface RPLoginProtectView : UIView<UITableViewDataSource,UITableViewDelegate>
{
    IBOutlet UIView         * _viewFrame;
    IBOutlet UIView         * _viewTab;
    IBOutlet UITableView    * _tbDevice;
    IBOutlet UIImageView    * _ivLoginProtect;
    IBOutlet UIView         * _viewEditName;
    IBOutlet UIView         * _viewEditNameFrame;
    IBOutlet UIView         * _viewEditNameEditFrame;
    IBOutlet UITextField    * _tfDeviceName;
    LoginDevice             * _curDevice;
    
    BOOL                    _bEditName;
}

@property (nonatomic,assign) id<RPAccountSetupViewControllerDelegate> delegate;

-(IBAction)OnEditName:(id)sender;
-(IBAction)OnLoginProtect:(id)sender;
-(BOOL)OnBack;

@end
