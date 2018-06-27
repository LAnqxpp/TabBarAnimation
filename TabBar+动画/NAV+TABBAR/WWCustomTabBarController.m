//
//  WWCustomTabBarController.m
//  CBDVipEquipment
//
//  Created by cheBaidu on 2018/5/29.
//  Copyright © 2018年 车佰度. All rights reserved.
//

#import "WWCustomTabBarController.h"
#import "ViewController.h"
#import "QViewController.h"
#import "QQViewController.h"
#import "QQQViewController.h"
#import "QQQQViewController.h"
#import "MCTabBar.h"
#import <ImageIO/ImageIO.h>
#import "BaseNavigationController.h"
#define SafeAreaBottomHeight ([UIScreen mainScreen].bounds.size.height == 812.0 ? 63 : 49)

static NSString *rotationAnimationKey = @"TabBarButtonTransformRotationAnimationKey";
static NSString *flipAnimationKey = @"TabBarButtonTransformFlipAnimationKey";
static NSString *scaleAnimationKey = @"TabBarButtonTransformScaleAnimationKey";
static NSString *giffAnimationKey = @"TabBarButtonTransformGiffAnimationKey";


@interface WWCustomTabBarController ()<UITabBarControllerDelegate>

/**
 旋转动画
 */
@property (nonatomic, strong) CABasicAnimation *rotationAnimation;

/**
 立体翻转
 */
@property (nonatomic, strong) CABasicAnimation *flipAnimation;
/**
 缩放翻转
 */
@property (nonatomic, strong) CABasicAnimation *scaleAnimation;

/**
 添加帧动画
 */
@property (nonatomic, strong) CAKeyframeAnimation *giffAnimation;

@property (nonatomic, strong) MCTabBar *mcTabbar;
@property (nonatomic, assign) NSUInteger selectItem;//选中的item
@end

@implementation WWCustomTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBar.barTintColor = [UIColor whiteColor];
    [self customTabBarTabBarButton];
    self.selectItem = 0; //默认选中第一个
    self.delegate = self;
    [self setupControllers];
    [self customTabBarTabBarArticle];
    self.tabBar.shadowImage = [[UIImage alloc]init];
    self.tabBar.backgroundImage = [[UIImage alloc]init];
 

    // Do any additional setup after loading the view.
}
- (void)customTabBarTabBarButton {
    _mcTabbar = [[MCTabBar alloc] init];
    [_mcTabbar.centerBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    //选中时的颜色
//    _mcTabbar.tintColor = [UIColor colorWithRed:27.0/255.0 green:118.0/255.0 blue:208/255.0 alpha:1];
    //透明设置为NO，显示白色，view的高度到tabbar顶部截止，YES的话到底部
    _mcTabbar.translucent = NO;
    //利用KVC 将自己的tabbar赋给系统tabBar
    [self setValue:_mcTabbar forKeyPath:@"tabBar"];
}

- (void)customTabBarTabBarArticle{
 
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, SafeAreaBottomHeight)];
    bgView.backgroundColor = [UIColor colorWithRed:42.0/255.0 green:46.0/255.0 blue:67/255.0 alpha:1];
    [self.tabBar insertSubview:bgView atIndex:0];
    self.tabBar.opaque = YES;
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:bgView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = bgView.bounds;
    maskLayer.path = maskPath.CGPath;
    bgView.layer.mask = maskLayer;
}


- (void)setupControllers
{
    [self setupController:[[ViewController alloc]init] image:@"shouye-hui" selectedImage:@"shouye-lan" title:@"首页"];
    
    [self setupController:[[QViewController alloc]init] image:@"yongchebaogao-hui" selectedImage:@"yongchebaogao-lan" title:@"大数据"];
    
    [self setupController:[[QQViewController alloc]init] image:@"" selectedImage:@"" title:@""];
    
    [self setupController:[[QQQViewController alloc]init] image:@"quanzi-hui" selectedImage:@"quanzi-lan" title:@"圈子"];
    
    [self setupController:[[QQQQViewController alloc]init] image:@"wode-hui" selectedImage:@"wode-lan" title:@"我的"];

 
}

