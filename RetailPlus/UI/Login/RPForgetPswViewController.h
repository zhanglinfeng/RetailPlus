//
//  RPForgetPswViewController.h
//  RetailPlus
//
//  Created by lin dong on 13-11-11.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPForgetPswFirstView.h"
#import "RPForgetPswVerifyView.h"
#import "RPForgetPswChgPswView.h"



@interface RPForgetPswViewController : UIViewController<RPForgetPswFirstViewDelegate,RPForgetPswVerifyViewDelegate,RPForgetPswChgPswViewDelegate>
{
    IBOutlet UIView                * _viewBorder;
    IBOutlet UIView                * _viewFrame;
    
    IBOutlet RPForgetPswFirstView  * _viewFirst;
    IBOutlet RPForgetPswVerifyView * _viewVerify;
    IBOutlet RPForgetPswChgPswView * _viewChgPsw;
    
    NSString                       * _strNumber;
    
    CGRect                         _rcMoveout;
    CGRect                         _rcCurrent;
    CGRect                         _rcStandby;
    NSInteger                      _nStep;
}
@property(strong,nonatomic)NSString * phoneNumber;
@property (strong, nonatomic) IBOutlet UILabel *lbtitle;
-(IBAction)OnBackBtn:(id)sender;
@end
