//
//  RPLanguageViewController.h
//  RetailPlus
//
//  Created by lin dong on 13-11-6.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPTaskBaseViewController.h"

typedef enum
{
    LangType_Auto = 0,
    LangType_English,
    LangType_Hans
}LangType;

@protocol RPLanguageViewControllerDelegate <NSObject>
    -(void)OnChgLangEnd:(LangType)type;
@end

@interface RPLanguageViewController : RPTaskBaseViewController<UITableViewDataSource,UITableViewDelegate>
{
    IBOutlet UIView             * _viewFrame;
    IBOutlet UITableView        * _tbLanguage;
}

@property (nonatomic,assign) id<RPLanguageViewControllerDelegate> delegate;

@property (nonatomic) LangType type;

@end
