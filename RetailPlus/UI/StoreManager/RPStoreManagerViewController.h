//
//  RPStoreManagerViewController.h
//  RetailPlus
//
//  Created by lin dong on 13-9-3.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPSystemTaskBaseViewController.h"
#import "RPStoreManagerView.h"

@protocol RPStoreManagerViewControllerDelegate <NSObject>
     -(void)OnSelectStoreManagerStore:(StoreDetailInfo *)store;
@end


@interface RPStoreManagerViewController : RPSystemTaskBaseViewController<RPStoreManagerViewDelegate>
{
    IBOutlet RPStoreManagerView          * _viewlist;
    IBOutlet UIScrollView                * _svFrame;
    
    BOOL                                   _bViewInited;
    IBOutlet UILabel                     * _lbTitle;
}

@property (nonatomic,assign) id<RPStoreManagerViewControllerDelegate> delegate;

-(void)ReloadData;
-(void)UpdateStore:(StoreDetailInfo *)store;
@end
