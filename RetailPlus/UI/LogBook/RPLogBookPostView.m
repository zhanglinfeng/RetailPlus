//
//  RPLogBookPostView.m
//  RetailPlus
//
//  Created by lin dong on 14-3-4.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPLogBookPostView.h"
#import "RPBlockUISelectView.h"
#import "RPBlockUIAlertView.h"
#import "SVProgressHUD.h"

extern NSBundle * g_bundleResorce;
@implementation RPLogBookPostView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */
-(void)awakeFromNib
{
    _viewBackground.layer.cornerRadius=10;
    _viewText.layer.cornerRadius=6;
    _viewText.layer.borderWidth=1;
    _viewText.layer.borderColor=[[UIColor colorWithWhite:0.7 alpha:1]CGColor];
    _viewTitle.layer.cornerRadius=6;
    _viewTitle.layer.borderWidth=1;
    _viewTitle.layer.borderColor=[[UIColor colorWithWhite:0.7 alpha:1]CGColor];
    _btPic1.layer.cornerRadius=6;
    _btPic2.layer.cornerRadius=6;
    _btPic3.layer.cornerRadius=6;
    _btPic1.layer.borderWidth=1;
    _btPic1.layer.borderColor=[[UIColor colorWithWhite:0.7 alpha:1]CGColor];
    _btPic2.layer.borderWidth=1;
    _btPic2.layer.borderColor=[[UIColor colorWithWhite:0.7 alpha:1]CGColor];
    _btPic3.layer.borderWidth=1;
    _btPic3.layer.borderColor=[[UIColor colorWithWhite:0.7 alpha:1]CGColor];
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(OnEndEditing)];
    [self addGestureRecognizer:tap];
    _arrayImg=[[NSMutableArray alloc]init];
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"CustomView" owner:self options:nil];
    _viewShowImg = [array objectAtIndex:2];
}
-(void)OnEndEditing
{
    [self endEditing:YES];
}
-(BOOL)OnBack
{
    if (_bShowBig)
    {
        [UIView beginAnimations:nil context:nil];
        _viewShowImg.frame=CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
        [UIView commitAnimations];
        _bShowBig=NO;
        return NO;
    }
    return YES;
}
-(void)setStoreSelected:(StoreDetailInfo *)storeSelected
{
    _storeSelected=storeSelected;
    _tvTitle.text=@"";
    _tvText.text=@"";
    [_btPic1 setImage:[UIImage imageNamed:@"icon_addpicture01.png"] forState:UIControlStateNormal];
    [_btPic2 setImage:[UIImage imageNamed:@"icon_addpicture01.png"] forState:UIControlStateNormal];
    [_btPic3 setImage:[UIImage imageNamed:@"icon_addpicture01.png"] forState:UIControlStateNormal];
    [_arrayImg removeAllObjects];
    _btDelete1.hidden = YES;
    _btDelete2.hidden = YES;
    _btDelete3.hidden = YES;
    _bPic1=NO;
    _bPic2=NO;
    _bPic3=NO;
}

-(void)textViewDidChange:(UITextView *)textView
{
    if (textView==_tvTitle)
    {
        if (textView.text.length == 0) {
            _lbTipTitle.text = NSLocalizedStringFromTableInBundle(@"Title",@"RPString", g_bundleResorce,nil);
        }else{
            _lbTipTitle.text = @"";
        }
    }
    if (textView==_tvText)
    {
        if (textView.text.length == 0) {
            _lbTipText.text = NSLocalizedStringFromTableInBundle(@"Text",@"RPString", g_bundleResorce,nil);
        }else{
            _lbTipText.text = @"";
        }
    }
}

