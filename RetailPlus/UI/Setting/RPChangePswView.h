//
//  RPChangePswView.h
//  RetailPlus
//
//  Created by lin dong on 13-10-14.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol RPChangePswViewDelegate <NSObject>
-(void)OnChangePswEnd;
@end

@interface RPChangePswView : UIView
{
    IBOutlet UIView         * _viewFrame;
    IBOutlet UIView         * _viewTable1;
    IBOutlet UIView         * _viewTable2;
    IBOutlet UITextField    * _tfOldPsw;
    IBOutlet UITextField    * _tfNewPsw;
    IBOutlet UITextField    * _tfNewPswRepeat;
}

@property (nonatomic,assign) id<RPChangePswViewDelegate> delegate;

-(void)clear;

-(IBAction)OnShowPsw:(id)sender;
-(IBAction)OnHidePsw:(id)sender;
-(IBAction)OnChangePsw:(id)sender;

@end
