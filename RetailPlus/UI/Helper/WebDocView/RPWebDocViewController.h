//
//  RPWebDocViewController.h
//  RetailPlus
//
//  Created by lin dong on 13-12-10.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
@protocol RPWebDocViewControllerDelegate<NSObject>
-(void)backDoc;
@end
@interface RPWebDocViewController : UIViewController<UIGestureRecognizerDelegate>
{
    IBOutlet UIView         * _viewBorder;
    IBOutlet UIView         * _viewToolbar;
    NSString                * _filename;
}

@property (nonatomic)BOOL                       bLocalFile;
@property (nonatomic,assign)id<RPWebDocViewControllerDelegate>delegate;
@property (nonatomic,retain) NSString           * strUrl;
@property (nonatomic,retain) NSString           * strTitle;
@property (nonatomic,retain) ASIDownloadCache   * cache;
@property (nonatomic,retain) ASIHTTPRequest     * httpRequest;
@property (nonatomic,retain) IBOutlet UIWebView * webview;
-(IBAction)OnBack:(id)sender;

@end
