//
//  RPSearchView.h
//  RetailPlus
//
//  Created by lin dong on 14-9-18.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RPSearchViewDelegate<NSObject>
    -(void)OnSearchChange:(NSString *)strSearch;
@end

@interface RPSearchView : UIView<UITextFieldDelegate>
{
    IBOutlet UIButton       * _btnSearch;
    IBOutlet UIButton       * _btnClear;
    IBOutlet UITextField    * _tfSearch;
    
    BOOL                    _bEditing;
    
}

-(void)SetSearchString:(NSString *)strString;

@property (nonatomic,assign) id<RPSearchViewDelegate> delegate;
@property (nonatomic,retain) IBOutlet UITextField * tfSearch;
@end
