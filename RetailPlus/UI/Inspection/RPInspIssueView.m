//
//  RPInspIssueView.m
//  RetailPlus
//
//  Created by lin dong on 13-8-20.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "UIImageView+WebCache.h"
#import "RPInspIssueView.h"
#import "MarkViewController.h"
#import "SVProgressHUD.h"
#import "RPBlockUIAlertView.h"

extern NSBundle * g_bundleResorce;

@implementation RPInspIssueView
@synthesize bModifyMode = _bModifyMode;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)awakeFromNib
{
    CALayer *sublayer = _btnPic1.layer;
    sublayer.cornerRadius = 6;
    sublayer.borderColor = [UIColor lightGrayColor].CGColor;
    sublayer.borderWidth = 1;
    
    sublayer = _btnPic2.layer;
    sublayer.cornerRadius = 6;
    sublayer.borderColor = [UIColor lightGrayColor].CGColor;
    sublayer.borderWidth = 1;
    
    sublayer = _btnPic3.layer;
    sublayer.cornerRadius = 6;
    sublayer.borderColor = [UIColor lightGrayColor].CGColor;
    sublayer.borderWidth = 1;
    
    sublayer = _viewFrame.layer;
    sublayer.cornerRadius = 6;
    
    sublayer = _viewTitalFrame.layer;
    sublayer.cornerRadius = 6;
    sublayer.borderColor = [UIColor lightGrayColor].CGColor;
    sublayer.borderWidth = 1;
    
    sublayer = _tvDesc.layer;
    sublayer.cornerRadius = 6;
    sublayer.borderColor = [UIColor lightGrayColor].CGColor;
    sublayer.borderWidth = 1;
    
    sublayer = _viewPos.layer;
    sublayer.cornerRadius = 6;
    sublayer.borderColor = [UIColor lightGrayColor].CGColor;
    sublayer.borderWidth = 1;
    
    _markImageViewController = [[RPMarkImageViewController alloc] initWithNibName:NSStringFromClass([RPMarkImageViewController class]) bundle:g_bundleResorce];
    _markImageViewController.view.frame = CGRectMake(0,self.frame.size.height,self.frame.size.width, self.frame.size.height);
    _markImageViewController.delegate = self;
    [self addSubview:_markImageViewController.view];

    _nScrollHeightExShopMap = 350;
    

    _btnLocationCanvas = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnLocationCanvas setBounds:CGRectMake(0, 0, 20, 20)];
    [_btnLocationCanvas setImage:[UIImage imageNamed:@"icon_target.png"] forState:UIControlStateNormal];
    _btnLocationCanvas.hidden = YES;
    [_ivLocationCanvas addSubview:_btnLocationCanvas];
    
    UITapGestureRecognizer *singleTapGR =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                        action:@selector(tapAnywhereToDismissKeyboard:)];
    [self addGestureRecognizer:singleTapGR];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(locationCanvasTapped:)];
    [_ivLocationCanvas addGestureRecognizer:tap];
    
    _bShowCanvasView = NO;
    
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"CustomView" owner:self options:nil];
    _viewShowImg = [array objectAtIndex:2];
  //  _viewShowImg.delegate = self;
}

- (void)tapAnywhereToDismissKeyboard:(UIGestureRecognizer *)gestureRecognizer {
    [self endEditing:YES];
}

-(void)setIssue:(InspIssue *)issue
{
    if (issue == nil) {
        _issue = [[InspIssue alloc] init];
        _issue.arrayIssueImg = [NSMutableArray arrayWithArray:@[[[InspIssueImage alloc] init],[[InspIssueImage alloc] init], [[InspIssueImage alloc] init]]];
        _bModifyMode = NO;
    }
    else
    {
        _issue = issue;
        for (InspIssueImage * image in _issue.arrayIssueImg) {
            if ((image.imgIssue == nil) && (image.strUrl.length > 0)) {
                image.imgIssue = [RPSDK loadImageFromURL:image.strUrl];
            }
        }
        _bModifyMode = YES;
    }
    
    __block RPInspIssueView *view = self;
    
    [SVProgressHUD showWithStatus:NSLocalizedStringFromTableInBundle(@"Please wait...",@"RPString", g_bundleResorce,nil)];
    
    [_ivShopMap setImageWithURLString:_strShopMapUrl placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        view.imgShopMap = image;
        [view UpdateUI];
        [SVProgressHUD dismiss];
    }];
    
    [_scollFrame setContentOffset:CGPointMake(0, 0) animated:NO];
    [self UpdateUI];
}

