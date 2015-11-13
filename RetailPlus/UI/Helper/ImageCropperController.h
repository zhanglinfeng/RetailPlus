//
//  ImageCropperController.h
//  DressMemo
//
//  Created by 董 林 on 12-11-28.
//
//

#import <UIKit/UIKit.h>
#import "KICropImageView.h"

@protocol ImageCropperControllerDelegate
-(void)OnSave:(UIImage *)image;
-(void)OnBack;
@end

@interface ImageCropperController : UIViewController
{
    IBOutlet UIView * _frameview;
    IBOutlet UIView * _toolbarFrameView;
    
    IBOutlet UIButton * _btnBack;
    IBOutlet UIButton * _btnConfirm;
    IBOutlet UIImageView * _logoView;
    IBOutlet UIImageView * _backPicView;
    
    UIImage         * _image;
    KICropImageView  * _imageCropper;
}

@property (nonatomic,retain) UIImage * image;
@property (nonatomic,assign) id<ImageCropperControllerDelegate> delegate;

-(IBAction)OnSave:(id)sender;
-(IBAction)OnBack:(id)sender;

@end
