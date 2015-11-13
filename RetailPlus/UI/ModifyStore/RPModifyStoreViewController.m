//
//  RPModifyStoreViewController.m
//  RetailPlus
//
//  Created by lin dong on 14-5-5.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPModifyStoreViewController.h"
#import "UIButton+WebCache.h"
#import "UIImageView+WebCache.h"

extern NSBundle * g_bundleResorce;

@interface RPModifyStoreViewController ()

@end

@implementation RPModifyStoreViewController

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
    self.strTaskName = NSLocalizedStringFromTableInBundle(@"STORE PROFILE EDIT",@"RPString", g_bundleResorce,nil);
    
    _viewTable1.layer.cornerRadius = 5;
    _viewTable2.layer.cornerRadius = 5;
    _viewTable3.layer.cornerRadius = 5;
    
    _viewTable1.layer.borderWidth = 1;
    _viewTable1.layer.borderColor = [UIColor colorWithWhite:0.5 alpha:1].CGColor;
    _viewTable2.layer.borderWidth = 1;
    _viewTable2.layer.borderColor = [UIColor colorWithWhite:0.5 alpha:1].CGColor;
    _viewTable3.layer.borderWidth = 1;
    _viewTable3.layer.borderColor = [UIColor colorWithWhite:0.5 alpha:1].CGColor;
    
    _ivThumb.layer.cornerRadius = 6;
//    _ivThumb.layer.borderWidth = 1;
//    _ivThumb.layer.borderColor = [UIColor colorWithWhite:0.5 alpha:1].CGColor;
    _ivThumb.layer.shadowOffset = CGSizeMake(-3, 3);
    _ivThumb.layer.shadowRadius =3.0;
    _ivThumb.layer.shadowColor =[UIColor blackColor].CGColor;
    _ivThumb.layer.shadowOpacity =0.9;

    
    _viewFrame.layer.cornerRadius = 5;
    
    _svFrame.contentSize = CGSizeMake(_svFrame.frame.size.width, 500);
    _tfBusinessHours.inputView = _viewHours;
    
    //*********************投影专用View********************//
    UIView *view1=[[UIView alloc]initWithFrame:CGRectMake(_ivThumb.frame.origin.x, _ivThumb.frame.origin.y, _ivThumb.frame.size.width, _ivThumb.frame.size.height)];
    [_svFrame insertSubview:view1 belowSubview:_ivThumb];
    view1.backgroundColor=[UIColor whiteColor];
    view1.layer.cornerRadius = 6;
    view1.layer.shadowOffset = CGSizeMake(-4, 4);
    view1.layer.shadowRadius =3.0;
    view1.layer.shadowColor =[UIColor blackColor].CGColor;
    view1.layer.shadowOpacity =0.3;
    
    UIView *view2=[[UIView alloc]initWithFrame:CGRectMake(_ivThumb.frame.origin.x, _ivThumb.frame.origin.y, _ivThumb.frame.size.width, _ivThumb.frame.size.height)];
    [_svFrame insertSubview:view2 belowSubview:_ivThumb];
    view2.backgroundColor=[UIColor whiteColor];
    view2.layer.cornerRadius = 6;
    view2.layer.shadowOffset = CGSizeMake(4, -4);
    view2.layer.shadowRadius =3.0;
    view2.layer.shadowColor =[UIColor blackColor].CGColor;
    view2.layer.shadowOpacity =0.3;
    
    UIView *view3=[[UIView alloc]initWithFrame:CGRectMake(_ivThumb.frame.origin.x, _ivThumb.frame.origin.y, _ivThumb.frame.size.width, _ivThumb.frame.size.height)];
    [_svFrame insertSubview:view3 belowSubview:_ivThumb];
    view3.backgroundColor=[UIColor whiteColor];
    view3.layer.cornerRadius = 6;
    view3.layer.shadowOffset = CGSizeMake(4, 4);
    view3.layer.shadowRadius =3.0;
    view3.layer.shadowColor =[UIColor blackColor].CGColor;
    view3.layer.shadowOpacity =0.3;
    
    UIView *view4=[[UIView alloc]initWithFrame:CGRectMake(_ivThumb.frame.origin.x, _ivThumb.frame.origin.y, _ivThumb.frame.size.width, _ivThumb.frame.size.height)];
    [_svFrame insertSubview:view4 belowSubview:_ivThumb];
    view4.backgroundColor=[UIColor whiteColor];
    view4.layer.cornerRadius = 6;
    view4.layer.shadowOffset = CGSizeMake(-4, -4);
    view4.layer.shadowRadius =3.0;
    view4.layer.shadowColor =[UIColor blackColor].CGColor;
    view4.layer.shadowOpacity =0.3;
    
}

