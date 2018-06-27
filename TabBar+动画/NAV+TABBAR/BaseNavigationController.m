//
//  BaseNavigationController.m
//  MCTabBarDemo
//
//  Created by chh on 2017/12/18.
//  Copyright © 2017年 Mr.C. All rights reserved.
//
#define Theme_NAV_Color   [UIColor cyanColor]
#import "BaseNavigationController.h"


@interface BaseNavigationController ()<UIGestureRecognizerDelegate>

@end

@implementation BaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    //可以设置一些样式
    
     //设置了NO之后View自动下沉navigationBar的高度
     self.navigationBar.translucent = NO;
     //改变左右Item的颜色
     self.navigationBar.tintColor = [UIColor whiteColor];
   
     //改变title的字体样式
     NSDictionary *textAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName: [UIFont fontWithName:@"Arial-ItalicMT" size:18]};
     [self.navigationBar setTitleTextAttributes:textAttributes];
     //改变navBar的背景颜色
     [self.navigationBar setBarTintColor:Theme_NAV_Color];
    
    
}

//重写这个方法，在跳转后自动隐藏tabbar
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([self.viewControllers count] > 0){
        viewController.hidesBottomBarWhenPushed = YES;
        //可以在这里定义返回按钮等
        // 设置返回按钮,只有非根控制器
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"white_back"] style:UIBarButtonItemStylePlain target:self action:@selector(popViewControllerAnimated:)];
        viewController.hidesBottomBarWhenPushed = YES;
        
    }
    //一定要写在最后，要不然无效
    [super pushViewController:viewController animated:animated];
    //处理了push后隐藏底部UITabBar的情况，并解决了iPhonX上push时UITabBar上移的问题。
    CGRect rect = self.tabBarController.tabBar.frame;
    rect.origin.y = [UIScreen mainScreen].bounds.size.height - rect.size.height;
    self.tabBarController.tabBar.frame = rect;
}

- (void)showViewController:(UIViewController *)viewController sender:(id)sender
{
    if (self.childViewControllers.count > 0) { // 非根控制器
        
        self.interactivePopGestureRecognizer.delegate = self;
        // 设置返回按钮,只有非根控制器
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"white_back"] style:UIBarButtonItemStylePlain target:self action:@selector(popViewControllerAnimated:)];
        viewController.hidesBottomBarWhenPushed = YES;
    }
    // 真正在跳转
    [super showViewController:viewController sender:sender];
    //处理了push后隐藏底部UITabBar的情况，并解决了iPhonX上push时UITabBar上移的问题。
    CGRect rect = self.tabBarController.tabBar.frame;
    rect.origin.y = [UIScreen mainScreen].bounds.size.height - rect.size.height;
    self.tabBarController.tabBar.frame = rect;
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if (self.childViewControllers.count == 1) {
        // 表示用户在根控制器界面，就不需要触发滑动手势，
        return NO;
    }
    return YES;
}

@end