-(BOOL)isValidString:(NSString *)string
{
    return YES;
}

-(void)UpdateUI
{
    _tfTital.text = self.issue.strIssueTitle;
    _tvDesc.text = self.issue.strIssueDesc;

    NSInteger nHeight = _imgShopMap.size.height / (_imgShopMap.size.width / _viewPos.frame.size.width);
    
    if (_imgShopMap) {
        CGRect rc = CGRectMake(_viewPos.frame.origin.x, _viewPos.frame.origin.y, _viewPos.frame.size.width, nHeight);
        _viewPos.frame = rc;
        _scollFrame.contentSize = CGSizeMake(_scollFrame.frame.size.width, _nScrollHeightExShopMap + nHeight);
    }
    
    
    NSInteger nBtnIndex = 0;
    
    for (InspIssueImage * image in self.issue.arrayIssueImg) {
        if (image.imgIssue == nil)
        {
            if ([self isValidString:image.strLocalFileName]) {
                image.imgIssue = [RPSDK loadImage:image.strLocalFileName ofType:@"png" inDirectory:[RPSDK GetCacheDir]];
            }
            
            if (image.imgIssue == nil) {
                if ([self isValidString:image.strUrl]) {
                    image.imgIssue = [RPSDK loadImageFromURL:image.strUrl];
                }
            }
        }
        else
        {
            if (![self isValidString:image.strLocalFileName]) {
                NSString * strFileName = [RPSDK genUUID];
                [RPSDK saveImage:image.imgIssue withFileName:strFileName ofType:@"png" inDirectory:[RPSDK GetCacheDir]];
                image.strLocalFileName = strFileName;
            }
        }
        
        if (image.imgIssue) {
            switch (nBtnIndex) {
                case 0:
                    [_btnPic1 setImage:image.imgIssue forState:UIControlStateNormal];
                    _btnDelPic1.hidden = NO;
                    break;
                case 1:
                    [_btnPic2 setImage:image.imgIssue forState:UIControlStateNormal];
                    _btnDelPic2.hidden = NO;
                    break;
                case 2:
                    [_btnPic3 setImage:image.imgIssue forState:UIControlStateNormal];
                    _btnDelPic3.hidden = NO;
                    break;
                default:
                    break;
            }
        }
        else
        {
            switch (nBtnIndex) {
                case 0:
                    [_btnPic1 setImage:[UIImage imageNamed:@"icon_addpicture01@2x.png"] forState:UIControlStateNormal];
                    _btnDelPic1.hidden = YES;
                    break;
                case 1:
                    [_btnPic2 setImage:[UIImage imageNamed:@"icon_addpicture01@2x.png"] forState:UIControlStateNormal];
                    _btnDelPic2.hidden = YES;
                    break;
                case 2:
                    [_btnPic3 setImage:[UIImage imageNamed:@"icon_addpicture01@2x.png"] forState:UIControlStateNormal];
                    _btnDelPic3.hidden = YES;
                    break;
                default:
                    break;
            }
        }
        nBtnIndex ++;
    }
    
    if (_issue.bHasLocation && _ivShopMap.image.size.width > 0 && _ivShopMap.image.size.height > 0) {
        CGPoint location;
        location.x = _issue.ptLocation.x / _ivShopMap.image.size.width * _ivShopMap.frame.size.width ;
        location.y = _issue.ptLocation.y / _ivShopMap.image.size.height * _ivShopMap.frame.size.height;
        [_btnLocationCanvas setCenter:location];
        _btnLocationCanvas.hidden = NO;
    }
    else
        _btnLocationCanvas.hidden = YES;
}

