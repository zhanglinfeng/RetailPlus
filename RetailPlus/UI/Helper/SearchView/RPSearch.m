//
//  RPSearch.m
//  RetailPlus
//
//  Created by lin dong on 14-9-18.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPSearch.h"


extern NSBundle * g_bundleResorce;

@implementation RPSearch

-(id)InitWithParent:(UIView *)view Delegate:(id)delegate
{
    id ret = [super init];
    if (ret)
    {
        _delegate = delegate;
        
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"RPSearchView" owner:self options:nil];
        _viewSearch = [array objectAtIndex:0];
        
        _viewSearch.delegate = self;
        _viewSearch.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height);
        [view addSubview:_viewSearch];
    }
    return ret;
}

-(NSString *)GetSearchString
{
    return _viewSearch.tfSearch.text;
}

-(void)SetSearchString:(NSString *)strString
{
    [_viewSearch SetSearchString:strString];
}

-(void)OnSearchChange:(NSString *)strSearch
{
    [_delegate OnSearchChange:strSearch];
}
@end
