//
//  RPMCReportCell.m
//  RetailPlus
//
//  Created by lin dong on 13-9-11.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "RPMCReportCell.h"
#import "UIButton+WebCache.h"
#import "RPShowImgViewController.h"
#import "RPAppDelegate.h"
#import "RPMainViewController.h"

extern NSBundle * g_bundleResorce;

@implementation RPMCReportCell

+ (NSInteger)CalcCellHeight:(ICDetailInfo *)info
{
    switch (info.format) {
        case ICMsgFormat_Picture:
            return 102;
            break;
        case ICMsgFormat_Voice:
            return 74;
            break;
        case ICMsgFormat_Text:
        {
            NSInteger nLableHeight = 50;
            
            CGSize size = [info.strSubject sizeWithFont:[UIFont systemFontOfSize:11] constrainedToSize:CGSizeMake(267, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
            if ((size.height + 31) > 50) {
                nLableHeight = size.height + 31;
            }
            return nLableHeight;
        }
            break;
        default:
            break;
    }
    return 0;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)awakeFromNib
{
    _btnPic.layer.cornerRadius = 5;
    _btnPic.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _btnPic.layer.borderWidth = 1;
    _viewRecord.layer.cornerRadius = 6;
    _viewRecord.layer.borderWidth = 1.0;
    _viewRecord.layer.borderColor = [UIColor colorWithWhite:0.7 alpha:1].CGColor;
    
    _btnPicture.layer.borderColor = [UIColor colorWithWhite:0.3 alpha:1].CGColor;
    _btnPicture.layer.cornerRadius = 6;
    
}

#define kMinInSec 60
#define kHourInSec (60*kMinInSec)
#define kDayInSec (24*kHourInSec)
#define kMonthInSec (30*kDayInSec)
#define kYearInSec (365*kMonthInSec)

-(void)setDetail:(ICDetailInfo *)detail
{
    _detail = detail;
    
    [_btnPic setImage:nil forState:UIControlStateNormal];
    _viewLevel.backgroundColor = [UIColor lightGrayColor];
    
    switch (_type) {
        case ICType_Message:
            switch (detail.typeMsg) {
                case ICMsgType_SystemNotify:
                    _lbTitle.text = NSLocalizedStringFromTableInBundle(@"System Notification",@"RPString", g_bundleResorce,nil);
                    [_btnPic setImage:[UIImage imageNamed:@"image_rpsystem.png"] forState:UIControlStateNormal];
                    break;
                case ICMsgType_BroadCast:
                    _lbTitle.text =  NSLocalizedStringFromTableInBundle(@"Administrator Notification",@"RPString", g_bundleResorce,nil);
                    break;
                case ICMsgType_GroupMsg:
                    _lbTitle.text = [NSString stringWithFormat:@"%@ %@",detail.userPost.strFirstName, NSLocalizedStringFromTableInBundle(@"Broadcast:",@"RPString", g_bundleResorce,nil)];
                    break;
                default:
                    break;
            }
            break;
        case ICType_Report:
            _lbTitle.text = @"Received";
            break;
        case ICType_Task:
            _lbTitle.text = @"Task Remind";
            break;
        default:
            break;
    }
    
    
    if (detail.userPost != nil) {
        [_btnPic setImageWithURLString:detail.userPost.strPortraitImg forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"icon_userimage01_224.png"]];
        
        switch (detail.userPost.rank) {
            case Rank_Manager:
                _viewLevel.backgroundColor = [UIColor colorWithRed:150.0f/255 green:70.0f/255 blue:150.0f/255 alpha:1];
                break;
            case Rank_StoreManager:
                _viewLevel.backgroundColor = [UIColor colorWithRed:230.0f/255 green:110.0f/255 blue:10.0f/255 alpha:1];
                break;
            case Rank_Assistant:
                _viewLevel.backgroundColor = [UIColor colorWithRed:50.0f/255 green:105.0f/255 blue:175.0f/255 alpha:1];
                break;
            case Rank_Vendor:
                _viewLevel.backgroundColor = [UIColor colorWithRed:150.0f/255 green:170.0f/255 blue:20.0f/255 alpha:1];
                break;
            default:
                break;
        }
    }
    
    
    NSString * strBefore = @"";
    if (detail.dtTime && (id)detail.dtTime != [NSNull null]) {
        NSInteger interval = -(NSInteger)[detail.dtTime timeIntervalSinceNow];
        NSInteger nYear = interval / kYearInSec;
        NSInteger nMonth = (interval - nYear * kYearInSec) / kMonthInSec;
        NSInteger nDay = (interval - nYear * kYearInSec - nMonth * kMonthInSec) / kDayInSec;
        NSInteger nHour = (interval - nYear * kYearInSec - nMonth * kMonthInSec - nDay * kDayInSec) / kHourInSec;
        NSInteger nMin = (interval - nYear * kYearInSec - nMonth * kMonthInSec - nDay * kDayInSec - nHour * kHourInSec) / kMinInSec;
        NSInteger nSec = interval - nYear * kYearInSec - nMonth * kMonthInSec - nDay * kDayInSec - nHour * kHourInSec - nMin * kMinInSec;
        
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        df.dateFormat = @"yyyy-MM-dd";
        
        if (nYear > 0) {
            strBefore = [df stringFromDate:detail.dtTime];
        }
        else if (nMonth > 0) {
            strBefore = [df stringFromDate:detail.dtTime];
        }
        else if (nDay > 0) {
            strBefore = [df stringFromDate:detail.dtTime];
        }
        else if (nHour > 0) {
            strBefore = [NSString stringWithFormat:@"%d %@",nHour,NSLocalizedStringFromTableInBundle(@"hour ago",@"RPString", g_bundleResorce,nil)];
        }
        else if (nMin > 0) {
            strBefore = [NSString stringWithFormat:@"%d %@",nMin,NSLocalizedStringFromTableInBundle(@"min ago",@"RPString", g_bundleResorce,nil)];
        }
        else if (nSec > 0) {
            strBefore = [NSString stringWithFormat:@"%d %@",nSec,NSLocalizedStringFromTableInBundle(@"sec ago",@"RPString", g_bundleResorce,nil)];
        }
        else
            strBefore = NSLocalizedStringFromTableInBundle(@"Now",@"RPString", g_bundleResorce,nil);
    }
    _lbTime.text = strBefore;
    
    
    switch (detail.format) {
        case ICMsgFormat_Text:
            _lbDesc.hidden = NO;
            _btnPicture.hidden = YES;
            _viewRecord.hidden = YES;
            _lbDesc.text = detail.strSubject;
            break;
        case ICMsgFormat_Picture:
        {
            _lbDesc.hidden = YES;
            _btnPicture.hidden = NO;
            _viewRecord.hidden = YES;
            NSString * strFileName = [detail.strSubject stringByReplacingOccurrencesOfString:@"." withString:@"_1." options:NSCaseInsensitiveSearch range:NSMakeRange(detail.strSubject.length - 5, 5)];
            [_btnPicture setImageWithURLString:strFileName forState:UIControlStateNormal];
        }
            break;
        case ICMsgFormat_Voice:
            _lbDesc.hidden = YES;
            _btnPicture.hidden = YES;
            _viewRecord.hidden = NO;
            _lbRecordLength.text = detail.strFileSize;
            break;
        default:
            break;
    }
    
    if ([detail.strSubject isEqualToString:_strCurPlayRecordUrl])
        [_ivRecord setImage:[UIImage animatedImageNamed:@"icon_voice_play_frame" duration:1.0]];
    else
        [_ivRecord setImage:[UIImage imageNamed:@"icon_voice_play_frame3.png"]];
}

-(IBAction)OnSelectImg:(id)sender
{
    if (_detail.userPost) {
        [self.delegate OnSelectUserImg:_detail.userPost];
    }
}

-(IBAction)OnOpenPicture:(id)sender
{
    RPShowImgViewController * vcWeb = [[RPShowImgViewController alloc] initWithNibName:NSStringFromClass([RPShowImgViewController class]) bundle:nil];
    
    RPAppDelegate * app = (RPAppDelegate *)[[UIApplication sharedApplication] delegate];
    [app.viewController presentViewController:vcWeb animated:YES completion:^{
        [vcWeb SetImageUrl:_detail.strSubject];
    }];
}

-(IBAction)OnPlayRecord:(id)sender
{
    [self.delegate OnPlayRecord:_detail.strSubject];
}
@end
