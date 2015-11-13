//
//  RPMCMsgCell.m
//  RetailPlus
//
//  Created by lin dong on 13-9-18.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import "RPMCMsgCell.h"

@implementation RPMCMsgCell

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

-(void)setDataCache:(CachData *)dataCache
{
    _dataCache = dataCache;
    
    switch(dataCache.type)
    {
        case CACHETYPE_INSPECTION:
            _lbDesc.text = [NSString stringWithFormat:@"Inspection:%@",dataCache.strDesc];
            break;
        case CACHETYPE_RECTIFICITION:
            _lbDesc.text = [NSString stringWithFormat:@"Rectificition:%@",dataCache.strDesc];
            break;
        case CACHETYPE_VISITING:
            _lbDesc.text = [NSString stringWithFormat:@"CVisiting:%@",dataCache.strDesc];
            break;
        case CACHETYPE_MAINTEN:
            _lbDesc.text = [NSString stringWithFormat:@"Maintenance:%@",dataCache.strDesc];
            break;
        case CACHETYPE_BVISITING:
            _lbDesc.text = [NSString stringWithFormat:@"BVisiting:%@",dataCache.strDesc];
            break;
        case CACHETYPE_ELEARNINGEXAM:
            _lbDesc.text = [NSString stringWithFormat:@"Elearning Exam:%@",dataCache.strDesc];
            break;
    }
   
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    _lbDate.text = [dateformatter stringFromDate:dataCache.date];
}

-(IBAction)OnSelectUpload:(id)sender
{
    [self.delegate OnUploadCacheData:_dataCache];
}
@end
