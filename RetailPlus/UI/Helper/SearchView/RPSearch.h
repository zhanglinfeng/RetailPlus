//
//  RPSearch.h
//  RetailPlus
//
//  Created by lin dong on 14-9-18.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RPSearchView.h"

@protocol RPSearchDelegate <NSObject>
    -(void)OnSearchChange:(NSString *)strSearch;
@end

@interface RPSearch : NSObject<RPSearchViewDelegate>
{
    id<RPSearchDelegate>        _delegate;
    RPSearchView                * _viewSearch;
}

-(id)InitWithParent:(UIView *)view Delegate:(id)delegate;
-(NSString *)GetSearchString;
-(void)SetSearchString:(NSString *)strString;

@end
