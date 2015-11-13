//
//  RPDateSettingViewController.h
//  RetailPlus
//
//  Created by zhanglinfeng on 14-2-8.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPTaskBaseViewController.h"
@interface RPDateSettingViewController :RPTaskBaseViewController
{
    IBOutlet UIView *_backgroundView;
    
    IBOutlet UIButton *_btDay;
    IBOutlet UIButton *_btWeek;
    IBOutlet UIButton *_btMonth;
    IBOutlet UIButton *_btQuarter;
    IBOutlet UIButton *_btYear;
    IBOutlet UIButton *_btNow;
    IBOutlet UIDatePicker *_datePicker;

}
- (IBAction)OnDay:(id)sender;
- (IBAction)OnWeek:(id)sender;
- (IBAction)OnMonth:(id)sender;
- (IBAction)OnQuarter:(id)sender;
- (IBAction)OnYear:(id)sender;

- (IBAction)OnNow:(id)sender;
- (IBAction)OnOk:(id)sender;

@end
