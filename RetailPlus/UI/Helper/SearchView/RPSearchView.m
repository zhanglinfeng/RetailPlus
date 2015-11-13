//
//  RPSearchView.m
//  RetailPlus
//
//  Created by lin dong on 14-9-18.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPSearchView.h"

@implementation RPSearchView

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
-(void)awakeFromNib
{
    [_tfSearch addTarget:self action:@selector(OnTextChange:) forControlEvents:UIControlEventEditingChanged];
}

-(void)OnTextChange:(UITextField*)sender
{
    [self UpdateUI];
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [self.delegate OnSearchChange:textField.text];
    _bEditing = NO;
    [self UpdateUI];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.delegate OnSearchChange:textField.text];
    [self endEditing:YES];
    [self UpdateUI];
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    _bEditing = YES;
    [self UpdateUI];
}

-(void)UpdateUI
{
    _btnSearch.alpha = 1;
    _btnClear.alpha = 1;
    _btnSearch.hidden = NO;
    _btnClear.hidden = NO;
    _btnSearch.userInteractionEnabled = YES;
    
    if (_bEditing)
    {
        _btnSearch.frame = CGRectMake(self.frame.size.width - _btnSearch.frame.size.width, _btnSearch.frame.origin.y, _btnSearch.frame.size.width, _btnSearch.frame.size.height);
        if (_tfSearch.text && _tfSearch.text.length != 0)
        {
            _btnSearch.alpha = 1;
            _btnSearch.userInteractionEnabled = YES;
        }
        else
        {
            _btnSearch.alpha = 0.4;
            _btnSearch.userInteractionEnabled = NO;
        }
        
        _btnClear.hidden = YES;
        
        _tfSearch.frame = CGRectMake(5, _tfSearch.frame.origin.y, self.frame.size.width - _btnSearch.frame.size.width - 10, _tfSearch.frame.size.height);
    }
    else
    {
        if (_tfSearch.text && _tfSearch.text.length != 0)
        {
            _btnClear.frame = CGRectMake(self.frame.size.width - _btnClear.frame.size.width, _btnClear.frame.origin.y, _btnClear.frame.size.width, _btnClear.frame.size.height);
            _btnSearch.hidden = YES;
            
            _tfSearch.frame = CGRectMake(5, _tfSearch.frame.origin.y, self.frame.size.width - _btnClear.frame.size.width  - 10, _btnClear.frame.size.height);
        }
        else
        {
            _btnSearch.frame = CGRectMake(0, _btnSearch.frame.origin.y, _btnSearch.frame.size.width, _btnSearch.frame.size.height);
            _btnClear.hidden = YES;
            
             _tfSearch.frame = CGRectMake(_btnSearch.frame.size.width, _tfSearch.frame.origin.y, self.frame.size.width - _btnSearch.frame.size.width, _btnSearch.frame.size.height);
        }
    }
}

-(IBAction)OnSearch:(id)sender
{
    [self endEditing:YES];
    [self.delegate OnSearchChange:_tfSearch.text];
}

-(IBAction)OnClearSearch:(id)sender
{
    _tfSearch.text = @"";
    [self endEditing:YES];
    [self.delegate OnSearchChange:_tfSearch.text];
    [self UpdateUI];
}

-(void)SetSearchString:(NSString *)strString
{
    _tfSearch.text = strString;
    [self UpdateUI];
}
@end
