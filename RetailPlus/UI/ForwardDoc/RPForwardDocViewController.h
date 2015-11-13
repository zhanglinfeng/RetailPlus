//
//  RPForwardDocViewController.h
//  RetailPlus
//
//  Created by lin dong on 13-12-11.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPMainViewController.h"
#import "RPTaskBaseViewController.h"
#import "RPInspReporterView.h"

@interface RPForwardDocViewController : RPTaskBaseViewController<RPInspReporterViewDelegate>
{
   IBOutlet RPInspReporterView * _viewReport;
}

@property (nonatomic,assign) id<RPMainViewControllerDelegate>   delegate;
@property (nonatomic,retain) Document * doc;
- (IBAction)OnHelp:(id)sender;
@end