-(void)awakeFromNib
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setStoreSelected:(StoreDetailInfo *)storeSelected
{
    _storeSelected = storeSelected;
    _lbTitle.text = [NSString stringWithFormat:@"%@ %@",storeSelected.strBrandName,storeSelected.strStoreName];
    _tfName.text = storeSelected.strStoreName;
    _tvAddress.text = storeSelected.strStoreAddress;
    _tfPostCode.text = storeSelected.strStorePostCode;
    _tfPhone.text = storeSelected.strPhone;
    _tfFax.text = storeSelected.strFax;
    _tfEmail.text = storeSelected.strEmail;
    _tfBusinessHours.text = [NSString stringWithFormat:@"%@ - %@",storeSelected.strStartTime,storeSelected.strEndTime];
    _tfArea.text = storeSelected.strAreaSquare;
    
    [_ivThumb setImageWithURLString:storeSelected.strStoreThumb placeholderImage:[UIImage imageNamed:@"button_store_photo@2x.png"]];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    _bModified = YES;
    UIImage * imgCrop = [RPSDK CropImage:image withSize:CGSizeMake(640, 640)];
    [_ivThumb setImage:imgCrop];
    _imgStore = imgCrop;
    [picker dismissModalViewControllerAnimated:NO];
}

-(IBAction)OnStoreThumb:(id)sender
{
    [self.view endEditing:YES];
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

-(IBAction)OnOk:(id)sender
{
    if (_bModified) {
        StoreDetailInfo * info = [[StoreDetailInfo alloc] init];
        info.strStoreId = _storeSelected.strStoreId;
        info.strStoreCode = _storeSelected.strStoreCode;
        info.strStoreName = _tfName.text;
        info.strStoreAddress = _tvAddress.text;
        info.strEmail = _tfEmail.text;
        info.strFax = _tfFax.text;
        info.strStartTime = @"";
        info.strEndTime = @"";
        if (_tfBusinessHours.text.length >= 13)
        {
            info.strStartTime = [_tfBusinessHours.text substringWithRange:NSMakeRange(0, 5)];
            info.strEndTime = [_tfBusinessHours.text substringWithRange:NSMakeRange(8, 5)];
        }
        info.strAreaSquare = _tfArea.text;
        info.strStorePostCode = _tfPostCode.text;
        info.strPhone = _tfPhone.text;
        info.imgStore = _imgStore;
        [[RPSDK defaultInstance] UpdateStoreProfile:info Success:^(StoreDetailInfo * store) {
            _bModified = NO;
            [self.delegate OnUpdateStoreEnd:store];
        } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
            
        }];
    }
    else
        [self.delegate OnTaskEnd];
}

-(BOOL)OnBack
{
    if (_bModified) {
        [self.view endEditing:YES];
        
        NSString * strSave = NSLocalizedStringFromTableInBundle(@"SAVE",@"RPString", g_bundleResorce,nil);
        NSString * strDont = NSLocalizedStringFromTableInBundle(@"DON'T SAVE",@"RPString", g_bundleResorce,nil);
        NSString *strCancel=NSLocalizedStringFromTableInBundle(@"CANCEL",@"RPString", g_bundleResorce,nil);
        NSString * strDesc = NSLocalizedStringFromTableInBundle(@"Save changes before leave?",@"RPString", g_bundleResorce,nil);
        RPBlockUIAlertView *alertView=[[RPBlockUIAlertView alloc]initWithTitle:nil message:strDesc cancelButtonTitle:strCancel clickButton:^(NSInteger indexButton) {
            if (indexButton==2)
            {
                _bModified = NO;
                [self.delegate OnTaskEnd];
            }
            else if(indexButton==0)
            {
                
            }
            else
            {
                [self OnOk:nil];
            }
        }otherButtonTitles:strSave,strDont, nil];
        [alertView show];
        return NO;
    }
    else
        return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    _bModified = YES;
    return YES;
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    _bModified = YES;
    return YES;
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    _svFrame.contentSize = CGSizeMake(_svFrame.frame.size.width, 700);
    [_svFrame setContentOffset:CGPointMake(0, _viewTable1.frame.origin.y - 10) animated:YES];
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == _tfBusinessHours) {
        _viewHours.tfParent = _tfBusinessHours;
        _bModified = YES;
    }
    
    if (textField == _tfName) {
        _svFrame.contentSize = CGSizeMake(_svFrame.frame.size.width, 700);
        [_svFrame setContentOffset:CGPointMake(0, _viewTable1.frame.origin.y - 10) animated:YES];
    }
    
    if (textField == _tfPostCode) {
        _svFrame.contentSize = CGSizeMake(_svFrame.frame.size.width, 700);
        [_svFrame setContentOffset:CGPointMake(0, _viewTable1.frame.origin.y + 30) animated:YES];
    }

    
    if (textField == _tfPhone || textField == _tfFax || textField == _tfEmail) {
        _svFrame.contentSize = CGSizeMake(_svFrame.frame.size.width, 700);
        [_svFrame setContentOffset:CGPointMake(0, _viewTable2.frame.origin.y - 10) animated:YES];
    }
    
    if (textField == _tfBusinessHours || textField == _tfArea) {
        _svFrame.contentSize = CGSizeMake(_svFrame.frame.size.width, 700);
        [_svFrame setContentOffset:CGPointMake(0, _viewTable3.frame.origin.y - 10) animated:YES];
    }
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == _tfName) {
        _lbTitle.text = [NSString stringWithFormat:@"%@ %@",_storeSelected.strBrandName,_tfName.text];
    }
    
   // _svFrame.contentSize = CGSizeMake(_svFrame.frame.size.width, 500);
   // [_svFrame setContentOffset:CGPointMake(0, 0) animated:NO];
}
@end
