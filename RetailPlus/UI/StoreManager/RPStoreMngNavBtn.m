//
//  RPStoreMngNavBtn.m
//  RetailPlus
//
//  Created by lin dong on 14-9-15.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPStoreMngNavBtn.h"

@implementation RPStoreMngNavBtn

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
-(void)setInfo:(DomainInfo *)info
{
    _lbDomainName.text = info.strDomainName;
    
    CGSize size = [info.strDomainName sizeWithFont:_lbDomainName.font constrainedToSize:CGSizeMake(MAXFLOAT, 30)];
    size.width += 5;
    
    _lbDomainName.frame = CGRectMake(_lbDomainName.frame.origin.x, _lbDomainName.frame.origin.y, size.width, _lbDomainName.frame.size.height);
    
    self.frame = CGRectMake(0, 0, _lbDomainName.frame.origin.x + size.width + _ivArrow.frame.size.width, self.frame.size.height);
    
    _info = info;
}

-(IBAction)OnDomain:(id)sender
{
    [self.delegate OnDomain:_info];
}
@end
