//
//  RPDatePicerView.h
//  InputTable
//
//  Created by lin dong on 13-12-21.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RPDatePicerView : UIView
{
    IBOutlet UIDatePicker * _pickerDate;
    
    IBOutlet UIImageView  * _ivNoDelete;
    IBOutlet UIImageView  * _ivCanDelete;
    IBOutlet UIButton     * _btnHide;
    IBOutlet UIButton     * _btnDelete;
    IBOutlet UIButton     * _btnCofirm;
}

@property (nonatomic) BOOL bCanDelete;
@property (nonatomic) BOOL bCanFuture;
@property (nonatomic) BOOL bCanPreviously;
@property (nonatomic,retain) NSDate * date;
@property (nonatomic,retain) NSDateFormatter *formatter;
@property (nonatomic,retain) UIView * viewParent;
@property (nonatomic,assign) UIDatePickerMode mode;
-(IBAction)OnEndEdit:(id)sender;
-(IBAction)OnDelete:(id)sender;
@end
