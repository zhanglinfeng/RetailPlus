//
//  RPAddExhibitView.m
//  RetailPlus
//
//  Created by zhanglinfeng on 14-6-16.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPAddExhibitView.h"


#import "SVProgressHUD.h"
#import "RPBlockUIAlertView.h"
#import "GTMBase64.h"
#import "UIImageView+WebCache.h"
//#import "RPBlockUISelectView.h"
extern NSBundle * g_bundleResorce;
@implementation RPAddExhibitView

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
    _viewFrame.layer.cornerRadius=10;
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(locationTapped:)];
    [self addGestureRecognizer:tap];
    tap.cancelsTouchesInView=NO;//为yes只响应优先级最高的事件，Button高于手势，textfield高于手势，textview高于手势，手势高于tableview。为no同时都响应，默认为yes
    _arrayImg=[[NSMutableArray alloc]init];
    
}
- (void)locationTapped:(UITapGestureRecognizer *)tap
{
    [self endEditing:YES];
}
#pragma mark -UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _arrayImg.count+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VMImage *vmImage=nil;
    if (indexPath.row<_arrayImg.count) {
        vmImage=[_arrayImg objectAtIndex:indexPath.row];
    }
    
    if (indexPath.row == _arrayImg.count)
    {
        RPExhibitMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RPExhibitMessageCell"];
        if (cell == nil)
        {
            NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"RPExhibitCell" owner:self options:nil];
            cell = [array objectAtIndex:1];
        }
        cell.tvComment.text=_strComment;
        if (_strComment.length>0) {
            cell.tfComment.hidden=YES;
        }
        else
        {
            cell.tfComment.hidden=NO;
        }
//        cell.tvComment.placeholder=NSLocalizedStringFromTableInBundle(@"Input Message",@"RPString", g_bundleResorce,nil);
        cell.delegate=self;
        return cell;
    }
    else
    {
        RPExhibitCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RPExhibitCell"];
        if (cell == nil)
        {
            NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"RPExhibitCell" owner:self options:nil];
            cell = [array objectAtIndex:0];
        }
        cell.delegate=self;
        cell.vmImage=vmImage;
        cell.index=indexPath.row;
        return cell;
    }
    
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==_arrayImg.count) {
        return 50;
    }
    else
    {
        return 66;
    }
    
}

#pragma mark -UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
- (IBAction)OnSelectLocation:(id)sender
{
//    _viewLocation.frame=CGRectMake(self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
//    [self addSubview:_viewLocation];
//    [UIView beginAnimations:nil context:nil];
//    _viewLocation.frame=CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
//    [UIView commitAnimations];
//    _bLocationView=YES;
    
    [self endEditing:YES];
    _markViewController = nil;
   UIImage *img=[RPSDK loadImageFromURL:self.followStore.strShopMap];
    if (img)
    {
        _markViewController = [[MarkViewController alloc] initWithNibName:nil bundle:nil cadImage:img curentPoint:CGPointMake(_x, _y) isMarked:YES];
        _markViewController.delegate = self;
        _markViewController.view.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y + self.frame.size.height, self.frame.size.width, self.frame.size.height);
        [self.superview addSubview:_markViewController.view];
        [UIView beginAnimations:nil context:nil];
        _markViewController.view.frame = self.frame;
        [UIView commitAnimations];
        _bLocationView = YES;
//        _ivLocated.hidden=YES;
    }
    
}
-(void)Markend:(CGPoint)point isMarked:(BOOL)bMarked
{
    [UIView beginAnimations:nil context:nil];
    _markViewController.view.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y + self.frame.size.height, self.frame.size.width, self.frame.size.height);
    [UIView commitAnimations];
    
