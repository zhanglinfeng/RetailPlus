//
//  RPCustomerListView.h
//  RetailPlus
//
//  Created by zhanglinfeng on 14-3-12.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol RPCustomerSelectDelegate <NSObject>
-(void)OnSelectedCustomer:(Customer *)customer;
@end
@interface RPCustomerListView : UIView<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    IBOutlet UIView         * _viewFrame;
    IBOutlet UIView         * _viewSearch;
    IBOutlet UITableView    * _tbCustomer;
    IBOutlet UITextField    * _tfSearch;
    
    NSMutableArray          *  _arrayCustomer;
    NSMutableArray          *  _arrayCustomerShow;
}
@property (nonatomic) SituationType sitType;
@property (nonatomic) BOOL bSelfOnly;

@property(nonatomic,assign)id<RPCustomerSelectDelegate>delegate;
-(void)reloadCustomer;
-(IBAction)OnDeleteSearch:(id)sender;
-(void)dismiss;
@end
