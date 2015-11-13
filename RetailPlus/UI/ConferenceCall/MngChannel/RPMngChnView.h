//
//  RPMngChnView.h
//  RetailPlus
//
//  Created by lin dong on 14-6-16.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPConfDefine.h"

#define MAX_CONFACCOUNTCOUNT            9

@protocol RPMngChnViewDelegate <NSObject>
    -(void)OnLogin:(NSInteger)nIndex;
    -(void)OnShowChnDetail:(NSInteger)nIndex;
    -(void)LoginEnd:(NSInteger)nIndex Success:(BOOL)bSuccess ChangeChecked:(BOOL)bChangeCheck;
    -(void)DeleteEnd:(NSInteger)nIndex;
@end

@interface RPMngChnView : UIView<RPMngChnViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    IBOutlet UIView             * _viewFrame;
    IBOutlet UITableView        * _tbAccount;
    IBOutlet UIView             * _viewDetail;
    
    NSMutableArray              * _arrayChn;
    BOOL                        _bShowDetail;
}

-(BOOL)OnBack;
-(void)LoadSavedAccount;

@end
