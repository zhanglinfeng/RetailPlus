//
//  RPELCourseWareSearchCell.m
//  RetailPlus
//
//  Created by lin dong on 14-7-28.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPELCourseWareSearchCell.h"
#import "RPSDKELDefine.h"
#import "RPELWebCache.h"

@implementation RPELCourseWareSearchCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setDictResult:(NSDictionary *)dictResult
{
    _dictResult = dictResult;
    
    RPELCourseWare * ware = [dictResult objectForKey:@"CourseWare"];
    RPELCourse * course = [dictResult objectForKey:@"Course"];
    
    _lbCourseTitle.text = course.strName;
    _lbCourseWareTitle.text = ware.strName;
    _lbCourseWareNo.text = ware.strNo;
    
    if (ware.bRead)
        _ivRead.image = [UIImage imageNamed:@"icon_cw_read.png"];
    else
        _ivRead.image = [UIImage imageNamed:@"icon_cw_noread.png"];
    
    NSString * strRootPath = @"Course";
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * strDocumentDirectory = [paths objectAtIndex:0];
    NSString * strFileSavePath = [strDocumentDirectory stringByAppendingString:[NSString stringWithFormat:@"/%@/%@/",strRootPath,ware.strId]];
    
    NSString * str = [RPELWebCache GetCacheURL:ware.strDownloadUrl PathSave:strFileSavePath];
    if (str) {
        [_btnDownLoad setImage:[UIImage imageNamed:@"icon_downloaded.png"] forState:UIControlStateNormal];
        [_btnDownLoad setSelected:YES];
    }
    else
    {
        [_btnDownLoad setImage:[UIImage imageNamed:@"button_download.png"] forState:UIControlStateNormal];
        [_btnDownLoad setSelected:NO];
    }
}

-(IBAction)OnDownload:(id)sender
{
    BOOL bOpen = NO;
    if (_btnDownLoad.isSelected) bOpen = YES;
    
    [self.delegate DoDownloadOrOpenCourseWare:[_dictResult objectForKey:@"CourseWare"] InCourse:[_dictResult objectForKey:@"Course"] Open:bOpen];
}
@end
