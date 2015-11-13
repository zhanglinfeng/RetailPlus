//
//  RPCountViewController.m
//  RetailPlus
//
//  Created by zhanglinfeng on 14-7-8.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPCountViewController.h"
#import "RPCountCell.h"
#import <AudioToolbox/AudioToolbox.h>
#import "SVProgressHUD.h"

extern NSBundle * g_bundleResorce;
@interface RPCountViewController ()

@end

@implementation RPCountViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _baseNumber=1;
    _arraydelete=[[NSMutableArray alloc]init];
    _arrayCurrent=[[NSMutableArray alloc]init];
    _arrayAdd=[[NSMutableArray alloc]init];
    _arrayDelAdd=[[NSMutableArray alloc]init];
    _btBase.layer.cornerRadius=5;
    _btCount.userInteractionEnabled=NO;
    _btMenu.userInteractionEnabled=NO;
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(OnTapped:)];
    [self.view addGestureRecognizer:tap];
    tap.cancelsTouchesInView=YES;//为yes只响应优先级最高的事件，Button高于手势，textfield高于手势，textview高于手势，手势高于tableview。为no同时都响应，默认为yes
    
    
    [UIApplication sharedApplication].statusBarHidden=YES;
    
//    //初始化音乐路径
//    NSString *path=[[NSBundle mainBundle]pathForResource:musicName ofType:@"mp3"];
//    //转换为NSurl格式
//    NSURL *url=[NSURL fileURLWithPath:path];
//    //初始化avaudioPlayer
//    _player=[[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
//    _player.delegate=self;
//    //准备播放
//    [_player prepareToPlay];
    
    
    
    [self initSound];
    
    
    //字体数组
    _fontArrays = [[NSArray alloc] initWithArray:[UIFont familyNames]];
    
    [_lbHistory setFont:[UIFont fontWithName:@"LcdD" size:13]];
    [_btBase.titleLabel setFont:[UIFont fontWithName:@"LcdD" size:18]];
    [_lbCount setFont:[UIFont fontWithName:@"LcdD" size:70]];
    
    _btNext.alpha=0.4;
    _btLast.alpha=0.4;
    
    _tbHistory.showsVerticalScrollIndicator = NO;
    _ivMax.frame=CGRectMake(_ivMax.frame.origin.x, _lbCount.frame.origin.y+78, _ivMax.frame.size.width, _ivMax.frame.size.height);
    
    
    
//    CGRect szScreen = [[UIScreen mainScreen] bounds];
//    self.view.frame=szScreen;
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
//    {
//        _viewFrame.frame=CGRectMake(0, 20, _viewFrame.frame.size.width, _viewFrame.frame.size.height-20);
//    }
    
    _lbCount.text=[NSString stringWithFormat:@"%i",_sum];
    _btViberate.layer.cornerRadius=4;
    _btBeep.layer.cornerRadius=4;
    _button1.layer.cornerRadius=4;
    _button2.layer.cornerRadius=4;
    _button3.layer.cornerRadius=4;
    _button4.layer.cornerRadius=4;
    _button5.layer.cornerRadius=4;
    _button6.layer.cornerRadius=4;
    _button7.layer.cornerRadius=4;
    _button8.layer.cornerRadius=4;
}

-(void)initSound
{
    // 要播放的音频文件地址
    NSString *urlPath = [[NSBundle mainBundle] pathForResource:@"25821" ofType:@"wav"];
    
    NSURL *url = [NSURL fileURLWithPath:urlPath];
    
    // 声明需要播放的音频文件ID[unsigned long]
    
    // 创建系统声音，同时返回一个ID
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)(url), &ID);
    
    
    NSString *urlPathWarn = [[NSBundle mainBundle] pathForResource:@"909" ofType:@"wav"];
    NSURL *urlWarn = [NSURL fileURLWithPath:urlPathWarn];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)(urlWarn), &ID_warn);
}