- (void)locationCanvasTapped:(UITapGestureRecognizer *)tap
{
    [self endEditing:YES];
    
    if (_imgShopMap == nil) {
        NSString * str = NSLocalizedStringFromTableInBundle(@"Store layout is empty",@"RPString", g_bundleResorce,nil);
        [SVProgressHUD showErrorWithStatus:str];
        return;
    }
    
    _markViewController = nil;
    
    _markViewController = [[MarkViewController alloc] initWithNibName:nil bundle:nil cadImage:_imgShopMap curentPoint:self.issue.ptLocation isMarked:self.issue.bHasLocation];
    _markViewController.delegate = self;
    _markViewController.view.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y + self.frame.size.height, self.frame.size.width, self.frame.size.height);
    [self.superview addSubview:_markViewController.view];
    
    [UIView beginAnimations:nil context:nil];
    _markViewController.view.frame = self.frame;
    [UIView commitAnimations];
    _bShowCanvasView = YES;
}

-(void)Markend:(CGPoint)point isMarked:(BOOL)bMarked
{
    [UIView beginAnimations:nil context:nil];
    _markViewController.view.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y + self.frame.size.height, self.frame.size.width, self.frame.size.height);
    [UIView commitAnimations];
    
    self.issue.ptLocation = point;
    self.issue.bHasLocation = bMarked;
    _bShowCanvasView = NO;
    [self UpdateUI];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    UIImage * imgCrop = [RPSDK CropImage:image withSize:CGSizeMake(640, 640)];

    UIImageWriteToSavedPhotosAlbum(image,nil,nil,nil);
    
    InspIssueImage * issueImage = [self.issue.arrayIssueImg objectAtIndex:_nCurrentImgButtonIndex];
    issueImage.imgIssue = imgCrop;
    issueImage.strLocalFileName = nil;
    issueImage.strUrl = nil;
    
    [picker dismissViewControllerAnimated:YES completion:^{

    }];

    _bImagePickEndShowMarkImgCtrl = YES;
    [self performSelectorOnMainThread:@selector(ShowMarkImageCtrl) withObject:self waitUntilDone:NO];
}

-(IBAction)OnImageButton:(UIButton *)sender
{
    [self endEditing:YES];
    
    InspIssueImage * issueImage = [self.issue.arrayIssueImg objectAtIndex:(sender.tag - 100)];
    
    if (issueImage.imgIssue != nil) {
        [UIView beginAnimations:nil context:nil];
        _markImageViewController.view.frame = CGRectMake(0,0,self.frame.size.width, self.frame.size.height);
        [UIView commitAnimations];
        
        _markImageViewController.bReadOnly = !self.bMarkRectInImage;
        InspIssueImage * issueImage = [_issue.arrayIssueImg objectAtIndex:(sender.tag - 100)];
        [_markImageViewController setImage:issueImage];
        
        _bShowImgDetailView = YES;
        _bImagePickEndShowMarkImgCtrl = NO;
    }
    else {
        
        
        _nCurrentImgButtonIndex = sender.tag - 100;
        
        NSString * strDesc = NSLocalizedStringFromTableInBundle(@"Please select the image source type?",@"RPString", g_bundleResorce,nil);
        NSString * strCamera = NSLocalizedStringFromTableInBundle(@"Camera",@"RPString", g_bundleResorce,nil);
        NSString * strPhotoLibrary = NSLocalizedStringFromTableInBundle(@"Photo Library",@"RPString", g_bundleResorce,nil);
        NSString * strCancel = NSLocalizedStringFromTableInBundle(@"CANCEL",@"RPString", g_bundleResorce,nil);
        
        RPBlockUIAlertView *alertView = [[RPBlockUIAlertView alloc] initWithTitle:nil message:strDesc cancelButtonTitle:strCancel clickButton:^(NSInteger indexButton){
            UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
            if (indexButton == 1) {
                sourceType = UIImagePickerControllerSourceTypeCamera;
                if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
                    sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                }
            }
            if (indexButton == 2) {
                 sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            }
            
            if (indexButton == 1 || indexButton == 2) {
                UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                picker.delegate = self;
                picker.sourceType = sourceType;
                picker.allowsEditing = YES;
                picker.view.userInteractionEnabled = YES;
                
                [self.vcFrame presentViewController:picker animated:YES completion:^{
                    
                }];
            }
        } otherButtonTitles:strCamera,strPhotoLibrary,nil];
        [alertView show];
    }
}

