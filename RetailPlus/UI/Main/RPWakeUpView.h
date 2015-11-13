//
//  RPWakeUpView.h
//  RetailPlus
//
//  Created by zwhe on 13-12-17.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RPWakeUpViewDelegate <NSObject>
    -(void)OnLogout;
@end

@interface RPWakeUpView : UIView<UITextFieldDelegate>
@property (strong, nonatomic) id<RPWakeUpViewDelegate> delegate;
@property (strong, nonatomic) IBOutlet UITextField *tfPassword;
@property (strong, nonatomic) IBOutlet UIView *viewPassword;
@property (strong, nonatomic) IBOutlet UIButton *btContinue;
@property (strong, nonatomic) UIViewController * vcParent;

- (IBAction)OnContinue:(id)sender;
- (void)OnEnd;

@end
