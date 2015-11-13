//
//  RPLanguageCell.h
//  RetailPlus
//
//  Created by lin dong on 13-11-6.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RPLanguageCell : UITableViewCell
{
    IBOutlet UILabel * _lbLangDesc;
    IBOutlet UIButton * _btnLangSel;
}

-(void)SetLang:(NSString *)strLangDesc Selected:(BOOL)bSelected;

@end
