//
//  RPBusHourRangeView.m
//  RetailPlus
//
//  Created by lin dong on 14-5-5.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPBusHourRangeView.h"

@implementation RPBusHourRangeView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView == _picker1 || pickerView == _picker3)
        return 24;
    return 4;
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (pickerView == _picker1 || pickerView == _picker3)
        return [NSString stringWithFormat:@"%02d",row];
    return [NSString stringWithFormat:@"%02d",row * 15];
}

-(void)setTfParent:(UITextField *)tfParent
{
    _tfParent = tfParent;
    if (_tfParent.text.length >= 13 ) {
        NSString * str = [_tfParent.text substringWithRange:NSMakeRange(0, 2)];
        [_picker1 selectRow:str.integerValue inComponent:0 animated:YES];
        
        str = [_tfParent.text substringWithRange:NSMakeRange(3, 2)];
        [_picker2 selectRow:str.integerValue / 15 inComponent:0 animated:YES];
        
        str = [_tfParent.text substringWithRange:NSMakeRange(8, 2)];
        [_picker3 selectRow:str.integerValue inComponent:0 animated:YES];
        
        str = [_tfParent.text substringWithRange:NSMakeRange(11, 2)];
        [_picker4 selectRow:str.integerValue / 15 inComponent:0 animated:YES];
    }
}

-(IBAction)OnCancel:(id)sender
{
    [_tfParent endEditing:YES];
}

-(IBAction)OnOk:(id)sender
{
    [_tfParent setText:[NSString stringWithFormat:@"%02d:%02d - %02d:%02d",[_picker1 selectedRowInComponent:0] ,[_picker2 selectedRowInComponent:0] * 15,[_picker3 selectedRowInComponent:0],[_picker4 selectedRowInComponent:0] * 15]];
    [_tfParent endEditing:YES];
}
@end
