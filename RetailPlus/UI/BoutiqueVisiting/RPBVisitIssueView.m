//
//  RPBVisitIssueView.m
//  RetailPlus
//
//  Created by zhanglinfeng on 14-2-26.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPBVisitIssueView.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImageView+WebCache.h"
#import "MarkViewController.h"
#import "SVProgressHUD.h"
#import "RPBlockUIAlertView.h"
#import "RPBVisitIssueMapCell.h"

extern NSBundle * g_bundleResorce;
@implementation RPBVisitIssueView
@synthesize bModifyMode = _bModifyMode;
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
    sublayer.cornerRadius = 10;
    
    sublayer = _viewTitalFrame.layer;
    sublayer.cornerRadius = 6;
    sublayer.borderColor = [UIColor lightGrayColor].CGColor;
    sublayer.borderWidth = 1;
    
    sublayer = _tvDesc.layer;
    sublayer.cornerRadius = 6;
    sublayer.borderColor = [UIColor lightGrayColor].CGColor;
    sublayer.borderWidth = 1;
    
    sublayer = _tbMap.layer;
    sublayer.cornerRadius = 6;
    sublayer.borderColor = [UIColor lightGrayColor].CGColor;
    sublayer.borderWidth = 1;
    
    _markImageViewController = [[RPMarkImageViewController alloc] initWithNibName:NSStringFromClass([RPMarkImageViewController class]) bundle:g_bundleResorce];
    _markImageViewController.view.frame = CGRectMake(0,self.frame.size.height,self.frame.size.width, self.frame.size.height);
    _markImageViewController.delegate = self;
    [self addSubview:_markImageViewController.view];
    
    _nScrollHeightExShopMap = 350;
    
//    UITapGestureRecognizer *singleTapGR =
//    [[UITapGestureRecognizer alloc] initWithTarget:self
//                                            action:@selector(tapAnywhereToDismissKeyboard:)];
//    [self addGestureRecognizer:singleTapGR];
    
    _bShowCanvasView = NO;
    
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"CustomView" owner:self options:nil];
    _viewShowImg = [array objectAtIndex:2];
    //  _viewShowImg.delegate = self;
    
    _ivTemp = [[UIImageView alloc] init];
    
//    //编辑时触发的事件
//    [_tfTital addTarget:self action:@selector(editingChanged:) forControlEvents:UIControlEventEditingChanged];
}
//-(void)editingChanged:(UITextField *)textfield
//{
//    
//    if (textfield.text.length>RPMAX_TITLE_LENGTH+1)
//    {
//        NSLog(@"textfield.text.length==%i",textfield.text.length);
//        _tfTital.text=[textfield.text substringWithRange:NSMakeRange(0,RPMAX_TITLE_LENGTH)];
//        NSLog(@"%@",_tfTital.text);
//        NSLog(@"_tfTital.text.length==%i",_tfTital.text.length);
//    }
//}
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
    
    NSInteger nCount = 1;
    if (_arrayMap.count > 0)
        nCount = _arrayMap.count;
    
    _scollFrame.contentSize = CGSizeMake(_scollFrame.frame.size.width, _nScrollHeightExShopMap + 42 * nCount);
    _tbMap.frame = CGRectMake(_tbMap.frame.origin.x, _tbMap.frame.origin.y, _tbMap.frame.size.width, 42 * nCount);
    [_tbMap reloadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_arrayMap.count == 0)
        return 1;
    return _arrayMap.count;
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 42;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RPBVisitIssueMapCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RPBVisitIssueMapCell"];
    if (cell == nil)
    {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"RPBVisitIssueMapCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
    }
    
    if (_arrayMap.count == 0) {
        cell.bHasMap = NO;
        cell.bHasLocation = NO;
    }
    else
    {
        cell.bHasMap = YES;
        StoreShopMap * map =  [_arrayMap objectAtIndex:indexPath.row];
        if (_issue.bHasLocation && [map.strId isEqualToString:_issue.strMapId])
            cell.bHasLocation = YES;
        else
            cell.bHasLocation = NO;
        cell.map = map;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (_arrayMap.count > 0) {
       [SVProgressHUD showWithStatus:@""];
        
       StoreShopMap * map =  [_arrayMap objectAtIndex:indexPath.row];
        __block RPBVisitIssueView *blockSelf = self;
        
        BOOL bHasLocation = NO;
        if ([_issue.strMapId isEqualToString:map.strId] && _issue.bHasLocation) {
            bHasLocation = YES;
        }
        _strMapId = map.strId;
        
        [_ivTemp setImageWithURLString:map.strUrl completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
            if (image) {
                blockSelf.markViewController = nil;
                
                blockSelf.markViewController = [[MarkViewController alloc] initWithNibName:nil bundle:nil cadImage:image curentPoint:blockSelf.issue.ptLocation isMarked:bHasLocation];
                blockSelf.markViewController.delegate = blockSelf;
                blockSelf.markViewController.view.frame = CGRectMake(blockSelf.frame.origin.x, blockSelf.frame.origin.y + blockSelf.frame.size.height, blockSelf.frame.size.width, blockSelf.frame.size.height);
                [blockSelf.superview addSubview:blockSelf.markViewController.view];
                
                [UIView beginAnimations:nil context:nil];
                blockSelf.markViewController.view.frame = blockSelf.frame;
                [UIView commitAnimations];
                blockSelf.bShowCanvasView = YES;
            }
            [SVProgressHUD dismiss];
        }];
    }
}

