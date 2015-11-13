//
//  RPLoginAutomatIcallyView.m
//  RetailPlus
//
//  Created by zwhe on 13-12-16.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import "RPLoginAutoView.h"

@implementation RPLoginAutoView

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
    _viewFrame.layer.cornerRadius=6;
    if ([RPSDK defaultInstance].IsAutoLogin)
    {
        _ivLoginAuto.image=[UIImage imageNamed:@"icon_selected_setup.png"];
    }
    else
    {
        _ivLoginAuto.image=[UIImage imageNamed:@"icon_noselected_setup.png"];
    }
}

- (IBAction)OnLoginAuto:(id)sender
{
    if ([RPSDK defaultInstance].IsAutoLogin) {
        _ivLoginAuto.image = [UIImage imageNamed:@"icon_noselected_setup.png"];
        [[RPSDK defaultInstance]SaveLoginUserName:[[[RPSDK defaultInstance]userLoginDetail ]strUserAcount] FullName:[NSString stringWithFormat:@"%@",[RPSDK defaultInstance].userLoginDetail.strFirstName] Password:[[RPSDK defaultInstance]strLoginPassword] autoLogin:NO];
    }
    else
    {
        _ivLoginAuto.image = [UIImage imageNamed:@"icon_selected_setup.png"];
        [[RPSDK defaultInstance]SaveLoginUserName:[[[RPSDK defaultInstance]userLoginDetail ]strUserAcount] FullName:[NSString stringWithFormat:@"%@",[RPSDK defaultInstance].userLoginDetail.strFirstName] Password:[[RPSDK defaultInstance]strLoginPassword] autoLogin:YES];
        
    }

}
@end
