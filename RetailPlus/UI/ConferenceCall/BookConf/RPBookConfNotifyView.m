//
//  RPBookConfNotifyView.m
//  RetailPlus
//
//  Created by lin dong on 14-6-20.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPBookConfNotifyView.h"
#import "SVProgressHUD.h"
#import "RPYuanTelApi.h"

@implementation RPBookConfNotifyView

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
    _tvMsg.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _tvMsg.layer.borderWidth = 1;
    _tvMsg.layer.cornerRadius = 6;
    _viewFrame.layer.cornerRadius = 8;
}

-(void)setConfBook:(RPConfBook *)confBook
{
    _confBook = confBook;
    _bSendMsg = YES;
    _ivSendCheck.image = [UIImage imageNamed:@"icon_selected_setup.png"];
    
    [SVProgressHUD showWithStatus:@""];
    _tvMsg.text = @"";
    [[RPYuanTelApi defaultInstance] GetPassCode:_confBook.strConfRoomId Success:^(RPConfPassCode * code) {
        NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy/MM/dd HH:mm"];
        
        _tvMsg.text = [NSString stringWithFormat:@"%@邀请您参加主题为\"%@\"的电话会议。会议将在%@开始。届时会议中心将会拨打您的电话，请保持电话畅通。\n\n您也可以主动拨打%@，根据提示使用密码%@登录参加会议。",_confBook.strHostName,_confBook.strCallTheme,[formatter stringFromDate:_confBook.dateBooking],[RPYuanTelApi defaultInstance].strAttachPhone,code.strGuestPassCode];
        
        [SVProgressHUD dismiss];
    } failed:^(NSInteger nErrorCode, NSString *strDesc) {
        
        [SVProgressHUD dismiss];
    }];
}

-(IBAction)OnCheck:(id)sender
{
    _bSendMsg = !_bSendMsg;
    if (!_bSendMsg) {
        _ivSendCheck.image = [UIImage imageNamed:@"icon_noselected_setup.png"];
    }
    else
    {
        _ivSendCheck.image = [UIImage imageNamed:@"icon_selected_setup.png"];
    }
}

-(IBAction)OnConfirm:(id)sender
{
    if (_bSendMsg)
    {
        NSString * strSMS = _confBook.strHostPhone;
        NSString * strEmail = _confBook.strHostEmail;
        
        for (RPConfBookMember * member in _confBook.arrayMember) {
            if (member.strMemberPhone.length > 0)
            {
               strSMS = [strSMS stringByAppendingString:@","];
               strSMS = [strSMS stringByAppendingString:member.strMemberPhone];
            }
            
            if (member.strMemberEmail.length > 0)
            {
                strEmail = [strEmail stringByAppendingString:@","];
                strEmail = [strEmail stringByAppendingString:member.strMemberEmail];
            }
        }
        
        NSString * strTitle = [NSString stringWithFormat:@"会议通知-%@",_confBook.strCallTheme];    
        
        [[RPSDK defaultInstance] SendMessage:SendMessageType_Mail Title:strTitle Detail:_tvMsg.text Member:strEmail Success:^(id idResult) {
            
        } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
            
        }];
        

        [[RPSDK defaultInstance] SendMessage:SendMessageType_SMS Title:strTitle Detail:_tvMsg.text Member:strSMS Success:^(id idResult) {
            
        } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
            
        }];
    }
    [self.delegate OnBookingSendMsgEnd];
}
@end