//- (void)locationCanvasTapped:(UITapGestureRecognizer *)tap
//{
//    [self endEditing:YES];
//    
//    if (_imgShopMap == nil) {
//        NSString * str = NSLocalizedStringFromTableInBundle(@"Store layout is empty",@"RPString", g_bundleResorce,nil);
//        [SVProgressHUD showErrorWithStatus:str];
//        return;
//    }
//    
//    _markViewController = nil;
//    
//    _markViewController = [[MarkViewController alloc] initWithNibName:nil bundle:nil cadImage:_imgShopMap curentPoint:self.issue.ptLocation isMarked:self.issue.bHasLocation];
//    _markViewController.delegate = self;
//    _markViewController.view.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y + self.frame.size.height, self.frame.size.width, self.frame.size.height);
//    [self.superview addSubview:_markViewController.view];
//    
//    [UIView beginAnimations:nil context:nil];
//    _markViewController.view.frame = self.frame;
//    [UIView commitAnimations];
//    _bShowCanvasView = YES;
//}

-(void)Markend:(CGPoint)point isMarked:(BOOL)bMarked
{
    [UIView beginAnimations:nil context:nil];
    _markViewController.view.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y + self.frame.size.height, self.frame.size.width, self.frame.size.height);
    [UIView commitAnimations];
    
    if (bMarked || [self.issue.strMapId isEqualToString:_strMapId]) {
        self.issue.strMapId = _strMapId;
        self.issue.ptLocation = point;
        self.issue.bHasLocation = bMarked;
    }
    
    if (self.issue.bHasLocation == NO) {
        self.issue.strMapId = @"";
    }
    
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
    if (_issue.strIssueTitle.length == 0) {
        NSString * strDesc = NSLocalizedStringFromTableInBundle(@"Title is empty",@"RPString", g_bundleResorce,nil);
        [SVProgressHUD showErrorWithStatus:strDesc];
        return;
    }
    
    if (_issue.strIssueDesc.length == 0) {
        NSString * strDesc = NSLocalizedStringFromTableInBundle(@"Commentary is empty",@"RPString", g_bundleResorce,nil);
        [SVProgressHUD showErrorWithStatus:strDesc];
        return;
    }
    
//    if (!_issue.bHasLocation) {
//        NSString * strDesc = NSLocalizedStringFromTableInBundle(@"No location is assigned",@"RPString", g_bundleResorce,nil);
//        [SVProgressHUD showErrorWithStatus:strDesc];
//        return;
//    }
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
    
    if (!_bModifyMode && self.visitItem) {
        if (!self.visitItem.arrayIssue) self.visitItem.arrayIssue = [[NSMutableArray alloc] init];
//        self.visitItem.mark=BVisitMark_YES;
        [self.visitItem.arrayIssue addObject:_issue];
    }
    [self.delegate OnModifyIssueEnd];
}

-(IBAction)OnDeleteIssue:(id)sender
{
    NSString * strDesc = NSLocalizedStringFromTableInBundle(@"Confirm to delete this issue?",@"RPString", g_bundleResorce,nil);
    NSString * strOK = NSLocalizedStringFromTableInBundle(@"OK",@"RPString", g_bundleResorce,nil);
    NSString * strCancel = NSLocalizedStringFromTableInBundle(@"CANCEL",@"RPString", g_bundleResorce,nil);
    
    RPBlockUIAlertView *alertView = [[RPBlockUIAlertView alloc] initWithTitle:nil message:strDesc cancelButtonTitle:strCancel clickButton:^(NSInteger indexButton){
        
        if (indexButton == 1) {
            if (_bModifyMode && self.visitItem){
                [self.visitItem.arrayIssue removeObject:_issue];
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
-(void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length>RPMAX_DESC_LENGTH)
    {
        _tvDesc.text=[textView.text substringWithRange:NSMakeRange(0,RPMAX_DESC_LENGTH)];
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
