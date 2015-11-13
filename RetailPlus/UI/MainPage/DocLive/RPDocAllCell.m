//
//  RPDocAllCell.m
//  RetailPlus
//
//  Created by zwhe on 13-12-3.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import "RPDocAllCell.h"
extern NSBundle * g_bundleResorce;
@implementation RPDocAllCell

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

-(void)setDoc:(Document *)doc
{
   
    _doc = doc;

//    NSString *desc=[[NSString alloc]initWithFormat:@"%@:%@%@",doc.strDocType,doc.strStoreName,doc.strBrandName];
    _lbDesc.text= [NSString stringWithFormat:@"%@ %@",doc.strDocType,doc.strDescEx];
    NSString *s=_lbDesc.text;
    _lbDesc.text=[s stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (!doc.isFinish)
    {
        NSString *s=NSLocalizedStringFromTableInBundle(@"(Unfinished)",@"RPString", g_bundleResorce,nil);
        _lbDesc.text=[NSString stringWithFormat:@"%@%@",_lbDesc.text,s];
    }
    
    _lbStoreName.text=[NSString stringWithFormat:@"%@ %@",doc.strBrandName,doc.strStoreName];
    _lbAuthor.text=doc.strAuthor;
    _lbDate.text=doc.strCreateTime;
    [_lbStoreName Start];
    if (doc.isNew)
    {
        _ivImage.alpha=1;
    }
    else
    {
        _ivImage.alpha=0;
    }
    if (doc.isReceived)
    {
        [_ivReceived setHidden:NO];
    }
    else
    {
        [_ivReceived setHidden:YES];
    }
    if (doc.isSendBySelf)
    {
        [_ivTypeImage setImage:[UIImage imageNamed:@"icon_published doc.png"]];
    }
    else
    {
        [_ivTypeImage setImage:[UIImage imageNamed:@"icon_forwarded doc.png"]];
    }
    
    
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

//    if (_doc.strDocType isEqualToString:@"<#string#>") {
//        button_edit@2x
//    }
    if ([_doc.strDocType isEqualToString:@""]&&_doc.isEdit) {
        [_btEdit setBackgroundImage:[UIImage imageNamed:@"button_edit@2x.png"] forState:UIControlStateNormal];
        _btEdit.userInteractionEnabled=YES;
        _lbEdit.textColor=[UIColor lightGrayColor];
    }
    else
    {
        [_btEdit setBackgroundImage:[UIImage imageNamed:@"button_edit_na@2x.png"] forState:UIControlStateNormal];
        _btEdit.userInteractionEnabled=NO;
        _lbEdit.textColor=[UIColor darkGrayColor];
    }
}



//-(void)setBLast:(BOOL)bLast
//{
//
//}
- (IBAction)informationClick:(id)sender {
    
    [_docCellDelegate OnDocumentTask:_doc btTag:0];
}

- (IBAction)forwordClick:(id)sender {
    [_docCellDelegate OnDocumentTask:_doc btTag:1];
    
//    [[RPSDK defaultInstance] CheckAuthActionSta:@"MD0002" Success:^(id idResult) {
//        [_docCellDelegate OnDocumentTask:_doc btTag:1];
//    } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
//        
//    }];
}

- (IBAction)editClick:(id)sender {
    [_docCellDelegate OnDocumentTask:_doc btTag:2];
    
}

- (IBAction)delectClick:(id)sender {
    [_docCellDelegate OnDocumentTask:_doc btTag:3];
    
//    [[RPSDK defaultInstance] CheckAuthActionSta:@"MD0003" Success:^(id idResult) {
//       [_docCellDelegate OnDocumentTask:_doc btTag:3];
//    } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
//        
//    }];
}

-(void)ShowExpand:(BOOL)bExpand
{
    _ivIconRec.hidden = bExpand?NO:YES;
    _viewLine.hidden=bExpand?YES:NO;
}
@end
