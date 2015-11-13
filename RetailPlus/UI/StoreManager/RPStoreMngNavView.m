//
//  RPStoreMngNavView.m
//  RetailPlus
//
//  Created by lin dong on 14-9-15.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPStoreMngNavView.h"

@implementation RPStoreMngNavView

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
}

-(void)setArrayDomainTree:(NSArray *)arrayDomainTree
{
    _arrayDomainTree = arrayDomainTree;
    [self UpdateUI];
}

-(void)setDomainCurrent:(DomainInfo *)domainCurrent
{
    _domainCurrent = domainCurrent;
    [self UpdateUI];
}

-(void)AddParentDomain:(DomainInfo *)domain
{
    if (!domain.viewDomainNav) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"RPStoreMngNavBtn" owner:self options:nil];
        RPStoreMngNavBtn * navBtn = [array objectAtIndex:0];
        navBtn.info = domain;
        navBtn.delegate = self;
        domain.viewDomainNav = navBtn;
    }
    [_arrayDomainBtn insertObject:domain atIndex:0];
    
    if (domain.strParentDomainID && domain.strParentDomainID.length > 0) {
        for (DomainInfo * info in _arrayDomainTree) {
            if ([info.strDomainID isEqualToString:domain.strParentDomainID]) {
                [self AddParentDomain:info];
                break;
            }
        }
    }
}

-(void)UpdateUI
{
    if (_arrayDomainBtn == nil) {
        _arrayDomainBtn = [[NSMutableArray alloc] init];
    }
    
    for (DomainInfo * domain in _arrayDomainBtn) {
        if (domain.viewDomainNav)
            [domain.viewDomainNav removeFromSuperview];
    }
    [_arrayDomainBtn removeAllObjects];
    
    if (_domainCurrent && _arrayDomainTree) {
        [self AddParentDomain:_domainCurrent];
        [self UpdateContent];
    }
}

-(void)UpdateContent
{
    UIView * viewUp = nil;
    NSInteger nBeginWidth = 0;
    
    BOOL bBeyound = NO;
    
    [UIView beginAnimations:nil context:nil];
    
    for (DomainInfo * domain in _arrayDomainBtn) {
        domain.viewDomainNav.frame = CGRectMake(nBeginWidth, 0, domain.viewDomainNav.frame.size.width, domain.viewDomainNav.frame.size.height);
        nBeginWidth += domain.viewDomainNav.frame.size.width;
    
        if (nBeginWidth > _viewNavFrame.frame.size.width) {
            bBeyound = YES;
        }
        
        if (!viewUp)
        {
            [_viewNavFrame addSubview:domain.viewDomainNav];
            viewUp = domain.viewDomainNav;
        }
        else
        {
            [_viewNavFrame insertSubview:domain.viewDomainNav belowSubview:viewUp];
            viewUp = domain.viewDomainNav;
        }
    }
    
    if (bBeyound) {
        DomainInfo * domain = [_arrayDomainBtn objectAtIndex:_arrayDomainBtn.count - 1];
        domain.viewDomainNav.frame = CGRectMake(_viewNavFrame.frame.size.width - domain.viewDomainNav.frame.size.width,0 , domain.viewDomainNav.frame.size.width , domain.viewDomainNav.frame.size.height);
        
        
        float nWidthPercent = 0;
        DomainInfo * domainZero = [_arrayDomainBtn objectAtIndex:0];
        if (_arrayDomainBtn.count > 2)
        {
            nWidthPercent = (_viewNavFrame.frame.size.width - domain.viewDomainNav.frame.size.width - domainZero.viewDomainNav.frame.size.width) / (_arrayDomainBtn.count - 2);
        }
        
        NSInteger nLast = 0;
        
        for (NSInteger n = 1; n < (_arrayDomainBtn.count - 1); n ++) {
            DomainInfo * domain = [_arrayDomainBtn objectAtIndex:n];
            
            if (n == 1) {
                nLast = domainZero.viewDomainNav.frame.size.width + nWidthPercent;
            }
            
            
            if (nWidthPercent <= 0)
                [domain.viewDomainNav removeFromSuperview];
            else
            {
                domain.viewDomainNav.frame = CGRectMake(nLast - domain.viewDomainNav.frame.size.width, 0, domain.viewDomainNav.frame.size.width, domain.viewDomainNav.frame.size.height);
                nLast += nWidthPercent;
            }
        }
    }
    [UIView commitAnimations];
}

-(IBAction)OnBackDomain:(id)sender
{
    if (_arrayDomainBtn.count > 1) {
        _domainCurrent = [_arrayDomainBtn objectAtIndex:_arrayDomainBtn.count - 2];
        [self.delegate OnDomainChange:_domainCurrent];
        [self UpdateUI];
    }
}

-(void)OnDomain:(DomainInfo *)domain
{
    _domainCurrent = domain;
    [self.delegate OnDomainChange:_domainCurrent];
    [self UpdateUI];
}

@end
