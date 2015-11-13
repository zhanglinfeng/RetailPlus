//
//  RPStoreCardView.h
//  RetailPlus
//
//  Created by lin dong on 13-10-12.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIMarqueeLabel.h"

@protocol RPStoreCardViewDelegate <NSObject>
    -(void)OnSelectStore;
@end

@interface RPStoreCardView : UIView
{
    IBOutlet UIButton       * _btnStoreName;
    IBOutlet UIMarqueeLabel * _lbStoreName;
    IBOutlet UIButton       * _btnHide;
    IBOutlet UIScrollView   * _svFrame;
    IBOutlet UIView         * _viewWeather;
    IBOutlet UIView         * _viewTable1;
    IBOutlet UIView         * _viewTable2;
    IBOutlet UIView         * _viewTable3;
    
    IBOutlet UIImageView    * _ivImage;
    IBOutlet UIImageView    * _ivStoreInfoComplete;
    IBOutlet UIImageView    * _ivStoreUser;
    
    IBOutlet UILabel        * _lbPhone;
    IBOutlet UILabel        * _lbLocate;
    IBOutlet UILabel        * _lbAddress;
    IBOutlet UILabel        * _lbPostCode;
    IBOutlet UILabel        * _lbFax;
    IBOutlet UILabel        * _lbEmail;
    IBOutlet UILabel        * _lbType;
    IBOutlet UILabel        * _lbOrganization;
    IBOutlet UILabel        * _lbDealer;
    IBOutlet UILabel        * _lbShopHour;
    IBOutlet UILabel        * _lbArea;
    IBOutlet UILabel        * _lbLastRecorated;
    
    
    IBOutlet UIImageView *_ivWeather1;
    IBOutlet UIImageView *_ivWeather2;
    IBOutlet UIImageView *_ivWeather3;
    IBOutlet UILabel *_lbDate1;
    IBOutlet UILabel *_lbDate2;
    IBOutlet UILabel *_lbDate3;
    IBOutlet UILabel *_lbTemperature1;
    IBOutlet UILabel *_lbTemperature2;
    IBOutlet UILabel *_lbTemperature3;
    
    
    
    BOOL        _bHide;
    NSInteger   _nHeight;
}

@property (nonatomic,retain) StoreDetailInfo * store;
@property (nonatomic,assign) id<RPStoreCardViewDelegate> delegate;

-(IBAction)OnSelectStore:(id)sender;
-(IBAction)OnHide:(id)sender;

-(void)Hide:(BOOL)bHide;
@end
