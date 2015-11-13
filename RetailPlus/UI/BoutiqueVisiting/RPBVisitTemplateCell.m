//
//  RPBVisitTemplateCell.m
//  RetailPlus
//
//  Created by zhanglinfeng on 14-2-26.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPBVisitTemplateCell.h"

extern NSBundle * g_bundleResorce;

@implementation RPBVisitTemplateCell

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
-(void)setVisitTemplate:(BVisitTemplate *)visitTemplate
{
    _visitTemplate=visitTemplate;
    _name.text=_visitTemplate.strTemplateName;
    _count.text=[NSString stringWithFormat:@"%d %@",_visitTemplate.nCatagoryCount,NSLocalizedStringFromTableInBundle(@"categories",@"RPString", g_bundleResorce,nil)];
}
@end
