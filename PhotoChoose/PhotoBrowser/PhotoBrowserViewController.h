//
//  PhotoBrowserViewController.h
//  PhotoChoose
//
//  Created by wsz on 16/9/22.
//  Copyright © 2016年 wsz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoBrowserViewController : UIViewController

@property(nonatomic, strong)NSArray *imageArray;
@property(nonatomic, assign)int currentIndex;

@end
