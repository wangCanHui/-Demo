
//
//  JBAnimationView.m
//  备忘录
//
//  Created by GMobile No.2 on 2016/11/3.
//  Copyright © 2016年 李海生. All rights reserved.
//

#import "JBAnimationView.h"
@interface JBAnimationView ()
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,weak) UILabel *timeLabel;
@property (nonatomic,strong) UIImageView *imageView;
@end

JBAnimationView *animationView;
int num1,num2,duration;

@implementation JBAnimationView

+ (void)animateWithImages:(NSArray *)images duration:(int)duration1 inViewController:(UIViewController *)viewController showTime:(BOOL)isShowTime
{
    // 0.计算时间初始值
    duration = duration1;
    // 1. 初始化animationView
    animationView = [[JBAnimationView alloc] init];
    UIView *view = viewController.view;
    animationView.size = CGSizeMake(157, 157);
    animationView.center = CGPointMake(view.centerX, view.centerY-64);
    animationView.layer.cornerRadius = 20;
    animationView.clipsToBounds = YES;
    animationView.backgroundColor = [UIColor blackColor];
    animationView.alpha = 0.5;
    [viewController.view addSubview:animationView];
    // 添加取消手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(stopAnimate)];
    [animationView addGestureRecognizer:tap];
    // 2. 初始化imageView
    animationView.imageView = [[UIImageView alloc] initWithImage:images.firstObject];
    animationView.imageView.center = CGPointMake(view.centerX, view.centerY-64);
    [viewController.view addSubview:animationView.imageView];
    
    // 3. 初始化timeLabel
    if (isShowTime) {
        // 计算时间初始值
        num1 = duration/60;
        num2 = duration%60;
        UILabel *timeLabel = [UILabel labelWithText:[NSString stringWithFormat:@"%02d:%02d",num1,num2] TextColor:[UIColor whiteColor]backgroundColor:nil fontSize:14];
        timeLabel.size = CGSizeMake(80, 18);
        timeLabel.textAlignment = NSTextAlignmentCenter;
        timeLabel.center = CGPointMake(view.centerX, view.centerY);
        [viewController.view addSubview:timeLabel];
        animationView.timeLabel = timeLabel;
        if ([animationView.timer isValid]) {
            [self stopTimer];
        }
        animationView.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeReduce) userInfo:nil repeats:YES];
    }else{
        UILabel *timeLabel = [UILabel labelWithText:[NSString stringWithFormat:@"手指上滑，取消发送"] TextColor:[UIColor whiteColor]backgroundColor:nil fontSize:14];
        timeLabel.size = CGSizeMake(140, 18);
        timeLabel.textAlignment = NSTextAlignmentCenter;
        timeLabel.center = CGPointMake(view.centerX, view.centerY);
        [viewController.view addSubview:timeLabel];
        animationView.timeLabel = timeLabel;
    }
    //设置动画的图片资源
    animationView.imageView.animationImages=images;
    
    //设置动画的执行时间，即执行快慢
    NSTimeInterval animationDuration = 0.333333*images.count;
    animationView.imageView.animationDuration=animationDuration;
    
    //设置动画的执行次数
    animationView.imageView.animationRepeatCount=duration;
    //必须所有动画效果设置完毕之后，开启动画
    [animationView.imageView startAnimating];
}

+ (void)stopAnimate
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"stopAnimateNotif" object:nil];
    [self stopTimer];
    //在自身动画执行完毕的时候，直接self.imgView.animationImages=nil;释放掉本次动画的资源
    [animationView.imageView performSelector:@selector(setAnimationImages:) withObject:nil];
    [animationView.imageView removeFromSuperview];
    [animationView.timeLabel removeFromSuperview];
    [animationView removeFromSuperview];
    animationView = nil;
}

+ (void)timeReduce
{
    duration--;
    num1 = duration/60;
    num2 = duration%60;
    animationView.timeLabel.text = [NSString stringWithFormat:@"%02d:%02d",num1,num2];
    if (duration <= 0) {
        [self stopAnimate];
    }
}
+ (void)stopTimer
{
    [animationView.timer invalidate];
    animationView.timer =  nil;
}

+ (BOOL)isAnimating
{
    return duration;
}
@end