- (void)buttonAction:(UIButton *)button{
    NSLog(@"-----wo tab bar ");
    self.selectedIndex = 2;//关联中间按钮
//    if (self.selectItem != 2){
        [self rotationAnimations];
//    }
    self.selectItem = 2;
}
//tabbar选择时的代理
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    NSLog(@"wo tab bar ");
    if (tabBarController.selectedIndex == 2){//选中中间的按钮
        if (self.selectItem != 2){
            [self rotationAnimations];
        }
    }else {
        [_mcTabbar.centerBtn.layer removeAllAnimations];
    }
    self.selectItem = tabBarController.selectedIndex;
}

//抖动+放大动画
- (void)rotationAnimations{
    CAAnimationGroup *group = [CAAnimationGroup animation];
    
    CABasicAnimation* shake = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    //设置抖动幅度
    shake.fromValue = [NSNumber numberWithFloat:+0.1];
    shake.toValue = [NSNumber numberWithFloat:-0.1];
    shake.duration = 0.1;
    shake.autoreverses = YES; //是否重复
    shake.repeatCount = 4;
    
    CABasicAnimation *scaleTwo=[CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleTwo.fromValue=[NSNumber numberWithFloat:1.1];
    scaleTwo.toValue=[NSNumber numberWithFloat:1.0];
    scaleTwo.duration=0.5;
    scaleTwo.autoreverses=NO;
    scaleTwo.repeatCount=0;
    scaleTwo.removedOnCompletion=NO;
    scaleTwo.fillMode=kCAFillModeForwards;
    
    group.animations = @[scaleTwo,shake];
    group.removedOnCompletion = NO;
    group.duration             = 1.0;
    group.timingFunction      = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    group.repeatCount         = 1;//FLT_MAX;  //"forever";
    group.fillMode             = kCAFillModeForwards;
    
    [_mcTabbar.centerBtn.imageView.layer addAnimation:group forKey:@"key"];
}

//设置控制器
-(void)setupController:(UIViewController *)childVc
                 image:(NSString *)image
         selectedImage:(NSString *)selectedImage
                 title:(NSString *)title {
    
    UIViewController *viewVc = childVc;
    if (image.length) viewVc.tabBarItem.image = [[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    if (selectedImage.length) viewVc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    viewVc.tabBarItem.title = title;
    [viewVc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:28.0/255.0 green:172.0/255.0 blue:255/255.0 alpha:1],NSFontAttributeName:[UIFont systemFontOfSize:11]} forState:UIControlStateSelected];
    [viewVc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:11]} forState:UIControlStateNormal];
    BaseNavigationController *navi = [[BaseNavigationController alloc] initWithRootViewController:viewVc];
    [self addChildViewController:navi];
}