-(void)OnTapped:(UITapGestureRecognizer *)tap
{
    [self.view endEditing:YES];
    _viewNumber.hidden=YES;
    _viewSetting.hidden=YES;
    _btBase.selected=NO;
    _btSet.selected=NO;
    _btCount.userInteractionEnabled=YES;
    _btMenu.userInteractionEnabled=YES;
    _tfBase.hidden=YES;
}
-(void)setSum:(NSInteger)sum
{
    _sum=sum;
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)OnBack:(id)sender
{
    [self.delegate OnEndCount:_sum];
    [UIApplication sharedApplication].statusBarHidden=NO;
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 18;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _arrayCurrent.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RPCountCell *cell=[tableView dequeueReusableCellWithIdentifier:@"RPCountCell"];
    if (cell==nil)
    {
        NSArray *arrayNib=[[NSBundle mainBundle]loadNibNamed:@"RPCountCell" owner:self options:nil];
        cell=[arrayNib objectAtIndex:0];
    }
    cell.lbAdd.text=[NSString stringWithFormat:@"+%i",[[_arrayAdd objectAtIndex:_arrayCurrent.count-indexPath.row-1] intValue]];
    cell.lbSum.text=[NSString stringWithFormat:@"%i",[[_arrayCurrent objectAtIndex:_arrayCurrent.count-indexPath.row-1] intValue]];
    [cell.lbAdd setFont:[UIFont fontWithName:@"LcdD" size:12]];
    [cell.lbSum setFont:[UIFont fontWithName:@"LcdD" size:12]];
    return cell;
}
- (IBAction)OnSelectBaseNumber:(id)sender
{
//    if (_btMenu.selected)
//    {
        _btBase.selected=!_btBase.selected;
        if (_btBase.selected)
        {
            _viewNumber.hidden=NO;
            _btCount.userInteractionEnabled=NO;
            _btMenu.userInteractionEnabled=NO;
        }
        else
        {
            _viewNumber.hidden=YES;
            _tfBase.hidden=YES;
            _btCount.userInteractionEnabled=YES;
            _btMenu.userInteractionEnabled=YES;
        }
//    }
    
}