//    self.issue.ptLocation = point;
//    self.issue.bHasLocation = bMarked;
    _x=point.x;
    _y=point.y;
    _bLocationView = NO;
    if (_x==0&&_y==0)
    {
        _ivLocated.hidden=YES;
        _lbLocate.text=NSLocalizedStringFromTableInBundle(@"LOCATE",@"RPString", g_bundleResorce,nil);
    }
    else
    {
        _ivLocated.hidden=NO;
        _lbLocate.text=NSLocalizedStringFromTableInBundle(@"LOCATED",@"RPString", g_bundleResorce,nil);
    }
    
   
}
- (IBAction)OnAddPicture:(id)sender
{
    [self endEditing:YES];
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
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    UIImage * imgCrop = [RPSDK CropImage:image withSize:CGSizeMake(640, 640)];
    
    UIImageWriteToSavedPhotosAlbum(image,nil,nil,nil);
//    NSString * strImage =  [GTMBase64 stringByEncodingData:UIImageJPEGRepresentation(imgCrop, 0.5)];
    VMImage *vmImage=[[VMImage alloc]init];
    vmImage.imgData=imgCrop;
    [_arrayImg addObject:vmImage];

    [_tbPicture reloadData];
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

-(void)OnDeleteImg:(VMImage*)vmImg
{
    [_arrayImg removeObject:vmImg];
    [_tbPicture reloadData];
}
-(void)OnCommentChange:(NSString *)comment
{
    _strComment=comment;
    [UIView beginAnimations:nil context:nil];
    _tbPicture.frame=CGRectMake(_tbPicture.frame.origin.x, 106, _tbPicture.frame.size.width, _tbPicture.frame.size.height);
    [UIView commitAnimations];
}
-(void)showIndex:(int)index
{
//    NSIndexPath *idxPath = [NSIndexPath indexPathForRow:index inSection:0];
//    [_tbPicture scrollToRowAtIndexPath:idxPath
//                         atScrollPosition:UITableViewScrollPositionTop
//                                 animated:YES];
    [UIView beginAnimations:nil context:nil];
    _tbPicture.frame=CGRectMake(_tbPicture.frame.origin.x, 106-index*50, _tbPicture.frame.size.width, _tbPicture.frame.size.height);
    [UIView commitAnimations];
}
-(void)EndEditing
{
    [UIView beginAnimations:nil context:nil];
    _tbPicture.frame=CGRectMake(_tbPicture.frame.origin.x, 106, _tbPicture.frame.size.width, _tbPicture.frame.size.height);
    [UIView commitAnimations];
}
-(void)BeginEditing
{
    int y=106-_arrayImg.count*50;
    [UIView beginAnimations:nil context:nil];
    _tbPicture.frame=CGRectMake(_tbPicture.frame.origin.x, y, _tbPicture.frame.size.width, _tbPicture.frame.size.height);
    [UIView commitAnimations];
//    NSLog(@"%d",_arrayImg.count);
//    NSLog(@"%f",_tbPicture.frame.origin.y);
//    NSLog(@"%d",106-_arrayImg.count*50);
}
- (IBAction)OnOk:(id)sender
{
    [self endEditing:YES];
    
//    [[RPSDK defaultInstance]DelFollowStore:_arrayDeleteStore Success:^(id idResult) {
//        [self loadData];
//    } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
//        
//    }];
    
    
    if (_arrayImg.count<1)
    {
        [SVProgressHUD showErrorWithStatus:NSLocalizedStringFromTableInBundle(@"At least need one picture",@"RPString", g_bundleResorce,nil)];
        return;
    }
    
    
    
    if (_tfTitle.text.length<1)
    {
        //        [SVProgressHUD showErrorWithStatus:NSLocalizedStringFromTableInBundle(@"Title cannot be empty",@"RPString", g_bundleResorce,nil)];
        //        return;
        //        _tfTitle.text=NSLocalizedStringFromTableInBundle(@"New Merchandising",@"RPString", g_bundleResorce,nil);
        
        
        NSString * strDesc = NSLocalizedStringFromTableInBundle(@"Use the default title:NEW VM SHOW?",@"RPString", g_bundleResorce,nil);
        NSString * strOK = NSLocalizedStringFromTableInBundle(@"OK",@"RPString", g_bundleResorce,nil);
        NSString * strCancel = NSLocalizedStringFromTableInBundle(@"NO.I WILL INPUT A NEW TITLE",@"RPString", g_bundleResorce,nil);
        
        RPBlockUIAlertView *alertView = [[RPBlockUIAlertView alloc] initWithTitle:nil message:strDesc cancelButtonTitle:strCancel clickButton:^(NSInteger indexButton){
            if (indexButton == 1) {
                _tfTitle.text=NSLocalizedStringFromTableInBundle(@"NEW VM SHOW",@"RPString", g_bundleResorce,nil);
                NSString * str = NSLocalizedStringFromTableInBundle(@"Submitting...",@"RPString", g_bundleResorce,nil);
                [SVProgressHUD showWithStatus:str];
                [[RPSDK defaultInstance]AddVisualDisplayModel:self.followStore.strStoreId Title:_tfTitle.text Comment:_strComment X:_x Y:_y Images:_arrayImg Success:^(id idResult) {
                    [self.delegate OnEndAdd];
                    NSString * str = NSLocalizedStringFromTableInBundle(@"Submit Success",@"RPString", g_bundleResorce,nil);
                    [SVProgressHUD showSuccessWithStatus:str];
                    
                } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
                    [SVProgressHUD showErrorWithStatus:NSLocalizedStringFromTableInBundle(@"failure",@"RPString", g_bundleResorce,nil)];
                }];
            }
            else
            {
                [_tfTitle becomeFirstResponder];
            }
        } otherButtonTitles:strOK,nil];
        [alertView show];
        
        
    }
    else
    {
        NSString * str = NSLocalizedStringFromTableInBundle(@"Submitting...",@"RPString", g_bundleResorce,nil);
        [SVProgressHUD showWithStatus:str];
        [[RPSDK defaultInstance]AddVisualDisplayModel:self.followStore.strStoreId Title:_tfTitle.text Comment:_strComment X:_x Y:_y Images:_arrayImg Success:^(id idResult) {
            [self.delegate OnEndAdd];
            NSString * str = NSLocalizedStringFromTableInBundle(@"Submit Success",@"RPString", g_bundleResorce,nil);
            [SVProgressHUD showSuccessWithStatus:str];
            
        } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
            [SVProgressHUD showErrorWithStatus:NSLocalizedStringFromTableInBundle(@"failure",@"RPString", g_bundleResorce,nil)];
        }];
    }
    
    
    
}
-(void)dismissView:(UIView *)view
{
    [UIView beginAnimations:nil context:nil];
    view.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
    [UIView commitAnimations];
    [view endEditing:YES];
}
-(BOOL)OnBack
{
    if (_bLocationView)
    {
        [UIView beginAnimations:nil context:nil];
        _markViewController.view.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y + self.frame.size.height, self.frame.size.width, self.frame.size.height);
        [UIView commitAnimations];
        _bLocationView=NO;
        return NO;
    }
    return YES;
}
-(void)clearUI
{
    [_arrayImg removeAllObjects];
    _tfTitle.text=@"";
    _strComment=@"";
    _x=0;
    _y=0;
    _ivLocated.hidden=YES;
    _lbLocate.text=NSLocalizedStringFromTableInBundle(@"LOCATE",@"RPString", g_bundleResorce,nil);
    [_tbPicture reloadData];
}
@end
