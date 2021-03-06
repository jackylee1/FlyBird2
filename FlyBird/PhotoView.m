//
//  PhotoView.m
//  FlyBird
//
//  Created by yosonyuan on 15/6/20.
//  Copyright (c) 2015年 yosonyuan. All rights reserved.
//

#import "PhotoView.h"
#import "FlyBirdTool.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <CoreLocation/CoreLocation.h>
#import <AddressBook/AddressBook.h>

@implementation PhotoView

-(id)initWithFrame:(CGRect)frame{
    
    int width = (SCREEN_WIDTH-40)/2;
    int height = (SCREEN_WIDTH-40)/2;
    self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y+1, width, height)];
    if(self){
        self.layer.borderWidth =1;
        self.layer.borderColor = [GRAY CGColor];
        _field = [[UITextField alloc]initWithFrame:CGRectMake(0,0,width,35)];
        _field.delegate = self;
        _field.placeholder = @" 图片说明,注意先输入";
        _field.font = [UIFont systemFontOfSize:12];
        _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0,35, width, height-35)];
        _imageView.layer.borderColor = [GRAY CGColor];
        _imageView.layer.borderWidth = 1;
        _button = [[UIButton alloc]initWithFrame:CGRectMake((width-40)/2, (height-35-40)/2+35, 40, 40)];
        [_button setBackgroundImage:[UIImage imageNamed:@"photo.png"] forState:UIControlStateNormal];
        [_button addTarget:self action:@selector(showActionSheet) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_button];
        [self addSubview:_imageView];
        [self addSubview:_field];
    }
    return  self;
}
- (void)showActionSheet
{
    //一个菜单列表 选择照相机还是 相册
    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:@"上传图片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"相册", nil];
    [sheet setActionSheetStyle:UIActionSheetStyleBlackOpaque];
    [sheet showInView:[self window]];
}

//菜单列表按钮的触发方法
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {//第一个按钮
        //照相机
        [self addOfCamera];
    }
    else if(buttonIndex == 1)
    {
        //相册
        [self addOfAlbum];
    }else{
        [self cancel];
    }
}

- (void) addOfAlbum
{
    //for iphone
    UIImagePickerController *pickerImage = [[UIImagePickerController alloc] init];
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        pickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        //pickerImage.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        pickerImage.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:pickerImage.sourceType];
        
    }
    pickerImage.delegate = self;
    pickerImage.allowsEditing = NO;
    //[self.controller presentModalViewController:pickerImage animated:YES];
    [self.controller presentViewController:pickerImage animated:YES completion:nil];
}

- (void) addOfCamera
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];//初始化
    picker.delegate = self;
    picker.allowsEditing = NO;//设置可编辑
    picker.sourceType = sourceType;
    [self.controller presentViewController:picker animated:YES completion:nil];
}

-(void)cancel{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];//初始化
    //[picker dismissModalViewControllerAnimated:YES];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

//把图片添加到当前view中
- (void)saveImage:(UIImage *)image {
    //保存
    _imageView.image = image;
}
#pragma mark –
#pragma mark Camera View Delegate Methods
//点击相册中的图片或者照相机照完后点击use 后触发的方法
- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *image;
    if (picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary){//如果打开相册
        [picker dismissViewControllerAnimated:YES completion:nil];//关掉相册
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    else{//照相机
        [picker dismissViewControllerAnimated:YES completion:nil];//关掉照相机
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    //把选中的图片添加到界面中
    [self performSelector:@selector(saveImage:)
               withObject:image
               afterDelay:0.5];
//    NSURL *videoUrl = (NSURL *)[info objectForKey:UIImagePickerControllerReferenceURL];
//    NSString *moviePath = [videoUrl path];
//    
//    if ( UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(moviePath) ) {
//        
//        ALAssetsLibrary *assetLibrary = [[ALAssetsLibrary alloc] init];
//        
//        [assetLibrary assetForURL:[info objectForKey:UIImagePickerControllerReferenceURL] resultBlock:^(ALAsset *asset) {
//            
//            CLLocation *currLocation = [asset valueForProperty:ALAssetPropertyLocation];
//            NSLog(@"Location Meta: %@", currLocation);
//            CLGeocoder * geo = [[CLGeocoder alloc]init];
//            [geo reverseGeocodeLocation:currLocation completionHandler:^(NSArray *placemarks, NSError *error) {
//                if([placemarks count]>0){
//                    CLPlacemark *place = placemarks[0];
//                    NSDictionary *addressDic = place.addressDictionary;
//                    NSString *state = [addressDic objectForKey:(NSString*)kABPersonAddressStateKey];
//                    NSString *city = [addressDic objectForKey:(NSString *)kABPersonAddressCityKey];
//                    NSString *street = [addressDic objectForKey:(NSString *)kABPersonAddressStreetKey];
//                    NSLog(@"%@%@%@",state,city,street);
//                }
//            }];
//
//            
//        } failureBlock:^(NSError *error) {
//            NSLog(@"Video Date Error: %@", error);
//        }];
//        
//    }
    _imageData = UIImageJPEGRepresentation(image, 0.3);
    [self upload];
}
//点击cancel调用的方法
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)upload{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setObject:[FlyBirdTool getValue:@"applyId"] forKey:@"oid"];
    [dic setObject:_type forKey:@"type"];
    [dic setObject:_detail forKey:@"detail"];
    [dic setObject:_field.text forKey:@"remark"];
    HandlerBlock handler = ^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if(error == nil){
            NSString *text = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"%@",text);
            NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
            [MBProgressHUD hideHUDForView:self animated:YES];
        }else{
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"内部服务器错误，请检查网络连接" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alert show];
        }
        [MBProgressHUD hideHUDForView:self animated:YES];
    };
    NSURLSessionConfiguration *defaultConf = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:defaultConf delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURL *nsUrl = [FlyBirdTool stringToUrl:@"img/submitimg/"];
    NSMutableURLRequest *urlReq = [NSMutableURLRequest requestWithURL:nsUrl];
    
    [urlReq addValue:@"image/jpeg" forHTTPHeaderField:@"Content-Type"];
    [urlReq addValue:@"text/html" forHTTPHeaderField:@"Accept"];
    NSString *remark = [dic objectForKey:@"remark"];
    [urlReq addValue: [remark stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forHTTPHeaderField:@"remark"];
    [urlReq addValue:[dic objectForKey:@"type"] forHTTPHeaderField:@"type"];
    [urlReq addValue:[dic objectForKey:@"detail"] forHTTPHeaderField:@"detail"];
    [urlReq addValue:[dic objectForKey:@"oid"] forHTTPHeaderField:@"oid"];
    [urlReq addValue:@"add" forHTTPHeaderField:@"action"];
    [urlReq setCachePolicy:NSURLRequestReloadIgnoringCacheData];
    [urlReq setTimeoutInterval:20];
    [urlReq setHTTPMethod:@"POST"];
    NSURLSessionUploadTask *upLoadTask = [session uploadTaskWithRequest:urlReq fromData:_imageData completionHandler:handler];
    [upLoadTask resume];
    [MBProgressHUD showHUDAddedTo:self animated:YES];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(void)setButtonNo{
    [_button setEnabled:NO];
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if(_flag){
        return NO;
    }
    else
        return YES;
}
@end