- (IBAction)OnShowMenu:(id)sender
{
    _btMenu.selected=!_btMenu.selected;//选中状态显示菜单
    if (_btMenu.selected)
    {
        _btBack.hidden=NO;
        _viewMenu.hidden=NO;
        _btBase.backgroundColor=[UIColor colorWithRed:0.0/255 green:172.0/255 blue:119.0/255 alpha:1];
        [_btBase setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _btBase.userInteractionEnabled=YES;
        
        UIImageView *gifImageView = [[UIImageView alloc] initWithFrame:_btMenu.frame];
        [self.view addSubview:gifImageView];
        gifImageView.backgroundColor=[UIColor clearColor];
        NSArray *gifArray = [NSArray arrayWithObjects:[UIImage imageNamed:@"button_on-off_4@2x.png"],
                             [UIImage imageNamed:@"button_on-off_3@2x.png"],
                             [UIImage imageNamed:@"button_on-off_2@2x.png"],
                             [UIImage imageNamed:@"button_on-off_1@2x.png"],nil];
        gifImageView.animationImages = gifArray; //动画图片数组
        gifImageView.animationDuration = 0.2; //执行一次完整动画所需的时长
        gifImageView.animationRepeatCount =1;  //动画重复次数
        [gifImageView startAnimating];
//        [gifImageView removeFromSuperview];
        
        
        
    }
    else
    {
        _btBack.hidden=YES;
        _viewMenu.hidden=YES;
        _btBase.backgroundColor=[UIColor clearColor];
        [_btBase setTitleColor:[UIColor colorWithRed:0.0/255 green:172.0/255 blue:119.0/255 alpha:1] forState:UIControlStateNormal];
        _btBase.userInteractionEnabled=NO;
        _btBase.selected=NO;
        _btSet.selected=NO;
        _viewNumber.hidden=YES;
        _viewSetting.hidden=YES;
        
        
        UIImageView *gifImageView = [[UIImageView alloc] initWithFrame:_btMenu.frame];
        [self.view addSubview:gifImageView];
        gifImageView.backgroundColor=[UIColor clearColor];
        NSArray *gifArray = [NSArray arrayWithObjects:[UIImage imageNamed:@"button_on-off_1@2x.png"],
                             [UIImage imageNamed:@"button_on-off_2@2x.png"],
                             [UIImage imageNamed:@"button_on-off_3@2x.png"],
                             [UIImage imageNamed:@"button_on-off_4@2x.png"],nil];
        gifImageView.animationImages = gifArray; //动画图片数组
        gifImageView.animationDuration = 0.2; //执行一次完整动画所需的时长
        gifImageView.animationRepeatCount =1;  //动画重复次数
        [gifImageView startAnimating];
//        [gifImageView removeFromSuperview];
    }
    
}

- (IBAction)OnCount:(id)sender
{
    
    _time=0;
    [_timer invalidate];
    _timer=nil;
    _timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(upDate) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop]addTimer:_timer forMode:NSRunLoopCommonModes];
    
    _btMenu.selected=YES;
    [self OnShowMenu:nil];//隐藏菜单
    
    _sum=_sum+_baseNumber;
    if (_sum>99999)
    {
        //震动是否开启
        if (_btViberate.selected)
        {
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        }
        //声音是否开启
        if (_btBeep.selected)
        {
            AudioServicesPlaySystemSound(ID_warn);
        }
        _sum=_sum-_baseNumber;
        _ivMax.hidden=NO;
        _lbCount.textColor=[UIColor colorWithRed:255.0/255 green:204.0/255 blue:0 alpha:1];
        
        return;
    }
    else
    {
        _lbCount.textColor=[UIColor colorWithRed:2.0/255 green:170.0/255 blue:117.0/255 alpha:1];
    }
    NSNumber *number=[NSNumber numberWithInt:_sum];
    [_arrayCurrent addObject:number];
    [_arrayAdd addObject:[NSNumber numberWithInt:_baseNumber]];
    [_arraydelete removeAllObjects];
    [_arrayDelAdd removeAllObjects];
    _lbCount.text=[NSString stringWithFormat:@"%i",_sum];
    [_tbHistory reloadData];
    _btLast.alpha=1;
    _btNext.alpha=0.4;
    
    //震动是否开启
    if (_btViberate.selected)
    {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    }
    //声音是否开启
    if (_btBeep.selected)
    {
        AudioServicesPlaySystemSound(ID);
    }
//    NSLog(@"Font name  = %@    %i", [_fontArrays objectAtIndex:_sum],_sum);
}
-(void)upDate
{
    _time++;
//    NSLog(@"%i",_time);
    if (_time==10)
    {
        [_timer invalidate];
        _timer=nil;
        _btMenu.selected=NO;
        [self OnShowMenu:nil];//显示菜单
    }
}
- (IBAction)OnAddOne:(id)sender
{
    _baseNumber=1;
    [_btBase setTitle:[NSString stringWithFormat:@"+%i",_baseNumber] forState:UIControlStateNormal];
    [_btBase setTitle:[NSString stringWithFormat:@"+%i",_baseNumber] forState:UIControlStateSelected];
    _btBase.selected=NO;
    _viewNumber.hidden=YES;
    _btCount.userInteractionEnabled=YES;
    _btMenu.userInteractionEnabled=YES;
}

- (IBAction)OnAdd10:(id)sender
{
    _baseNumber=10;
    [_btBase setTitle:[NSString stringWithFormat:@"+%i",_baseNumber] forState:UIControlStateNormal];
    [_btBase setTitle:[NSString stringWithFormat:@"+%i",_baseNumber] forState:UIControlStateSelected];
    _btBase.selected=NO;
    _viewNumber.hidden=YES;
    _btCount.userInteractionEnabled=YES;
    _btMenu.userInteractionEnabled=YES;
}

