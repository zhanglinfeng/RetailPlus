//
//  ImageCropperController.m
//  DressMemo
//
//  Created by 董 林 on 12-11-28.
//
//

#import "ImageCropperController.h"
#import <QuartzCore/QuartzCore.h>

@interface ImageCropperController ()

@end

@implementation ImageCropperController
@synthesize image = _image;
@synthesize delegate = _delegate;

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
    _imageCropper = [[KICropImageView alloc] initWithFrame:CGRectMake(0, 0, _frameview.frame.size.width, _frameview.frame.size.height)];
    [_imageCropper setCropSize:CGSizeMake(300, 400)];
    [_imageCropper setImage:_image];
    [_frameview addSubview:_imageCropper];
    [_imageCropper SetFitScale];
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    
    gradient.frame = CGRectMake(0, 0, _toolbarFrameView.frame.size.width, _toolbarFrameView.frame.size.height);
    gradient.colors = [NSArray arrayWithObjects:(id)[UIColor whiteColor].CGColor,
                       (id)[UIColor lightGrayColor].CGColor,nil];
    [_toolbarFrameView.layer insertSublayer:gradient atIndex:0];
    
    CGSize result = [[UIScreen mainScreen] bounds].size;
    if(result.height <= 480.f)
        return;
    _logoView.frame = CGRectMake(0, 0, _logoView.frame.size.width, _logoView.frame.size.height);
    _backPicView.frame = CGRectMake(0, _backPicView.frame.origin.y + _logoView.frame.size.height, _backPicView.frame.size.width, _backPicView.frame.size.height);
    _frameview.frame = CGRectMake(0, _frameview.frame.origin.y + _logoView.frame.size.height, _frameview.frame.size.width, _frameview.frame.size.height);
    _toolbarFrameView.frame = CGRectMake(0, _toolbarFrameView.frame.origin.y + _logoView.frame.size.height, _toolbarFrameView.frame.size.width, _toolbarFrameView.frame.size.height);
    
    _btnBack.frame = CGRectMake(_btnBack.frame.origin.x, _btnBack.frame.origin.y + 15, 75,45);
    [_btnBack setBackgroundImage:[UIImage imageNamed:@"btn-backBi5.png"] forState:UIControlStateNormal];
    
    _btnConfirm.frame = CGRectMake(_btnConfirm.frame.origin.x, _btnConfirm.frame.origin.y + 15, _btnConfirm.frame.size.width,45);
    [_btnConfirm setBackgroundImage:[UIImage imageNamed:@"btn-redBi5.png"] forState:UIControlStateNormal];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)OnSave:(id)sender
{
    [_delegate OnSave:[_imageCropper cropImage]];
}

-(IBAction)OnBack:(id)sender
{
    [_delegate OnBack];
}

-(void)viewWillAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
}

@end
