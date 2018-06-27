//
//  MCTabBar.m
//  MCTabBarDemo
//
//  Created by chh on 2017/12/18.
//  Copyright © 2017年 Mr.C. All rights reserved.
//

#import "MCTabBar.h"

@implementation MCTabBar
- (instancetype)init{
    if (self = [super init]){
        [self initView];
    }
    return self;
}

- (void)initView{
    _centerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _centerBtn.backgroundColor =  [UIColor colorWithRed:250.0/255.0 green:108/255.0 blue:148/255.0 alpha:1];
    //  设定button大小为适应图片
    UIImage *normalImage = [UIImage imageNamed:@"gouwuche-lan"];
    _centerBtn.frame = CGRectMake(0, 0, normalImage.size.width, normalImage.size.height);
    [_centerBtn setImage:normalImage forState:UIControlStateNormal];
    //去除选择时高亮
    _centerBtn.adjustsImageWhenHighlighted = NO;
    //根据图片调整button的位置(图片中心在tabbar的中间最上部，这个时候由于按钮是有一部分超出tabbar的，所以点击无效，要进行处理)
    _centerBtn.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - normalImage.size.width)/2.0, - normalImage.size.height/3.2, normalImage.size.width, normalImage.size.height);
    _centerBtn.layer.cornerRadius = normalImage.size.height/2;
    _centerBtn.layer.masksToBounds = YES;
    _centerBtn.layer.borderWidth = 5;
    _centerBtn.layer.borderColor = [UIColor colorWithRed:42.0/255.0 green:46.0/255.0 blue:67/255.0 alpha:1].CGColor;

    [self addSubview:_centerBtn];
}

//处理超出区域点击无效的问题
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    if (self.hidden){
        return [super hitTest:point withEvent:event];
    }else {
        //转换坐标
        CGPoint tempPoint = [self.centerBtn convertPoint:point fromView:self];
        //判断点击的点是否在按钮区域内
        if (CGRectContainsPoint(self.centerBtn.bounds, tempPoint)){
            //返回按钮
            return _centerBtn;
        }else {
            return [super hitTest:point withEvent:event];
        }
    }
}
@end
