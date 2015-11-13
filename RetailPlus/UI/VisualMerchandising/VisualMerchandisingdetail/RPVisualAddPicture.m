//
//  RPVisualAddPicture.m
//  RetailPlus
//
//  Created by zhanglinfeng on 14-6-17.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPVisualAddPicture.h"
#import "SVProgressHUD.h"
#import "RPBlockUIAlertView.h"
extern NSBundle * g_bundleResorce;
@implementation RPVisualAddPicture

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

-(void)showIndex:(int)index
{
    [UIView beginAnimations:nil context:nil];
    _tbPicture.frame=CGRectMake(_tbPicture.frame.origin.x, 64-index*50, _tbPicture.frame.size.width, _tbPicture.frame.size.height);
    [UIView commitAnimations];
}
-(void)BeginEditing
{
    int y=64-_arrayImg.count*50;
    [UIView beginAnimations:nil context:nil];
    _tbPicture.frame=CGRectMake(_tbPicture.frame.origin.x, y, _tbPicture.frame.size.width, _tbPicture.frame.size.height);
    [UIView commitAnimations];
}
-(void)EndEditing
{
    [UIView beginAnimations:nil context:nil];
    _tbPicture.frame=CGRectMake(_tbPicture.frame.origin.x, 64, _tbPicture.frame.size.width, _tbPicture.frame.size.height);
    [UIView commitAnimations];
}
////////////////////////////////////////

-(void)OnCommentChange:(NSString *)comment
{
    _strComment=comment;
    [UIView beginAnimations:nil context:nil];
    _tbPicture.frame=CGRectMake(_tbPicture.frame.origin.x, 64, _tbPicture.frame.size.width, _tbPicture.frame.size.height);
    [UIView commitAnimations];
}
-(void)awakeFromNib
{
    _viewHeader.layer.cornerRadius=10;
    _arrayImg=[[NSMutableArray alloc]init];
}
- (IBAction)OnAddPic:(id)sender
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
    VMImage *vmImage=[[VMImage alloc]init];
    vmImage.imgData=imgCrop;
    [_arrayImg addObject:vmImage];
    
    [_tbPicture reloadData];
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
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
        cell.index=indexPath.row;
        cell.delegate=self;
        cell.vmImage=vmImage;
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
-(void)OnDeleteImg:(VMImage*)vmImg
{
    [_arrayImg removeObject:vmImg];
    [_tbPicture reloadData];
}

- (IBAction)OnOK:(id)sender
{
    [self endEditing:YES];
    NSString * str = NSLocalizedStringFromTableInBundle(@"Submitting...",@"RPString", g_bundleResorce,nil);
    [SVProgressHUD showWithStatus:str];
    [[RPSDK defaultInstance]AddReplyModel:self.visualDisplay.strVisualDisplayId StoreId:self.followStore.strStoreId Type:1 Comments:_strComment ImageArray:_arrayImg Success:^(id idResult) {
        [self.delegate OnEndAdd];
        NSString * str = NSLocalizedStringFromTableInBundle(@"Submit Success",@"RPString", g_bundleResorce,nil);
        [SVProgressHUD showSuccessWithStatus:str];
    } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
        [SVProgressHUD showErrorWithStatus:NSLocalizedStringFromTableInBundle(@"failure",@"RPString", g_bundleResorce,nil)];
    }];
    
}
-(void)clearUI
{
    _strComment=@"";
    [_arrayImg removeAllObjects];
    [_tbPicture reloadData];
    
}
@end
