//
//  SinglePhotoChooseViewController.m
//  PhotoChoose
//
//  Created by wsz on 16/9/22.
//  Copyright © 2016年 wsz. All rights reserved.
//

#import "SinglePhotoChooseViewController.h"
#import <Photos/Photos.h>

@interface SinglePhotoChooseViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property(nonatomic, strong)UIImageView *imageView;
@property(nonatomic, strong)UIImagePickerController *imagePickerController;

@end

@implementation SinglePhotoChooseViewController


- (UIImageView *)imageView
{
    if (_imageView == nil)
    {
        _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 200, 200)];
        _imageView.center = CGPointMake(self.view.center.x, 64 + 20 + 100);
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.layer.masksToBounds = YES;
        _imageView.layer.borderColor = [UIColor grayColor].CGColor;
        _imageView.layer.borderWidth = 1;
    }
    return _imageView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"图片单选";
    
    [self.view addSubview:self.imageView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 200, 44);
    button.center = CGPointMake(self.view.center.x, CGRectGetMaxY(self.imageView.frame) + 20 + 22);
    [button setTitle:@"图片选择" forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor redColor]];
    [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)buttonClick
{
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"方式选择" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    __weak __typeof(self)weakSelf = self;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [weakSelf openImagePickerController:0];
            
        }];
        [controller addAction:cameraAction];
    }
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"图库" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [weakSelf openImagePickerController:1];
        }];
        [controller addAction:photoAction];
    }
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum])
    {
        UIAlertAction *albumAction = [UIAlertAction actionWithTitle:@"相片库" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [weakSelf openImagePickerController:2];
        }];
        [controller addAction:albumAction];
    }
    
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)openImagePickerController:(int) tag
{
    _imagePickerController = [UIImagePickerController new];
    _imagePickerController.delegate = self;
    
//    _imagePickerController.allowsEditing = YES;//是否允许编辑
    
    if (0 == tag)
    {
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (status == AVAuthorizationStatusDenied || status == AVAuthorizationStatusRestricted)
        {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请在设置->隐私->相机中为本应用授权" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [alert dismissViewControllerAnimated:YES completion:nil];
            }];
            [alert addAction:cancelAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
        else
        {
            _imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:_imagePickerController animated:YES completion:nil];
        }
    }
    else
    {
        //授权检查
        PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
        if (status == PHAuthorizationStatusRestricted || status == PHAuthorizationStatusDenied)
        {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请在设置->隐私->照片中为本应用授权" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [alert dismissViewControllerAnimated:YES completion:nil];
            }];
            [alert addAction:cancelAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
        else
        {
            if (1 == tag)
            {
                _imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            }
            else if (2 == tag)
            {
                _imagePickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            }
            [self presentViewController:_imagePickerController animated:YES completion:nil];
        }
    }
}

#pragma mark -- UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    //获取照片的原图
        UIImage *originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    
//    UIImage *editImage = [info objectForKey:UIImagePickerControllerEditedImage];//获取编辑后的图片
    
    
    if (_imagePickerController.sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        //如果是拍照的照片，则需要手动保存到本地，系统不会自动保存拍照成功后的照片
//        UIImageWriteToSavedPhotosAlbum(editImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        UIImageWriteToSavedPhotosAlbum(originalImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
    self.imageView.image = originalImage;
    
    [_imagePickerController dismissViewControllerAnimated:YES completion:nil];
}

//保存照片成功后的回调
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error
  contextInfo:(void *)contextInfo
{
    NSLog(@"saved..");
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [_imagePickerController dismissViewControllerAnimated:YES completion:nil];
}



@end
