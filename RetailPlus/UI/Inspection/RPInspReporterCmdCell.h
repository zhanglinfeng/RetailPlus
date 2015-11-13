//
//  RPInspReporterCmdCell.h
//  RetailPlus
//
//  Created by lin dong on 13-9-4.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RPInspReporterCmdCellDelegate <NSObject>
    -(void)OnSelectAddColleague:(InspReporterSection *)section;
    -(void)OnSelectAddEmail:(InspReporterSection *)section;
    -(void)OnSelectAllUser:(BOOL)bAll;
@end

@interface RPInspReporterCmdCell : UITableViewCell
{
    IBOutlet UIButton * _btnAll;
}
@property (nonatomic,assign) InspReporterSection * section;
@property (nonatomic,assign) id<RPInspReporterCmdCellDelegate> delegate;
@property (nonatomic) BOOL bAll;

-(IBAction)OnSelectAddColleague:(id)sender;
-(IBAction)OnSelectAddEmail:(id)sender;

-(IBAction)OnSelectAll:(id)sender;

@end
