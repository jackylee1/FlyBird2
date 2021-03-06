//
//  NewApplyOtherViewController.m
//  FlyBird
//
//  Created by yosonyuan on 15/6/21.
//  Copyright (c) 2015年 yosonyuan. All rights reserved.
//

#import "NewApplyOtherViewController.h"
#import "PhotoView.h"
#import "FlyBirdTool.h"
#import "OtherInfoModel.h"
#import "NewApplyCarViewController.h"
#import "UIImageView+WebCache.h"
#import "NewApplyRemarkViewController.h"

@interface NewApplyOtherViewController ()<UITextViewDelegate>{
    NSString *_flag;
    UIScrollView *_scrollView;
    UITextView *_otherInfo;
    
    PhotoView *_photo1;
    PhotoView *_photo2;
}

@end

@implementation NewApplyOtherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    SETBACKG;
    _flag = [FlyBirdTool getValue:@"flag"];
    if(![_flag isEqualToString:@"add"]){
        [self queryInfo];
    }
    [self addNavBar];
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 67, SCREEN_WIDTH, SCREEN_HEIGHT-67)];
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, 1200);
    _scrollView.backgroundColor =[UIColor whiteColor];
    [self.view addSubview:_scrollView];
    [self addHouseInfo];
    [self addPhoto];
}
- (void)addHouseInfo{
    UIView *info = [FlyBirdTool getTitleLable:CGPointMake(0, 0) setTitle:@"其他抵押物说明"];
    [_scrollView addSubview:info];
    _otherInfo = [[UITextView alloc]initWithFrame:CGRectMake(0, 35, SCREEN_WIDTH, 100)];
    _otherInfo.delegate=self;
    //_otherInfo.backgroundColor = YELLOW;
    [_scrollView addSubview:_otherInfo];
    UIView *jiafang = [FlyBirdTool getTitleLable:CGPointMake(0, 35+100) setTitle:@"其他抵押物照片"];
    [_scrollView addSubview:jiafang];
}

-(void) addNavBar{
    UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 23, SCREEN_WIDTH, 44)];
    navBar.barTintColor = YELLOW;
    UINavigationItem *item = [[UINavigationItem alloc]initWithTitle:@"其他抵押信息(4/5)"];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithTitle:@"上一步" style:UIBarButtonItemStylePlain target:self action:@selector(clickLeft)];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(clickRight)];
    leftButton.tintColor = [UIColor blackColor];
    rightButton.tintColor = [UIColor blackColor];
    [item setLeftBarButtonItem:leftButton animated:YES];
    [item setRightBarButtonItem:rightButton animated:YES];
    [navBar pushNavigationItem:item animated:YES];
    [self.view addSubview:navBar];
}

-(void)addPhoto{
    _photo1 = [[PhotoView alloc]initWithFrame:CGRectMake(10, 35*2+100+10, 0, 0)];
    _photo1.controller = self;
    _photo1.type = @"others";
    _photo1.detail = @"otherimgs";
    [_scrollView addSubview:_photo1];
    _photo2 = [[PhotoView alloc]initWithFrame:CGRectMake(10+(SCREEN_WIDTH-40)/2+20, 2*35+100+10, 0, 0)];
    _photo2.type = @"others";
    _photo2.detail = @"otherimgs2";
    _photo2.controller = self;
    [_scrollView addSubview:_photo2];
    
}

-(void)clickLeft{
//    if([[FlyBirdTool getValue:@"flag"]isEqualToString:@"add"])
//        [FlyBirdTool setKey:@"flag" Value:@"modify"];
    NewApplyCarViewController *controller = [[NewApplyCarViewController alloc]init];
    controller.modalTransitionStyle=UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:controller animated:YES completion:nil];
}
-(void)clickRight{
    if(![_flag isEqualToString:@"check"]){
        [self request];
    }else{
        NewApplyRemarkViewController *controller = [[NewApplyRemarkViewController alloc]init];
        controller.modalTransitionStyle=UIModalTransitionStyleFlipHorizontal;
        [self presentViewController:controller animated:YES completion:nil];
    }
}
-(void) request{
    NSString *applyId=[FlyBirdTool getValue:@"applyId"];
    NSString *param = [NSString stringWithFormat:@"id=%@%@&description=%@",applyId,[FlyBirdTool getTsTK],_otherInfo.text];
    NSLog(@"parma:%@",param);
    HandlerBlock handler = ^(NSData *data, NSURLResponse *response, NSError *error) {
        if(error == nil){
            NSString *text = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"%@",text);
            NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
            if([[[dic objectForKey:@"res"] stringValue] isEqualToString:@"200"]){
                NewApplyRemarkViewController *controller = [[NewApplyRemarkViewController alloc]init];
                controller.modalTransitionStyle=UIModalTransitionStyleFlipHorizontal;
                [self presentViewController:controller animated:YES completion:nil];
            }else{
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"错误，请重新提交" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                [alert show];
            }
            
        }else{
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"内部服务器错误，请检查网络连接" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alert show];
        }
    };
    [FlyBirdTool httpPost:@"api/submitother/" param:param completeHander:handler];
}


-(void)queryInfo{
    NSString *param = [NSString stringWithFormat:@"id=%@&type=%@%@",[FlyBirdTool getValue:@"applyId"],@"others",[FlyBirdTool getTsTK]];
    NSLog(@"parma:%@",param);
    HandlerBlock handler = ^(NSData *data, NSURLResponse *response, NSError *error) {
        if(error == nil){
            NSString *text = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"%@",text);
            if(![text isEqualToString:@"[]"]){
                NSArray * array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
                
                OtherInfoModel*model = [[OtherInfoModel alloc]init];
                [model parseResponse:array[0]];
                [self setData:model];
            }else
                [self setData:nil];
        }else{
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"内部服务器错误，请检查网络连接" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alert show];
        }
    };
    [FlyBirdTool httpPost:@"api/queryinfo/" param:param completeHander:handler];
}

-(void)setData:(OtherInfoModel *)model{
    if(model !=nil){
    _otherInfo.text = model.otherInfo;
    _photo1.field.text=model.photoI1;
    [_photo1.imageView sd_setImageWithURL:[NSURL URLWithString:model.photo1]];
    _photo2.field.text=model.photoI2;
    [_photo2.imageView sd_setImageWithURL:[NSURL URLWithString:model.photo2]];
    }
    if([_flag isEqualToString:@"check"]){
        _photo1.flag = YES;
        [_photo1 setButtonNo];
        _photo2.flag = YES;
        [_photo2 setButtonNo];
        
    }
    
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if([text isEqualToString:@"\n"]){
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    if([_flag isEqualToString:@"check"]){
        return NO;
    }else
        return YES;
}


@end
