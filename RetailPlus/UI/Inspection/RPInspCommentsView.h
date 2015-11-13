//
//  RPInspCommentsView.h
//  RetailPlus
//
//  Created by lin dong on 13-12-31.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RPInspCommentsViewDelegate <NSObject>
-(void)OnAddCommentsEnd;
-(void)OnQuitComments;
@end

@interface RPInspCommentsView : UIView
{
    IBOutlet UILabel            * _lbMarkDesc;
    IBOutlet UIButton           * _btnMark1;
    IBOutlet UIButton           * _btnMark2;
    IBOutlet UIButton           * _btnMark3;
    IBOutlet UIButton           * _btnMark4;
    IBOutlet UIButton           * _btnMark5;
    IBOutlet UIView             * _viewFrame;
    IBOutlet UIView             * _viewMark;
    IBOutlet UIView             * _viewComments;
    IBOutlet UITextView         * _tvComments;
}

@property (nonatomic,assign) InspData                       * dataInsp;
@property (nonatomic,assign) id<RPInspCommentsViewDelegate> delegate;
@property (nonatomic,assign) StoreDetailInfo                * storeSelected;
-(IBAction)OnMark:(id)sender;
-(IBAction)OnCache:(id)sender;
- (IBAction)OnHelp:(id)sender;
-(BOOL)OnBack;
@end
