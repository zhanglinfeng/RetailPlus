//
//  RPExamUploadCell.m
//  RetailPlus
//
//  Created by zhanglinfeng on 14-7-25.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPExamUploadCell.h"
#import "SVProgressHUD.h"
extern NSBundle * g_bundleResorce;
@implementation RPExamUploadCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setPaper:(RPELPaper *)paper
{
    
}
-(void)setDoc:(Document *)doc
{
    _doc=doc;
     NSArray *array=[doc.strDescEx componentsSeparatedByString:@","];
    _lbCode.text=[array objectAtIndex:0];
    _lbTitel.text=[array objectAtIndex:1];
    _lbTime.text=_doc.strCreateTime;
}
- (IBAction)OnUpload:(id)sender
{
    [[RPSDK defaultInstance]SubmitCacheData:_doc.dataUnSent Success:^(id idResult) {
        [SVProgressHUD showSuccessWithStatus:NSLocalizedStringFromTableInBundle(@"Submit Success",@"RPString", g_bundleResorce,nil)];
        [self.delegate endUpload:_doc];
    } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
        [SVProgressHUD showErrorWithStatus:NSLocalizedStringFromTableInBundle(@"failure",@"RPString", g_bundleResorce,nil)];
    }];
}
@end
