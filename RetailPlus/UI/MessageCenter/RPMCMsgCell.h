//
//  RPMCMsgCell.h
//  RetailPlus
//
//  Created by lin dong on 13-9-18.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RPMCMsgCellDelegate <NSObject>
    -(void)OnUploadCacheData:(CachData *)data;
@end

@interface RPMCMsgCell : UITableViewCell
{
    IBOutlet UILabel     * _lbDesc;
    IBOutlet UILabel     * _lbDate;
}

@property (nonatomic,retain) id<RPMCMsgCellDelegate> delegate;
@property (nonatomic,retain) CachData * dataCache;

-(IBAction)OnSelectUpload:(id)sender;

@end