//从后台获取主题分类
- (IBAction)OnThemeCategories:(UIButton *)sender {
    NSMutableArray* arrCateTheme = [NSMutableArray array];
    NSMutableArray* arrTagID = [NSMutableArray array];
    [[RPSDK defaultInstance] GetLogBookTagSuccess:^(NSArray* arrayResult) {
        if (arrayResult.count == 0) return;
        
        for (LogBookTag* BookTag in arrayResult) {
            [arrCateTheme addObject:BookTag.strDesc];
            [arrTagID addObject:BookTag.strTagId];
        }
        NSInteger nSel = 0;
        for (int i=0; i<arrCateTheme.count; i++) {
            if ([_lbThemeName.text isEqualToString:arrCateTheme[i]]) {
                nSel = i;
            }if (_lbThemeName.text.length==0) {
                nSel = -1;
            }
        }
        NSString* strCate = NSLocalizedStringFromTableInBundle(@"THEME CATEGORIES",@"RPString", g_bundleResorce,nil);
        
        RPBlockUISelectView * selectView = [[RPBlockUISelectView alloc]initWithTitle:strCate
                                                                         clickButton:^(NSInteger indexButton) {
                                                                             
                                                                             if (indexButton > -1) {
                                                                                 _lbThemeName.text = arrCateTheme[indexButton];
                                                                                 _strTagID = arrTagID[indexButton];
                                                                             }
                                                                         }
                                                                            curIndex:nSel
                                                                        selectTitles:arrCateTheme];
        [selectView show];
    } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
        
    }];
    
    
    
}