- (IBAction)OnAdd12:(id)sender
{
    _baseNumber=12;
    [_btBase setTitle:[NSString stringWithFormat:@"+%i",_baseNumber] forState:UIControlStateNormal];
    [_btBase setTitle:[NSString stringWithFormat:@"+%i",_baseNumber] forState:UIControlStateSelected];
    _btBase.selected=NO;
    _viewNumber.hidden=YES;
    _btCount.userInteractionEnabled=YES;
    _btMenu.userInteractionEnabled=YES;
}

- (IBAction)OnAdd100:(id)sender
{
    _baseNumber=100;
    [_btBase setTitle:[NSString stringWithFormat:@"+%i",_baseNumber] forState:UIControlStateNormal];
    [_btBase setTitle:[NSString stringWithFormat:@"+%i",_baseNumber] forState:UIControlStateSelected];
    _btBase.selected=NO;
    _viewNumber.hidden=YES;
    _btCount.userInteractionEnabled=YES;
    _btMenu.userInteractionEnabled=YES;
}

- (IBAction)OnTypeIn:(id)sender
{
    _tfBase.hidden=NO;
    _viewNumber.hidden=YES;
    [_tfBase becomeFirstResponder];
}

- (IBAction)OnMinus:(id)sender
{
    if (_baseNumber<=1)
    {
        return;
    }
    _baseNumber=_baseNumber-1;
    [_btBase setTitle:[NSString stringWithFormat:@"+%i",_baseNumber] forState:UIControlStateNormal];
    [_btBase setTitle:[NSString stringWithFormat:@"+%i",_baseNumber] forState:UIControlStateSelected];
}

- (IBAction)OnPlus:(id)sender
{
    _baseNumber=_baseNumber+1;
    [_btBase setTitle:[NSString stringWithFormat:@"+%i",_baseNumber] forState:UIControlStateNormal];
    [_btBase setTitle:[NSString stringWithFormat:@"+%i",_baseNumber] forState:UIControlStateSelected];
}

- (IBAction)OnAdd5:(id)sender
{
    _baseNumber=5;
    [_btBase setTitle:[NSString stringWithFormat:@"+%i",_baseNumber] forState:UIControlStateNormal];
    [_btBase setTitle:[NSString stringWithFormat:@"+%i",_baseNumber] forState:UIControlStateSelected];
    _btBase.selected=NO;
    _viewNumber.hidden=YES;
    _btCount.userInteractionEnabled=YES;
    _btMenu.userInteractionEnabled=YES;
}

- (IBAction)OnLastStep:(id)sender
{
    _lbCount.textColor=[UIColor colorWithRed:2.0/255 green:170.0/255 blue:117.0/255 alpha:1];
    _ivMax.hidden=YES;
    [_btCount setTitleColor:[UIColor colorWithRed:2.0/255 green:170.0/255 blue:117.0/255 alpha:1] forState:UIControlStateNormal];
    if (_arrayCurrent.count==0)
    {
        _btLast.alpha=0.4;
        return;
    }
    _btNext.alpha=1;
    [_arraydelete addObject:[_arrayCurrent objectAtIndex:_arrayCurrent.count-1]];
    [_arrayDelAdd addObject:[_arrayAdd objectAtIndex:_arrayAdd.count-1]];
    [_arrayCurrent removeLastObject];
    [_arrayAdd removeLastObject];
    if (_arrayCurrent.count>0)
    {
        _sum=[[_arrayCurrent objectAtIndex:_arrayCurrent.count-1] intValue];
        
    }
    else
    {
        _sum=0;
    }
    
    _lbCount.text=[NSString stringWithFormat:@"%i",_sum];
    [_tbHistory reloadData];
}