#pragma mark - UITabBarControllerDelegate
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    
    UIViewController *nowVc = viewController.childViewControllers.firstObject;
    NSLog(@"%@",nowVc);
    
    if ([nowVc isKindOfClass:[ViewController class]]) {
        
        //        if (nowDate.timeIntervalSince1970 - self.lastDate.timeIntervalSince1970 < 0.2f) {
        // 通过时间判断双击事件
        UIImageView *tabBarSwappableImageView = [self getTabBarButtonImageViewWithCurrentVc:viewController];
        
        if (tabBarSwappableImageView) {
            
            if (![[tabBarSwappableImageView layer] animationForKey:flipAnimationKey])  {
                
                //选中和未选中的image都需要更改为刷新中的图，不然会出现正在刷新时切换TabBar导致未选中的图片在旋转
                viewController.tabBarItem.selectedImage = [[UIImage imageNamed:@"shouye-lan"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                viewController.tabBarItem.image = [[UIImage imageNamed:@"shouye-hui"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                
                [self addTabBarButtonFlipAnimationWithCurrentViewController:viewController];
                
                if ([nowVc isKindOfClass:[ViewController class]]) {
                    //页面数据刷新
                    NSLog(@"刷新该页面");
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self removeTabBarButtonRotationAnimationWithCurrentViewController:nowVc];
                    });
                }
                
            }
            
        }
        
    }
    
    if ([nowVc isKindOfClass:[QQQViewController class]]) {
        
        //        if (nowDate.timeIntervalSince1970 - self.lastDate.timeIntervalSince1970 < 0.2f) {
        // 通过时间判断双击事件
        UIImageView *tabBarSwappableImageView = [self getTabBarButtonImageViewWithCurrentVc:viewController];
        
        if (tabBarSwappableImageView) {
            
            if (![[tabBarSwappableImageView layer] animationForKey:rotationAnimationKey])  {
                
                //选中和未选中的image都需要更改为刷新中的图，不然会出现正在刷新时切换TabBar导致未选中的图片在旋转
                viewController.tabBarItem.selectedImage = [[UIImage imageNamed:@"quanzi-lan"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                viewController.tabBarItem.image = [[UIImage imageNamed:@"quanzi-hui"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                
                [self addTabBarButtonRotationAnimationWithCurrentViewController:viewController];
                
                if ([nowVc isKindOfClass:[QQQViewController class]]) {
                    //页面数据刷新
                    NSLog(@"刷新该页面");
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self removeTabBarButtonRotationAnimationWithCurrentViewController:nowVc];
                    });
                }
                
            }
            
        }
    
    }
    
    if ([nowVc isKindOfClass:[QViewController class]]) {
        
        //        if (nowDate.timeIntervalSince1970 - self.lastDate.timeIntervalSince1970 < 0.2f) {
        // 通过时间判断双击事件
        UIImageView *tabBarSwappableImageView = [self getTabBarButtonImageViewWithCurrentVc:viewController];
        
        if (tabBarSwappableImageView) {
            
            if (![[tabBarSwappableImageView layer] animationForKey:rotationAnimationKey])  {
                
                //选中和未选中的image都需要更改为刷新中的图，不然会出现正在刷新时切换TabBar导致未选中的图片在旋转
                viewController.tabBarItem.selectedImage = [[UIImage imageNamed:@"yongchebaogao-lan"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                viewController.tabBarItem.image = [[UIImage imageNamed:@"yongchebaogao-hui"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                
                [self addTabBarButtonGiffAnimationWithCurrentViewController:viewController];
                
                if ([nowVc isKindOfClass:[QViewController class]]) {
                    //页面数据刷新
                    //                    NSLog(@"刷新该页面");
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self removeTabBarButtonRotationAnimationWithCurrentViewController:nowVc];
                    });
                }
                
            }
            
        }
        
    }
    
  
    
    if ([nowVc isKindOfClass:[QQQQViewController class]]) {
        
        //        if (nowDate.timeIntervalSince1970 - self.lastDate.timeIntervalSince1970 < 0.2f) {
        // 通过时间判断双击事件
        UIImageView *tabBarSwappableImageView = [self getTabBarButtonImageViewWithCurrentVc:viewController];
        
        if (tabBarSwappableImageView) {
            
            if (![[tabBarSwappableImageView layer] animationForKey:scaleAnimationKey])  {
                
                //选中和未选中的image都需要更改为刷新中的图，不然会出现正在刷新时切换TabBar导致未选中的图片在旋转
                viewController.tabBarItem.selectedImage = [[UIImage imageNamed:@"wode-lan"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                viewController.tabBarItem.image = [[UIImage imageNamed:@"wode-hui"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                
                [self addTabBarButtonScaleAnimationWithCurrentViewController:viewController];
                
                if ([nowVc isKindOfClass:[QQQQViewController class]]) {
                    //页面数据刷新
//                    NSLog(@"刷新该页面");
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self removeTabBarButtonRotationAnimationWithCurrentViewController:nowVc];
                    });
                }
                
            }
            
        }
        
    }
    
 
    return YES;
}

/**
 旋转动画
 
 @return CABasicAnimation 动画
 */
- (CABasicAnimation *)rotationAnimation{
    if (!_rotationAnimation) {
        //指定动画属性
        _rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        //单次动画时间
        _rotationAnimation.duration = 1;
        //重复次数
        _rotationAnimation.repeatCount= 1;
        //开始角度
        _rotationAnimation.fromValue = [NSNumber numberWithFloat:0];
        //结束角度
        _rotationAnimation.toValue = [NSNumber numberWithFloat: 2 * M_PI];
        // 是否在动画结束后移除动画
        _rotationAnimation.removedOnCompletion = NO;
    }
    return _rotationAnimation;
}

- (CABasicAnimation *)flipAnimation {
    
    if (!_flipAnimation) {
        //指定动画属性
        _flipAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
        //单次动画时间
        _flipAnimation.duration = 0.5;
        //重复次数
        _flipAnimation.repeatCount= 1;
        //开始角度
        _flipAnimation.fromValue = [NSNumber numberWithFloat:0];
        //结束角度
        _flipAnimation.toValue = [NSNumber numberWithFloat: M_PI];
        // 是否在动画结束后移除动画
        _flipAnimation.removedOnCompletion = NO;
    }
    return _flipAnimation;
}
- (CABasicAnimation *)scaleAnimation {
    if (!_scaleAnimation) {
         _scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        _scaleAnimation.fromValue = [NSNumber numberWithFloat: M_PI/18];
        _scaleAnimation.toValue = [NSNumber numberWithFloat: -M_PI/18];
        _scaleAnimation.duration = 0.1;//执行时间
        _scaleAnimation.autoreverses = YES; //是否重复
        _scaleAnimation.repeatCount = 2;//次数
    }
    return _scaleAnimation;
}
- (CAKeyframeAnimation *)giffAnimation {
    
    if (!_giffAnimation) {
        _giffAnimation = [CAKeyframeAnimation animationWithKeyPath:@"contents"];
        _giffAnimation.duration = 1.f;
        _giffAnimation.values = @[
                        (id)[UIImage imageNamed:@"shuju_1.png"].CGImage,
                        (id)[UIImage imageNamed:@"shuju_2.png"].CGImage,
                        (id)[UIImage imageNamed:@"shuju_3.png"].CGImage,
                        (id)[UIImage imageNamed:@"shuju_4.png"].CGImage,
                        (id)[UIImage imageNamed:@"shuju_5.png"].CGImage,
                        (id)[UIImage imageNamed:@"shuju_6.png"].CGImage,
                        (id)[UIImage imageNamed:@"shuju_7.png"].CGImage,
                        (id)[UIImage imageNamed:@"shuju_8.png"].CGImage];
        _giffAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        _giffAnimation.repeatCount = 1;
    }
    
    return _giffAnimation;
}


/**
 获取当前TabBarItem中的ImageView
 
 @param currentViewController 当前ViewController
 @return TabBarItem中的ImageView
 */
- (UIImageView *)getTabBarButtonImageViewWithCurrentVc:(UIViewController *)currentViewController{
    
    UIControl *tabBarButton = [currentViewController.tabBarItem valueForKey:@"view"];
    if (tabBarButton) {
        UIImageView *tabBarSwappableImageView = [tabBarButton valueForKey:@"info"];
        if (tabBarSwappableImageView) {
            return tabBarSwappableImageView;
        }
    }
    return nil;
}


/**
 添加旋转动画
 
 @param currentViewController 当前ViewController
 */
- (void)addTabBarButtonRotationAnimationWithCurrentViewController:(UIViewController *)currentViewController{
    
    UIImageView *tabBarSwappableImageView = [self getTabBarButtonImageViewWithCurrentVc:currentViewController];
    
    if (tabBarSwappableImageView) {
        [[tabBarSwappableImageView layer] addAnimation:self.rotationAnimation forKey:rotationAnimationKey];
    }
}

- (void)addTabBarButtonFlipAnimationWithCurrentViewController:(UIViewController *)currentViewController{
    
    UIImageView *tabBarSwappableImageView = [self getTabBarButtonImageViewWithCurrentVc:currentViewController];
    
    if (tabBarSwappableImageView) {
        [[tabBarSwappableImageView layer] addAnimation:self.flipAnimation forKey:flipAnimationKey];
    }
}

- (void)addTabBarButtonScaleAnimationWithCurrentViewController:(UIViewController *)currentViewController{
    
    UIImageView *tabBarSwappableImageView = [self getTabBarButtonImageViewWithCurrentVc:currentViewController];
    
    if (tabBarSwappableImageView) {
        [[tabBarSwappableImageView layer] addAnimation:self.scaleAnimation forKey:scaleAnimationKey];
    }
}

- (void)addTabBarButtonGiffAnimationWithCurrentViewController:(UIViewController *)currentViewController{
    
    UIImageView *tabBarSwappableImageView = [self getTabBarButtonImageViewWithCurrentVc:currentViewController];
    
    if (tabBarSwappableImageView) {
        [[tabBarSwappableImageView layer] addAnimation:self.rotationAnimation forKey:rotationAnimationKey];
    }
}


/**
 移除旋转动画
 
 @param currentViewController 当前ViewController
 */
- (void)removeTabBarButtonRotationAnimationWithCurrentViewController:(UIViewController *)currentViewController{
    
    
    UIImageView *tabBarSwappableImageView = [self getTabBarButtonImageViewWithCurrentVc:currentViewController];
    
    if (tabBarSwappableImageView) {
        
        if ([[tabBarSwappableImageView layer] animationForKey:rotationAnimationKey]) {
            
            [[tabBarSwappableImageView layer] removeAnimationForKey:rotationAnimationKey];
            
        }
        
        if ([[tabBarSwappableImageView layer] animationForKey:flipAnimationKey]) {
            
            [[tabBarSwappableImageView layer] removeAnimationForKey:flipAnimationKey];
            
        }
        if ([[tabBarSwappableImageView layer] animationForKey:scaleAnimationKey]) {
            
            [[tabBarSwappableImageView layer] removeAnimationForKey:scaleAnimationKey];
            
        }
        if ([[tabBarSwappableImageView layer] animationForKey:rotationAnimationKey]) {
            
            [[tabBarSwappableImageView layer] removeAnimationForKey:rotationAnimationKey];
            
        }
        
        
    }
    
    //移除后重新更换选中和未选中的图片
    if ([currentViewController isKindOfClass:[QQQViewController class]]) {
        currentViewController.tabBarItem.selectedImage = [[UIImage imageNamed:@"quanzi-lan"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        currentViewController.tabBarItem.image = [[UIImage imageNamed:@"quanzi-hui"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    
    //移除后重新更换选中和未选中的图片
    if ([currentViewController isKindOfClass:[ViewController class]]) {
        currentViewController.tabBarItem.selectedImage = [[UIImage imageNamed:@"shouye-lan"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        currentViewController.tabBarItem.image = [[UIImage imageNamed:@"shouye-hui"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    
    //移除后重新更换选中和未选中的图片
    if ([currentViewController isKindOfClass:[QQQQViewController class]]) {
        currentViewController.tabBarItem.selectedImage = [[UIImage imageNamed:@"wode-lan"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        currentViewController.tabBarItem.image = [[UIImage imageNamed:@"wode-hui"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    //移除后重新更换选中和未选中的图片
    if ([currentViewController isKindOfClass:[QViewController class]]) {
        currentViewController.tabBarItem.selectedImage = [[UIImage imageNamed:@"yongchebaogao-lan"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        currentViewController.tabBarItem.image = [[UIImage imageNamed:@"yongchebaogao-hui"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    

    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