-(IBAction)OnImageDeleteButton:(UIButton *)sender
{
    [self endEditing:YES];
    
    NSString * strDesc = NSLocalizedStringFromTableInBundle(@"Confirm to delete this picture?",@"RPString", g_bundleResorce,nil);
    NSString * strCancel = NSLocalizedStringFromTableInBundle(@"CANCEL",@"RPString", g_bundleResorce,nil);
    NSString * strOK = NSLocalizedStringFromTableInBundle(@"OK",@"RPString", g_bundleResorce,nil);
    
    RPBlockUIAlertView *alertView = [[RPBlockUIAlertView alloc] initWithTitle:nil message:strDesc cancelButtonTitle:strCancel clickButton:^(NSInteger indexButton){
        if (indexButton == 1) {
            InspIssueImage * issueImage = [self.issue.arrayIssueImg objectAtIndex:(sender.tag - 200)];
            issueImage.strLocalFileName = nil;
            issueImage.rcIssue = CGRectMake(0, 0, 0, 0);
            issueImage.strUrl = nil;
            issueImage.imgIssue = nil;
            [self UpdateUI];
        }
    } otherButtonTitles:strOK,nil];
    [alertView show];
}

-(IBAction)OnOk:(id)sender
{
    if (_issue.strIssueTitle.length>RPMAX_TITLE_LENGTH)
    {
        NSString *s=NSLocalizedStringFromTableInBundle(@"Title length should not exceed 50 characters",@"RPString", g_bundleResorce,nil);
        [SVProgressHUD showErrorWithStatus:s];
        return;
    }
    if (_issue.strIssueDesc.length>RPMAX_DESC_LENGTH)
    {
        NSString *s=NSLocalizedStringFromTableInBundle(@"Describe length should not exceed 300 characters",@"RPString", g_bundleResorce,nil);
        [SVProgressHUD showErrorWithStatus:s];
        return;
    }
    
    if (_issue.strIssueTitle.length == 0) {
        NSString * strDesc = NSLocalizedStringFromTableInBundle(@"Title is empty",@"RPString", g_bundleResorce,nil);
        [SVProgressHUD showErrorWithStatus:strDesc];
        return;
    }
    
    if (_issue.strIssueDesc.length == 0) {
        NSString * strDesc = NSLocalizedStringFromTableInBundle(@"Description is empty",@"RPString", g_bundleResorce,nil);
        [SVProgressHUD showErrorWithStatus:strDesc];
        return;
    }
    
//    if (!_issue.bHasLocation) {
//        NSString * strDesc = NSLocalizedStringFromTableInBundle(@"No location is assigned",@"RPString", g_bundleResorce,nil);
//        [SVProgressHUD showErrorWithStatus:strDesc];
//        return;
//    }
    
//    BOOL bHasImage = NO;
//    for(RPInspIssueImage * image in _issue.arrayIssueImg)
//    {
//        if (image.imgIssue != nil) {
//            bHasImage = YES;
//            break;
//        }
//    }
//    
//    if (!bHasImage) {
//        [SVProgressHUD showErrorWithStatus:@"No image is taked."];
//        return;
//    }
    
    _issue.strIssueDesc = _tvDesc.text;
    _issue.strIssueTitle = _tfTital.text;
    
    if (!_bModifyMode && self.catagory) {
        if (!self.catagory.arrayIssue) self.catagory.arrayIssue = [[NSMutableArray alloc] init];
        
        [self.catagory.arrayIssue addObject:_issue];
    }
    [self.delegate OnModifyIssueEnd];
}

