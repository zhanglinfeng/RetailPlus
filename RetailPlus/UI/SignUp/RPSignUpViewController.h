//
//  RPSignUpViewController.h
//  RetailPlus
//
//  Created by lin dong on 13-8-13.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPSignUpVerifyViewController.h"


@protocol RPSignUpViewControllerDelgate <NSObject>
-(void)OnSignUpSuccess:(NSInteger)nInviteStatus Account:(NSString *)strAccount PassWord:(NSString *)strPassWord;
@end

@interface RPSignUpViewController : UIViewController<UINavigationControllerDelegate,RPSignUpViewControllerDelgate>
{
    IBOutlet UIView                             * _viewBorder;
    IBOutlet UIView                             * _viewNavFrame;
    IBOutlet UINavigationController             * _navCtrl;
    IBOutlet RPSignUpVerifyViewController       * _rootViewCtrl;
    IBOutlet UILabel                            * _lbTitle;
}

@property (nonatomic,assign) id<RPSignUpViewControllerDelgate> delegate;

-(IBAction)OnBackBtn:(id)sender;
@end
