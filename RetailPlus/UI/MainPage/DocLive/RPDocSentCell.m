//
//  RPDocSentCell.m
//  RetailPlus
//
//  Created by zwhe on 13-12-4.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import "RPDocSentCell.h"

@implementation RPDocSentCell

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
    
//    NSString *s=[[NSString alloc]initWithFormat:@"%@:%@",doc.strDocType,doc.dataUnSent.strDesc];
    _lbDesc.text=doc.strDocType;
    _lbStoreName.text=doc.dataUnSent.strDesc;
    _lbAuthor.text=doc.strAuthor;
    _lbDate.text=doc.strCreateTime;
    if (doc.isUnSentUploading) {
//        NSString *path = [[NSBundle mainBundle] pathForResource:@"icon_upld_uploading@2x" ofType:@"gif"];
//        NSData *gifData = [NSData dataWithContentsOfFile:path];
//        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 42, 52)];
//        _webView.backgroundColor = [UIColor clearColor];
//        _webView.scalesPageToFit = YES;
//        [_webView loadData:gifData MIMEType:@"image/gif" textEncodingName:nil baseURL:nil];
//        [_ivType removeFromSuperview];
//        [self addSubview:_webView];
        UIImageView *gifImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 42, 52)];
        gifImageView.backgroundColor=[UIColor clearColor];
        NSArray *gifArray = [NSArray arrayWithObjects:[UIImage imageNamed:@"icon_upld_uploading1@2x"],
                             [UIImage imageNamed:@"icon_upld_uploading2@2x"],
                             [UIImage imageNamed:@"icon_upld_uploading3@2x"],
                             [UIImage imageNamed:@"icon_upld_uploading4@2x"],
                             [UIImage imageNamed:@"icon_upld_uploading5@2x"],
                             [UIImage imageNamed:@"icon_upld_uploading6@2x"],
                             [UIImage imageNamed:@"icon_upld_uploading7@2x"],nil];
        gifImageView.animationImages = gifArray; //动画图片数组
        gifImageView.animationDuration = 1.5; //执行一次完整动画所需的时长
        gifImageView.animationRepeatCount = 999;  //动画重复次数
        [gifImageView startAnimating];
        [_ivType removeFromSuperview];
        [self addSubview:gifImageView];


    }
    else
    {
        [_gifImageView removeFromSuperview];
        [self addSubview:_ivType];
        [_ivType setImage:[UIImage imageNamed:@"icon_upld_pause.png"]];
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


}
//-(void)setBLast:(BOOL)bLast
//{
//    _bLast=bLast;
//}

- (IBAction)delectClick:(id)sender
{
    [self.delegate OnDeleteSentDoc:_doc];
}
-(void)ShowExpand:(BOOL)bExpand
{
    _ivIconRec.hidden = bExpand?NO:YES;
    _viewLine.hidden=bExpand?YES:NO;
}
@end
