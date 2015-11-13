//
//  RPSettingViewController.m
//  RetailPlus
//
//  Created by lin dong on 13-9-18.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

extern NSString * g_strLangCode;

#import "RPSettingViewController.h"
#import "UIImageView+WebCache.h"
#import "RPBlockUIAlertView.h"
extern NSBundle * g_bundleResorce;
@interface RPSettingViewController ()

@end

@implementation RPSettingViewController

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
    _viewFrame.layer.cornerRadius = 8;
    _viewFrame.layer.shadowOffset = CGSizeMake(0, 1);
    _viewFrame.layer.shadowRadius =3.0;
    _viewFrame.layer.shadowColor =[UIColor blackColor].CGColor;
    _viewFrame.layer.shadowOpacity =0.5;
    
    _ivPic.layer.cornerRadius = 8;
    _lbJobTitle.layer.cornerRadius = 3;
    [self Reload];
    
    [self setUpForDismissKeyboard];
}

- (void)setUpForDismissKeyboard {
    UITapGestureRecognizer *singleTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(tapAnywhereToDismissKeyboard:)];
    [self.view addGestureRecognizer:singleTapGR];
}

- (void)tapAnywhereToDismissKeyboard:(UIGestureRecognizer *)gestureRecognizer {
    //此method会将self.view里所有的subview的first responder都resign掉
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)OnLogout:(id)sender
{
    [self.delegate OnLogout];
}

-(IBAction)OnAccountSetup:(id)sender
{
    [self.delegate OnAccountSetup];
}

-(IBAction)OnPersonalProfile:(id)sender
{
    [self.delegate OnPersonalProfile];
}

-(IBAction)OnIntenational:(id)sender
{
    [self.delegate OnChgLang];
}

//-(IBAction)OnFeedback:(id)sender
//{
//    [self.delegate OnFeedback];
//}

-(IBAction)OnAbout:(id)sender
{
    [self.delegate OnAbout];
}
-(void)MakeCall:(NSString *)strPhone
{
    UIWebView* callWebview =[[UIWebView alloc] init];
    
    NSString * strPhoneNo = [NSString stringWithFormat:@"tel://%@",strPhone];
    NSURL *telURL =[NSURL URLWithString:strPhoneNo];
    [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
    [self.view addSubview:callWebview];
    
    
}

- (void)OnCall
{
    [self MakeCall:@"4000196628"];
}

- (IBAction)OnContactUs:(id)sender
{
    [RPGuide ShowGuide:self.view];
}

- (IBAction)OnCacheManagement:(id)sender
{
    [self.delegate OnCacheManagement];
}

-(void)OnChangeProfileEnd
{
    [self Reload];
}

-(void)OnBackTask
{
    
}

-(void)Reload
{
    if ([g_strLangCode isEqualToString:@"zh-Hans"])
    {
        _lbLangCode.text = @"中文简体";
        _ivLang.image = [UIImage imageNamed:@"icon_flags_CNZ.png"];
    }
    else
    {
        _lbLangCode.text = @"English";
        _ivLang.image = [UIImage imageNamed:@"icon_flags_US.png"];
    }
    
    [[RPSDK defaultInstance] GetUserDetailInfo:@"" Success:^(UserDetailInfo * userDetail) {
        [RPSDK defaultInstance].userLoginDetail = userDetail;
        _lbAccount.text = [RPSDK defaultInstance].userLoginDetail.strUserAcount;
        _lbRp.text = [NSString stringWithFormat:@"(%@)",[RPSDK defaultInstance].userLoginDetail.strUserCode];
        
        [_ivPic setImageWithURLString:[RPSDK defaultInstance].userLoginDetail.strPortraitImg placeholderImage:[UIImage imageNamed:@"icon_userimage01_224.png"]];
        
        _lbUserName.text = [NSString stringWithFormat:@"%@",[RPSDK defaultInstance].userLoginDetail.strFirstName];
        
        _lbJobTitle.text = [RPSDK defaultInstance].userLoginDetail.strRoleName;
        
        switch ([RPSDK defaultInstance].userLoginDetail.rank) {
            case Rank_Manager:
                _lbJobTitle.backgroundColor = [UIColor colorWithRed:150.0f/255 green:70.0f/255 blue:150.0f/255 alpha:1];
                break;
            case Rank_StoreManager:
                _lbJobTitle.backgroundColor = [UIColor colorWithRed:230.0f/255 green:110.0f/255 blue:10.0f/255 alpha:1];
                break;
            case Rank_Assistant:
                _lbJobTitle.backgroundColor = [UIColor colorWithRed:50.0f/255 green:105.0f/255 blue:175.0f/255 alpha:1];
                break;
            case Rank_Vendor:
                _lbJobTitle.backgroundColor = [UIColor colorWithRed:150.0f/255 green:170.0f/255 blue:20.0f/255 alpha:1];
                break;
                
            default:
                break;
        }
    } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
        
    }];

    
    [[RPSDK defaultInstance] GetLoginDeviceList:^(NSArray * arrayDevice) {
        [RPSDK defaultInstance].arrayLoginDevice = arrayDevice;
    } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
        
    }];
}
-(void)ShowTitleBar
{
    _lbTitle.alpha = 0;
    _lbTitle.hidden = NO;
    
    [UIView beginAnimations:nil context:nil];
    _lbTitle.alpha = 1;
    [UIView commitAnimations];
}

-(void)HideTitleBar
{
    _lbTitle.hidden = YES;
}

@end