- (IBAction)OnOK:(id)sender
{
    [self endEditing:YES];
    //    NSLog(@"%d",_tvTitle.text.length);
    //    NSLog(@"%d",_tvText.text.length);
    [SVProgressHUD showWithStatus:@""];
    if (!_strTagID || _strTagID.length == 0)
    {
        [SVProgressHUD showErrorWithStatus:NSLocalizedStringFromTableInBundle(@"The theme cannot be empty",@"RPString", g_bundleResorce,nil)];
    }
    else if (_tvTitle.text.length==0||_tvText.text.length==0)
    {
        [SVProgressHUD showErrorWithStatus:NSLocalizedStringFromTableInBundle(@"The title or content cannot be empty",@"RPString", g_bundleResorce,nil)];
        
    }
    else if (_tvTitle.text.length>20||_tvText.text.length>200)
    {
        [SVProgressHUD showErrorWithStatus:NSLocalizedStringFromTableInBundle(@"The title or content is too long",@"RPString", g_bundleResorce,nil)];
    }
    else
    {
        [[RPSDK defaultInstance]PostLogBook:_storeSelected.strStoreId Title:_tvTitle.text Desc:_tvText.text Images:_arrayImg Tag:_strTagID Success:^(id idResult) {
            [SVProgressHUD dismiss];
            [self.delegate postViewEnd];
        } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
            [SVProgressHUD showErrorWithStatus:NSLocalizedStringFromTableInBundle(@"failure",@"RPString", g_bundleResorce,nil)];
        }];
    }
    
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    UIImage * imgCrop = [RPSDK CropImage:image withSize:CGSizeMake(640, 640)];
    
    UIImageWriteToSavedPhotosAlbum(image,nil,nil,nil);
    [_arrayImg addObject:imgCrop];
    if (_nCurrentImgButtonIndex==0)
    {
        _bPic1=YES;
    }
    if (_nCurrentImgButtonIndex==1)
    {
        _bPic2=YES;
    }
    if (_nCurrentImgButtonIndex==2)
    {
        _bPic3=YES;
    }
    NSArray *array=[[NSArray alloc]initWithObjects:_btPic1,_btPic2,_btPic3, nil];
    NSArray *arrayDelete=[[NSArray alloc]initWithObjects:_btDelete1,_btDelete2,_btDelete3, nil];
    [[array objectAtIndex:_nCurrentImgButtonIndex ] setImage:imgCrop forState:UIControlStateNormal];
    [[arrayDelete objectAtIndex:_nCurrentImgButtonIndex] setHidden:NO];
    
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    
    //    [self performSelectorOnMainThread:@selector(ShowMarkImageCtrl) withObject:self waitUntilDone:NO];
}
-(void)showBigImg:(UIButton*)tag
{
    _button=tag;
    _viewShowImg.frame=CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
    [UIView beginAnimations:nil context:nil];
    _viewShowImg.frame=CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [UIView commitAnimations];
    [self addSubview:_viewShowImg];
    _bShowBig=YES;
    _viewShowImg.ivImg.image=tag.imageView.image;
    
    // 滑动的 Recognizer
    UISwipeGestureRecognizer *leftSwipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleLeftSwipe:)];
    //设置滑动方向
    [leftSwipeRecognizer setDirection:UISwipeGestureRecognizerDirectionLeft];
    [_viewShowImg addGestureRecognizer:leftSwipeRecognizer];
    
    // 滑动的 Recognizer
    UISwipeGestureRecognizer *RightSwipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleRightSwipe:)];
    //设置滑动方向
    [RightSwipeRecognizer setDirection:UISwipeGestureRecognizerDirectionRight];
    [_viewShowImg addGestureRecognizer:RightSwipeRecognizer];
    
}
-(void)handleLeftSwipe:(UISwipeGestureRecognizer*)recognizer
{
    //依次遍历self.view中的所有子视图
    for(id tmpView in _viewFrame.subviews)
    {
        //找到要删除的子视图的对象
        if([tmpView isKindOfClass:[UIButton class]])
        {
            UIButton *myButton = (UIButton *)tmpView;
            if(myButton.tag == _button.tag+1)   //判断是否满足自己要删除的子视图的条件
            {
                _button=myButton;
                _viewShowImg.ivImg.image=myButton.imageView.image;
                break;  //跳出for循环，因为子视图已经找到，无须往下遍历
            }
        }
    }
    
}
-(void)handleRightSwipe:(UISwipeGestureRecognizer*)recognizer
{
    //依次遍历self.view中的所有子视图
    for(id tmpView in _viewFrame.subviews)
    {
        //找到要删除的子视图的对象
        if([tmpView isKindOfClass:[UIButton class]])
        {
            UIButton *myButton = (UIButton *)tmpView;
            if(myButton.tag == _button.tag-1)   //判断是否满足自己要删除的子视图的条件
            {
                _button=myButton;
                _viewShowImg.ivImg.image=myButton.imageView.image;
                break;  //跳出for循环，因为子视图已经找到，无须往下遍历
            }
        }
    }
}
-(IBAction)OnImageButton:(UIButton *)sender
{
    [self endEditing:YES];
    
    if (sender==_btPic1)
    {
        if (_bPic1) {
            [self showBigImg:sender];
            return;
        }
    }
    if (sender==_btPic2)
    {
        if (_bPic2) {
            [self showBigImg:sender];
            return;
        }
    }
    if (sender==_btPic3)
    {
        if (_bPic3) {
            [self showBigImg:sender];
            return;
        }
    }
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

-(IBAction)OnImageDeleteButton:(UIButton *)sender
{
    [self endEditing:YES];
    
    NSString * strDesc = NSLocalizedStringFromTableInBundle(@"Confirm to delete this picture?",@"RPString", g_bundleResorce,nil);
    NSString * strCancel = NSLocalizedStringFromTableInBundle(@"CANCEL",@"RPString", g_bundleResorce,nil);
    NSString * strOK = NSLocalizedStringFromTableInBundle(@"OK",@"RPString", g_bundleResorce,nil);
    
    RPBlockUIAlertView *alertView = [[RPBlockUIAlertView alloc] initWithTitle:nil message:strDesc cancelButtonTitle:strCancel clickButton:^(NSInteger indexButton){
        if (indexButton == 1) {
            NSArray *array=[[NSArray alloc]initWithObjects:_btPic1,_btPic2,_btPic3, nil];
            NSArray *arrayDelete=[[NSArray alloc]initWithObjects:_btDelete1,_btDelete2,_btDelete3, nil];
            [[array objectAtIndex:sender.tag-200] setImage:[UIImage imageNamed:@"icon_addpicture01.png"] forState:UIControlStateNormal];
            [[arrayDelete objectAtIndex:sender.tag-200] setHidden:YES];
            
            int n=0;//记录从第一个Button到点中的Button中有多少张图
            for (int i=0; i<=sender.tag-200; i++)
            {
                if (i==0)
                {
                    if (_bPic1) {
                        n++;
                    }
                }
                if (i==1)
                {
                    if (_bPic2) {
                        n++;
                    }
                }
                if (i==2)
                {
                    if (_bPic3) {
                        n++;
                    }
                }
            }
            [_arrayImg removeObjectAtIndex:n-1];
            if (sender==_btDelete1)
            {
                _bPic1=NO;
            }
            if (sender==_btDelete2)
            {
                _bPic2=NO;
            }
            if (sender==_btDelete3)
            {
                _bPic3=NO;
            }
        }
    } otherButtonTitles:strOK,nil];
    [alertView show];
}


















@end
