//
//  RPDatePickerDayView.h
//  RetailPlus
//
//  Created by lin dong on 14-2-11.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RPDatePickerDayView : UIView<UIPickerViewDelegate,UIPickerViewDataSource>
{
    IBOutlet UIPickerView       * _pickDay;
    
    IBOutlet UIImageView  * _ivNoDelete;
    IBOutlet UIImageView  * _ivCanDelete;
    IBOutlet UIButton     * _btnHide;
    IBOutlet UIButton     * _btnDelete;
    IBOutlet UIButton     * _btnCofirm;
}

@property (nonatomic) BOOL bCanDelete;
@property (nonatomic,retain) NSDate * date;
@property (nonatomic,retain) NSDateFormatter *formatter;
@property (nonatomic,retain) UIView * viewParent;

-(IBAction)OnEndEdit:(id)sender;
-(IBAction)OnDelete:(id)sender;
@end
