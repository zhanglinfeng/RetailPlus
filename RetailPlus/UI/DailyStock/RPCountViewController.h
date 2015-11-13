//
//  RPCountViewController.h
//  RetailPlus
//
//  Created by zhanglinfeng on 14-7-8.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@protocol RPCountViewControllerDelegate <NSObject>
-(void)OnEndCount:(int)count;
@end
@interface RPCountViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,AVAudioPlayerDelegate>
{
    IBOutlet UIView *_viewNumber;
    IBOutlet UIView *_viewMenu;
    IBOutlet UIView *_viewSetting;
    IBOutlet UIButton *_btBack;
    IBOutlet UIButton *_btBase;
    IBOutlet UITextField *_tfBase;
    IBOutlet UIButton *_btMenu;
    IBOutlet UIButton *_btSet;
    IBOutlet UIButton *_btCount;
    IBOutlet UITableView *_tbHistory;
    IBOutlet UIButton *_btLast;
    IBOutlet UIButton *_btNext;
    
    NSInteger _baseNumber;
    NSMutableArray *_arraydelete;//存放撤销掉的总数
    NSMutableArray *_arrayCurrent;//存放当前显示的总数
    NSMutableArray *_arrayAdd;//存放当前显示的增量
    NSMutableArray *_arrayDelAdd;//存放撤销掉得增量
    
    NSTimer *_timer;
    int _time;
    
    AVAudioRecorder *_recoder;
    AVAudioPlayer *_player;
    
    
    IBOutlet UIButton *_btViberate;
    IBOutlet UIButton *_btBeep;
    IBOutlet UIButton *_btScreen;
    IBOutlet UIButton *_btVolume;
    IBOutlet UILabel *_lbViberate;
    IBOutlet UILabel *_lbBeep;
    IBOutlet UILabel *_lbScreen;
    IBOutlet UILabel *_lbVolume;
    
    NSArray * _fontArrays;
    IBOutlet UILabel *_lbHistory;
    
    SystemSoundID ID;
    SystemSoundID ID_warn;
    
    IBOutlet UIImageView *_ivMax;
    IBOutlet UILabel *_lbCount;
    
    IBOutlet UIButton *_button1;
    IBOutlet UIButton *_button2;
    IBOutlet UIButton *_button3;
    IBOutlet UIButton *_button4;
    IBOutlet UIButton *_button5;
    IBOutlet UIButton *_button6;
    IBOutlet UIButton *_button7;
    IBOutlet UIButton *_button8;
}
@property(nonatomic,weak)id<RPCountViewControllerDelegate>delegate;
@property(nonatomic,assign)NSInteger sum;
- (IBAction)OnBack:(id)sender;
- (IBAction)OnSelectBaseNumber:(id)sender;
- (IBAction)OnShowMenu:(id)sender;
- (IBAction)OnCount:(id)sender;
- (IBAction)OnAddOne:(id)sender;
- (IBAction)OnAdd10:(id)sender;
- (IBAction)OnAdd12:(id)sender;
- (IBAction)OnAdd100:(id)sender;
- (IBAction)OnTypeIn:(id)sender;
- (IBAction)OnMinus:(id)sender;
- (IBAction)OnPlus:(id)sender;
- (IBAction)OnAdd5:(id)sender;
- (IBAction)OnLastStep:(id)sender;
- (IBAction)OnNextStep:(id)sender;
- (IBAction)OnFresh:(id)sender;
- (IBAction)OnSet:(id)sender;
- (IBAction)OnViberate:(id)sender;
- (IBAction)OnBeep:(id)sender;
- (IBAction)OnScreen:(id)sender;
- (IBAction)OnVolume:(id)sender;

@end
