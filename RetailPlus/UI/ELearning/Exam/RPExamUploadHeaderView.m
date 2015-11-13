//
//  RPExamUploadHeaderView.m
//  RetailPlus
//
//  Created by zhanglinfeng on 14-7-24.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPExamUploadHeaderView.h"
extern NSBundle * g_bundleResorce;
@implementation RPExamUploadHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
-(void)awakeFromNib
{
    _btUpload.layer.cornerRadius=5;
    _lbUpload.text=NSLocalizedStringFromTableInBundle(@"UPLOAD ALL",@"RPString", g_bundleResorce,nil);
    
    _lbResuit.text=NSLocalizedStringFromTableInBundle(@"Test result to be uploaded",@"RPString", g_bundleResorce,nil);
}
- (IBAction)OnUpLoad:(id)sender
{
    [self.delegate OnUpLoadAll];
}

- (IBAction)OnExpan:(id)sender
{

    [self.delegate OnExpand];
}
@end
