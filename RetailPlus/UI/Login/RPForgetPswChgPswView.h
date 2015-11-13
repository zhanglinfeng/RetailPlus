//
//  RPForgetPswChgPswView.h
//  RetailPlus
//
//  Created by lin dong on 13-11-11.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RPForgetPswChgPswViewDelegate <NSObject>
    -(void)OnChangePsw:(NSString *)strPsw;
@end

@interface RPForgetPswChgPswView : UIView
{
    IBOutlet UIView         * _viewTextFrame;
    IBOutlet UITextField    * _tfPsw;
    IBOutlet UITextField    * _tfRepeat;
    IBOutlet UILabel        * _lbDesc;
}

@property (nonatomic) BOOL bVerifyByPhone;
@property (nonatomic,retain) id<RPForgetPswChgPswViewDelegate> delegate;

-(IBAction)OnChangePsw:(id)sender;
-(IBAction)OnShowPsw:(id)sender;
-(IBAction)OnHidePsw:(id)sender;
@end
