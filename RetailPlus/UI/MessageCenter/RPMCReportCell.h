//
//  RPMCReportCell.h
//  RetailPlus
//
//  Created by lin dong on 13-9-11.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RPMCReportCellDelegate <NSObject>
    -(void)OnSelectUserImg:(UserDetailInfo *)user;
    -(void)OnPlayRecord:(NSString *)strUrl;
@end

@interface RPMCReportCell : UITableViewCell
{
    IBOutlet UIView         * _viewLevel;
    IBOutlet UIButton       * _btnPic;
    IBOutlet UILabel        * _lbTitle;
    IBOutlet UILabel        * _lbDesc;
    IBOutlet UILabel        * _lbTime;
    IBOutlet UIButton       * _btnPicture;
    IBOutlet UIView         * _viewRecord;
    IBOutlet UIImageView    * _ivRecord;
    IBOutlet UILabel        * _lbRecordLength;
}

+ (NSInteger)CalcCellHeight:(ICDetailInfo *)info;
-(IBAction)OnSelectImg:(id)sender;
-(IBAction)OnPlayRecord:(id)sender;

@property (nonatomic,assign) id<RPMCReportCellDelegate> delegate;
@property (nonatomic) ICType type;
@property (nonatomic,retain) ICDetailInfo * detail;
@property (nonatomic,retain) NSString * strCurPlayRecordUrl;

@end
