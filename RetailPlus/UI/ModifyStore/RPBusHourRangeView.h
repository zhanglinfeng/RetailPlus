//
//  RPBusHourRangeView.h
//  RetailPlus
//
//  Created by lin dong on 14-5-5.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RPBusHourRangeView : UIView<UIPickerViewDataSource,UIPickerViewDelegate>
{
    IBOutlet UIPickerView * _picker1;
    IBOutlet UIPickerView * _picker2;
    IBOutlet UIPickerView * _picker3;
    IBOutlet UIPickerView * _picker4;
}

@property (nonatomic,retain) UITextField * tfParent;
@end