-(IBAction)OnDeleteIssue:(id)sender
{
    NSString * strOK = NSLocalizedStringFromTableInBundle(@"OK",@"RPString", g_bundleResorce,nil);
    NSString * strCancel = NSLocalizedStringFromTableInBundle(@"CANCEL",@"RPString", g_bundleResorce,nil);
    NSString * str = NSLocalizedStringFromTableInBundle(@"Confirm to delete this issue?",@"RPString", g_bundleResorce,nil);
    
    RPBlockUIAlertView *alertView = [[RPBlockUIAlertView alloc] initWithTitle:nil message:str cancelButtonTitle:strCancel clickButton:^(NSInteger indexButton){
        if (indexButton == 1) {
            if (_bModifyMode && self.catagory){
                [self.catagory.arrayIssue removeObject:_issue];
            }
            [self.delegate OnDeleteIssue];
        }
    } otherButtonTitles:strOK,nil];
    [alertView show];
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [self endEditing:YES];
    
    if (textField == _tfTital) {
        _issue.strIssueTitle = _tfTital.text;
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [self endEditing:YES];
    
    if (textView == _tvDesc) {
        _issue.strIssueDesc = _tvDesc.text;
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
-(BOOL)OnBack
{
    [self endEditing:YES];
    if (_bShowCanvasView) {
        [UIView beginAnimations:nil context:nil];
        _markViewController.view.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y + self.frame.size.height, self.frame.size.width, self.frame.size.height);
        [UIView commitAnimations];
        _bShowCanvasView = NO;
        
        return NO;
    }
    
    if (_bShowImgDetailView)
    {
        [UIView beginAnimations:nil context:nil];
        _markImageViewController.view.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
        [UIView commitAnimations];
        _bShowImgDetailView = NO;
        
        if (_bImagePickEndShowMarkImgCtrl) {
            InspIssueImage * issueImage = [self.issue.arrayIssueImg objectAtIndex:(_nCurrentImgButtonIndex)];
            issueImage.strLocalFileName = nil;
            issueImage.rcIssue = CGRectMake(0, 0, 0, 0);
            issueImage.strUrl = nil;
            issueImage.imgIssue = nil;
        }
        [self UpdateUI];
        return  NO;
    }
    
    if (!_bModifyMode)
    {
        if (_issue.strIssueTitle.length == 0 && _issue.strIssueDesc.length == 0
            && ((InspIssueImage *)[_issue.arrayIssueImg objectAtIndex:0]).imgIssue == nil
            && ((InspIssueImage *)[_issue.arrayIssueImg objectAtIndex:1]).imgIssue == nil
            && ((InspIssueImage *)[_issue.arrayIssueImg objectAtIndex:2]).imgIssue == nil) {
            return YES;
        }
    }
    
    
    [self OnOk:nil];
    return NO;
}

-(void)ShowMarkImageCtrl
{
    if (!self.bMarkRectInImage) {
        return;
    }
    
    [UIView beginAnimations:nil context:nil];
    _markImageViewController.view.frame = CGRectMake(0,0,self.frame.size.width, self.frame.size.height);
    [UIView commitAnimations];
    
    _markImageViewController.bReadOnly = NO;
    InspIssueImage * issueImage = [_issue.arrayIssueImg objectAtIndex:_nCurrentImgButtonIndex];
    [_markImageViewController setImage:issueImage];
    _bShowImgDetailView = YES;
}

-(void)OnMarkInViewEnd
{
    [UIView beginAnimations:nil context:nil];
    _markImageViewController.view.frame = CGRectMake(0,self.frame.size.height,self.frame.size.width, self.frame.size.height);
    [UIView commitAnimations];
    _bShowImgDetailView = NO;
    [self UpdateUI];
}
@end
