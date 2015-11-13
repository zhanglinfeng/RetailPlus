//
//  RPForgetPswVerifyView.h
//  RetailPlus
//
//  Created by lin dong on 13-11-11.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RPForgetPswVerifyViewDelegate <NSObject>
-(void)OnGetCode:(BOOL)bVerifyByPhone;
-(void)OnVerify:(NSString *)strVerifyCode;
@end

@interface RPForgetPswVerifyView : UIView
{
    IBOutlet UIView         * _viewTextFrame;
    IBOutlet UITextField    * _tfCode;
    IBOutlet UILabel        * _lbDesc;
    IBOutlet UIButton       * _btnGetCode;
    
    NSTimer                 * _timer;
    NSInteger               _nRemain;
}

@property (nonatomic) BOOL bVerifyByPhone;
@property (nonatomic,retain) id<RPForgetPswVerifyViewDelegate> delegate;

-(IBAction)OnGetCode:(id)sender;
-(IBAction)OnVerify:(id)sender;
@end
