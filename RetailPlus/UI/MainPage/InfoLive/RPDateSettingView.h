//
//  RPDateSettingView.h
//  RetailPlus
//
//  Created by zhanglinfeng on 14-2-8.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>

#define YEARCOUNT       20

@protocol RPDateSettingViewDelegate <NSObject>
-(void)OnSettingDateEnd;
@end

@interface RPDateSettingView : UIView<UIPickerViewDataSource,UIPickerViewDelegate>
{
    IBOutlet UIView *_backgroundView;
    
    IBOutlet UIButton                   *_btDay;
    IBOutlet UIButton                   *_btWeek;
    IBOutlet UIButton                   *_btMonth;
    IBOutlet UIButton                   *_btQuarter;
    IBOutlet UIButton                   *_btYear;
    IBOutlet UIButton                   *_btNow;
    
    IBOutlet UIDatePicker               *_datePicker;
    IBOutlet UIPickerView               *_pickerWeek;
    IBOutlet UIPickerView               *_pickerMonth;
    IBOutlet UIPickerView               *_pickerQuarter;
    IBOutlet UIPickerView               *_pickerYear;
    
    NSMutableArray                      *_arrayMonth;
}

@property (nonatomic,assign) id<RPDateSettingViewDelegate> delegate;
@property (nonatomic,copy) KPIDateRange * range;

- (IBAction)OnDay:(id)sender;
- (IBAction)OnWeek:(id)sender;
- (IBAction)OnMonth:(id)sender;
- (IBAction)OnQuarter:(id)sender;
- (IBAction)OnYear:(id)sender;

- (IBAction)OnNow:(id)sender;
- (IBAction)OnOk:(id)sender;

-(BOOL)OnBack;
@end
