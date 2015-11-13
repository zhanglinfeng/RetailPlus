//
//  RPGuideViewController.h
//  RetailPlus
//
//  Created by lin dong on 14-5-15.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RPGuideViewController : UIViewController
{
    IBOutlet UIView * _arraw1;
    IBOutlet UIView * _arraw2;
    IBOutlet UIView * _arraw3;
    IBOutlet UIView * _arraw4;
    IBOutlet UIView * _arraw5;
    IBOutlet UIView * _arraw6;
    
    IBOutlet UIButton * _btn1;
    IBOutlet UIButton * _btn2;
    IBOutlet UIButton * _btn3;
    IBOutlet UIButton * _btn4;
    IBOutlet UIButton * _btn5;
    IBOutlet UIButton * _btn6;
    
    IBOutlet UIView   * _viewBody1;
    IBOutlet UIView   * _viewBody2;
    IBOutlet UIView   * _viewBody3;
    IBOutlet UIView   * _viewBody4;
    IBOutlet UIView   * _viewBody5;
    IBOutlet UIView   * _viewBody6;
    
    IBOutlet UIImageView * _ivDetail1;
    IBOutlet UIImageView * _ivDetail2;
    IBOutlet UIImageView * _ivDetail3;
    IBOutlet UIImageView * _ivDetail4;
    IBOutlet UIImageView * _ivDetail5;
    IBOutlet UIImageView * _ivDetail6;
    IBOutlet UIPageControl * _pageCtrl;
    
    NSArray * _arrayArrow;
    NSArray * _arrayBtn;
    NSArray * _arrayViewBody;
    
    NSInteger               _nCurBtnIndex;
}

-(void)Reload;
-(IBAction)OnClose:(id)sender;
-(IBAction)OnTask:(id)sender;
@end
