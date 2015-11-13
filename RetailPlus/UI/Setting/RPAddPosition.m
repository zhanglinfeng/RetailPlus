//
//  RPAddPosition.m
//  RetailPlus
//
//  Created by lin dong on 14-9-2.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPAddPosition.h"
#import "SVProgressHUD.h"

@implementation RPAddPosition

extern NSBundle * g_bundleResorce;

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
    _viewRole.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
    _viewUnit.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
    
    [self addSubview:_viewRole];
    [self addSubview:_viewUnit];
    
    _viewRole.delegate = self;
    _viewUnit.delegate = self;
    
    _viewFrame.layer.cornerRadius = 8;
    
    _btnRole.layer.cornerRadius = 4;
    _btnUnit.layer.cornerRadius = 4;
    _btnRole.layer.borderWidth = 1;
    _btnUnit.layer.borderWidth = 1;
    _btnRole.layer.borderColor = [UIColor colorWithWhite:0.6 alpha:1].CGColor;
    _btnUnit.layer.borderColor = [UIColor colorWithWhite:0.6 alpha:1].CGColor;
    
    _btnRole.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _btnRole.contentEdgeInsets = UIEdgeInsetsMake(0,20, 0, 0);
    
    _btnUnit.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _btnUnit.contentEdgeInsets = UIEdgeInsetsMake(0,20, 0, 0);
}

-(IBAction)OnRole:(id)sender
{
    [UIView beginAnimations:nil context:nil];
    _viewRole.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [UIView commitAnimations];
    _viewShow = _viewRole;
}

-(IBAction)OnUnit:(id)sender
{
    if (_roleCurrent) {
        [UIView beginAnimations:nil context:nil];
        _viewUnit.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        [UIView commitAnimations];
        _viewUnit.roleCurrent = _roleCurrent;
        _viewShow = _viewUnit;
    }
}


-(void)SelectRole:(InviteRole *)role
{
    [UIView beginAnimations:nil context:nil];
    _viewShow.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
    [UIView commitAnimations];
    _viewShow = nil;
    
    [_btnRole setTitle:role.strRoleName forState:UIControlStateNormal];
    [_btnRole setTitleColor:[UIColor colorWithWhite:0.3f alpha:1] forState:UIControlStateNormal];
    
    _roleCurrent = role;
    _positionCurrent = nil;
    [_btnUnit setTitle:NSLocalizedStringFromTableInBundle(@"Position",@"RPString", g_bundleResorce,nil) forState:UIControlStateNormal];
    [_btnUnit setTitleColor:[UIColor colorWithWhite:0.7f alpha:1] forState:UIControlStateNormal];
}

-(void)SelectPosition:(InvitePosition *)position
{
    _positionCurrent = position;
    [_btnUnit setTitle:position.strDomainName forState:UIControlStateNormal];
    [_btnUnit setTitleColor:[UIColor colorWithWhite:0.3f alpha:1] forState:UIControlStateNormal];
    
    [UIView beginAnimations:nil context:nil];
    _viewShow.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
    [UIView commitAnimations];
    _viewShow = nil;
}

-(BOOL)OnBack
{
    if (_viewShow) {
        [UIView beginAnimations:nil context:nil];
        _viewShow.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
        [UIView commitAnimations];
        _viewShow = nil;
        return NO;
    }
    return YES;
}

-(IBAction)OnOk:(id)sender
{
    if (_roleCurrent && _positionCurrent) {
        [SVProgressHUD showWithStatus:@""];
        [[RPSDK defaultInstance] SetUserPosition:_loginProfile.strUserId Position:_positionCurrent.strPositionID Success:^(id idResult) {
            RPPosition * pos = [[RPPosition alloc] init];
            pos.strPositionId = _positionCurrent.strPositionID;
            pos.strPositionName = _positionCurrent.strDomainName;
            pos.strRoleId = _roleCurrent.strRoleID;
            pos.strRoleName = _roleCurrent.strRoleName;
            pos.rank = _roleCurrent.rankRole;
            [_loginProfile.arrayPosition addObject:pos];
            [_delegate OnAddPositionEnd];
            [SVProgressHUD dismiss];
        } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
            
        }];
    }
}

-(void)ClearData
{
    _roleCurrent = nil;
    _positionCurrent = nil;
    [_btnRole setTitle:NSLocalizedStringFromTableInBundle(@"Role Definition",@"RPString", g_bundleResorce,nil) forState:UIControlStateNormal];
    [_btnRole setTitleColor:[UIColor colorWithWhite:0.7f alpha:1] forState:UIControlStateNormal];
    [_btnUnit setTitle:NSLocalizedStringFromTableInBundle(@"Position",@"RPString", g_bundleResorce,nil) forState:UIControlStateNormal];
    [_btnUnit setTitleColor:[UIColor colorWithWhite:0.7f alpha:1] forState:UIControlStateNormal];
}
@end