- (IBAction)OnNextStep:(id)sender
{
    if (_arraydelete.count==0)
    {
        if (_sum+_baseNumber>99999)
        {
            _ivMax.hidden=NO;
            _lbCount.textColor=[UIColor colorWithRed:255.0/255 green:204.0/255 blue:0 alpha:1];
        }
        _btNext.alpha=0.4;
        return;
    }
    _btLast.alpha=1;
    [_arrayCurrent addObject:[_arraydelete objectAtIndex:_arraydelete.count-1]];
    [_arrayAdd addObject:[_arrayDelAdd objectAtIndex:_arrayDelAdd.count-1]];
    [_arraydelete removeLastObject];
    [_arrayDelAdd removeLastObject];
    _sum=[[_arrayCurrent objectAtIndex:_arrayCurrent.count-1] intValue];
    _lbCount.text=[NSString stringWithFormat:@"%i",_sum];
    //当向前撤销到最后一步，判断点数是否达到上限变黄色
   
    
    [_tbHistory reloadData];
}

- (IBAction)OnFresh:(id)sender
{
    _ivMax.hidden=YES;
    _lbCount.textColor=[UIColor colorWithRed:2.0/255 green:170.0/255 blue:117.0/255 alpha:1];
    _sum=0;
    [_arrayCurrent removeAllObjects];
    [_arraydelete removeAllObjects];
    _lbCount.text=[NSString stringWithFormat:@"%i",_sum];
    [_tbHistory reloadData];
}

- (IBAction)OnSet:(id)sender
{
    _btSet.selected=!_btSet.selected;
    if (_btSet.selected)
    {
        _viewSetting.hidden=NO;
        _btCount.userInteractionEnabled=NO;
        _btMenu.userInteractionEnabled=NO;
    }
    else
    {
        _viewSetting.hidden=YES;
        _btCount.userInteractionEnabled=YES;
        _btMenu.userInteractionEnabled=YES;
    }
}

- (IBAction)OnViberate:(id)sender
{
    _btViberate.selected=!_btViberate.selected;
    if (_btViberate.selected)
    {
        _btViberate.backgroundColor=[UIColor colorWithRed:225.0/255 green:130.0/255 blue:0.0/255 alpha:1];
        _lbViberate.textColor=[UIColor whiteColor];
    }
    else
    {
        _btViberate.backgroundColor=[UIColor colorWithWhite:0.7 alpha:1];
        _lbViberate.textColor=[UIColor colorWithWhite:0.8 alpha:1];
    }
}

- (IBAction)OnBeep:(id)sender
{
    _btBeep.selected=!_btBeep.selected;
    if (_btBeep.selected)
    {
        _btBeep.backgroundColor=[UIColor colorWithRed:225.0/255 green:130.0/255 blue:0.0/255 alpha:1];
        _lbBeep.textColor=[UIColor whiteColor];
    }
    else
    {
        _btBeep.backgroundColor=[UIColor colorWithWhite:0.7 alpha:1];
        _lbBeep.textColor=[UIColor colorWithWhite:0.8 alpha:1];
    }
}

- (IBAction)OnScreen:(id)sender
{
    
}

- (IBAction)OnVolume:(id)sender
{
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (_tfBase.text.intValue==0)
    {
        [SVProgressHUD showErrorWithStatus:NSLocalizedStringFromTableInBundle(@"Stepping number can't be 0",@"RPString", g_bundleResorce,nil)];
    }
    else if (_tfBase.text.intValue>999)
    {
        [SVProgressHUD showErrorWithStatus:NSLocalizedStringFromTableInBundle(@"Stepping number no more than 999",@"RPString", g_bundleResorce,nil)];
    }
    else
    {
        _baseNumber=_tfBase.text.intValue;
        [_btBase setTitle:[NSString stringWithFormat:@"+%i",_baseNumber] forState:UIControlStateNormal];
        [_btBase setTitle:[NSString stringWithFormat:@"+%i",_baseNumber] forState:UIControlStateSelected];
        _viewNumber.hidden=YES;
        _tfBase.hidden=YES;
        _btCount.userInteractionEnabled=YES;
        _btMenu.userInteractionEnabled=YES;
    }
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(BOOL)shouldAutorotate
{
    return NO;
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}
@end
