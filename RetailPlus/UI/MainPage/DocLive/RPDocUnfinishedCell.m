//
//  RPDocUnfinishedCell.m
//  RetailPlus
//
//  Created by zwhe on 13-12-4.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import "RPDocUnfinishedCell.h"

@implementation RPDocUnfinishedCell

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

-(void)ShowExpand:(BOOL)bExpand
{
    _ivIconRec.hidden = bExpand?NO:YES;
    _viewLine.hidden=bExpand?YES:NO;
}

-(void)setDoc:(Document *)doc
{
    
    _doc = doc;
    
//    NSString *desc=[[NSString alloc]initWithFormat:@"%@:%@",doc.strDocType,doc.strUnfinishDesc];
    _lbDesc.text=doc.strDocType;
    _lbStoreName.text=doc.strUnfinishDesc;
    _lbAuthor.text=doc.strAuthor;
    _lbDate.text=doc.strCreateTime;
    
    
    switch (doc.rankAuthor) {
        case Rank_Manager:
            _lbAuthor.textColor = [UIColor colorWithRed:150.0f/255 green:70.0f/255 blue:150.0f/255 alpha:1];
            break;
        case Rank_StoreManager:
            _lbAuthor.textColor = [UIColor colorWithRed:230.0f/255 green:110.0f/255 blue:10.0f/255 alpha:1];
            break;
        case Rank_Assistant:
            _lbAuthor.textColor = [UIColor colorWithRed:50.0f/255 green:105.0f/255 blue:175.0f/255 alpha:1];
            break;
        case Rank_Vendor:
            _lbAuthor.textColor = [UIColor colorWithRed:150.0f/255 green:170.0f/255 blue:20.0f/255 alpha:1];
            break;
        default:
            break;
    }

    
}

- (IBAction)informationClick:(id)sender
{
    
}
- (IBAction)forwordClick:(id)sender
{
    
}
- (IBAction)editClick:(id)sender
{
    
}
- (IBAction)delectClick:(id)sender
{
    [self.docCellDelegate OnDeleteDoc:_doc];
}
@end
