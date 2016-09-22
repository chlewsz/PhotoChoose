//
//  ViewController.m
//  PhotoChoose
//
//  Created by wsz on 16/9/22.
//  Copyright © 2016年 wsz. All rights reserved.
//

#import "ViewController.h"
#import "SinglePhotoChooseViewController.h"
#import "MultiPhotoChooseViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"图片选择";
    
    UIButton *singleChoiceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    singleChoiceBtn.tag = 0;
    singleChoiceBtn.frame = CGRectMake(10, 64 + 20, 100, 44);
    singleChoiceBtn.backgroundColor = [UIColor redColor];
    [singleChoiceBtn setTitle:@"单选" forState:UIControlStateNormal];
    [singleChoiceBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:singleChoiceBtn];
    
    UIButton *multiChoiceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    multiChoiceBtn.tag = 1;
    multiChoiceBtn.frame = CGRectMake(120, 64 + 20, 100, 44);
    multiChoiceBtn.backgroundColor = [UIColor redColor];
    [multiChoiceBtn setTitle:@"多选" forState:UIControlStateNormal];
    [multiChoiceBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:multiChoiceBtn];
}

- (void)btnClick:(UIButton *)sender
{
    int tag = (int)sender.tag;
    if (0 == tag)
    {
        [self.navigationController pushViewController:[SinglePhotoChooseViewController new] animated:YES];
    }
    else if (1 == tag)
    {
        [self.navigationController pushViewController:[MultiPhotoChooseViewController new] animated:YES];
    }
}


@end
