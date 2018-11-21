//
//  YQRollView.m
//  YQRollView
//
//  Created by 虞谦 on 2018/11/19.
//  Copyright © 2018 虞谦. All rights reserved.
//

#import "YQRollView.h"

#define YQ_Wait_Time 2
#define YQ_Animation_Time 1
#define YQ_SelfW self.frame.size.width
#define YQ_SelfH self.frame.size.height



@interface YQRollView ()

/**
 滚动视图列表
 */
@property (nonatomic, strong) NSArray *viewArr;

/**
 用来承载展示的视图
 */
@property (nonatomic, strong) UIView *backView1;

/**
 用来承载即将展示的视图
 */
@property (nonatomic, strong) UIView *backView2;

/**
 定时器
 */
@property (nonatomic, strong) NSTimer *timer;

/**
 当前视图Index
 */
@property (nonatomic, assign) NSInteger rollIndex;

/**
 是否在动画中
 */
@property (nonatomic, assign) BOOL isAnimation;


@end


@implementation YQRollView

#pragma mark - 对外接口

- (instancetype)initWithRollDirection:(YQRollViewDirection)rollDirection viewArray:(nonnull NSArray *)viewArray
{
    self = [super init];
    if (self) {
        self.clipsToBounds = YES;
        self.backView1 = [[UIView alloc]init];
        self.backView1.clipsToBounds = YES;
        self.backView2 = [[UIView alloc]init];
        self.backView2.clipsToBounds = YES;
        [self addSubview:self.backView1];
        [self addSubview:self.backView2];
    }
    
    _rollIndex = 0;
    _rollDirection = rollDirection;
    _waitTime = YQ_Wait_Time;
    _animationTime = YQ_Animation_Time;
    [self setRollViewArr:viewArray];
    return self;
}

/**
 设置滚动方向
 
 @param rollDirection 视图滚动方向
 */
- (void)setRollDirection:(YQRollViewDirection)rollDirection
{
    _rollDirection = rollDirection;
    //动画过程中不去强行改变运动轨迹
    if (!_isAnimation) {
        [self resetBackViewFrame];
    }
}



/**
 开始滚动
 */
- (void)startRoll
{
    [self resetBackViewFrame];
    if (_timer) {
        [_timer invalidate];
    }
    _timer = [NSTimer timerWithTimeInterval:_waitTime+_animationTime target:self selector:@selector(rollAnimation:) userInfo:nil repeats:YES];
    
    //此处设置NSRunLoopCommonModes是为了保证定时器在页面滚动等条件下仍然能够准确地工作
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    _timer.fireDate = [NSDate dateWithTimeIntervalSinceNow:_waitTime];
}


/**
 停止滚动
 */
- (void)stopRoll
{
    [_timer invalidate];
    _timer = nil;
}

#pragma mark - 视图frame设置相关

/**
 设置滚动视图

 @param viewArr 视图列表
 */
- (void)setRollViewArr:(NSArray *)viewArr
{
    _viewArr = viewArr;
    
    if (_viewArr && _viewArr.count > 0) {
        UIView *firstView = [viewArr firstObject];
        //RollView大小默认跟第一个view大小一致
        self.frame = CGRectMake(0, 0, firstView.frame.size.width, firstView.frame.size.height);
        if (_viewArr.count == 1) {
            [_backView1 addSubview:[_viewArr firstObject]];
        }else {
            [_backView1 addSubview:_viewArr[0]];
            [_backView2 addSubview:_viewArr[1]];
        }
        [self resetBackViewFrame];
    }
}


/**
 重置backView的frame
 */
- (void)resetBackViewFrame
{
    self.backView1.frame = CGRectMake(0, 0, YQ_SelfW, YQ_SelfH);
    CGPoint originPoint = [self getStartPoint];
    self.backView2.frame = CGRectMake(originPoint.x, originPoint.y, YQ_SelfW, YQ_SelfH);
}


#pragma mark - 滚动的实现逻辑

/**
 滚动动画
 
 @param timer 定时器
 */
- (void)rollAnimation:(NSTimer *)timer
{
    __weak __typeof(self) weakSelf = self;
    if (!self.viewArr || self.viewArr.count < 2) {
        return;
    }
    
    
    CGPoint targetPoint = [self getTargetPoint];
    self.isAnimation = true;
    [UIView animateWithDuration:_animationTime animations:^{
        weakSelf.backView1.frame = CGRectMake(targetPoint.x, targetPoint.y, YQ_SelfW, YQ_SelfH);
        weakSelf.backView2.frame = CGRectMake(0, 0, YQ_SelfW, YQ_SelfH);
    }completion:^(BOOL finished) {
        weakSelf.isAnimation = false;
        weakSelf.rollIndex ++;
        weakSelf.rollIndex = weakSelf.rollIndex%weakSelf.viewArr.count;
        NSInteger willShowIndex = (weakSelf.rollIndex + 1)%weakSelf.viewArr.count;
        //NSLog(@"%d--%d",self.rollIndex,willShowIndex);
        //此时rollDirection可能已经改变
        CGPoint startPoint = [self getStartPoint];
        weakSelf.backView1.frame = CGRectMake(startPoint.x, startPoint.y, YQ_SelfW, YQ_SelfH);
        [weakSelf removeAllSubView:weakSelf.backView1];
        [weakSelf.backView1 addSubview:weakSelf.viewArr[willShowIndex]];
        UIView *tempView = weakSelf.backView1;
        weakSelf.backView1 = weakSelf.backView2;
        weakSelf.backView2 = tempView;
    }];
}

/**
 获取视图滚动的起始点位置

 @return 起始点位置
 */
- (CGPoint)getStartPoint
{
    CGPoint originPoint;
    switch (_rollDirection) {
        case YQRollViewDirectionRight:
            originPoint = CGPointMake(-YQ_SelfW, 0);
            break;
        case YQRollViewDirectionLeft:
            originPoint = CGPointMake(YQ_SelfW, 0);
            break;
        case YQRollViewDirectionDown:
            originPoint = CGPointMake(0, -YQ_SelfH);
            break;
        case YQRollViewDirectionUp:
            originPoint = CGPointMake(0, YQ_SelfH);
            break;
        default:
            break;
    }
    return originPoint;
}


/**
 获取视图滚动的终点z位置

 @return 终点位置
 */
- (CGPoint)getTargetPoint
{
    CGPoint originPoint;
    switch (_rollDirection) {
        case YQRollViewDirectionRight:
            originPoint = CGPointMake(YQ_SelfW, 0);
            break;
        case YQRollViewDirectionLeft:
            originPoint = CGPointMake(-YQ_SelfW, 0);
            break;
        case YQRollViewDirectionDown:
            originPoint = CGPointMake(0, YQ_SelfH);
            break;
        case YQRollViewDirectionUp:
            originPoint = CGPointMake(0, -YQ_SelfH);
            break;
        default:
            break;
    }
    return originPoint;
}

#pragma mark - 其他

/**
 移除所有子视图

 @param oneView 父视图
 */
- (void)removeAllSubView:(UIView *)oneView
{
    for (UIView *subView in oneView.subviews) {
        [subView removeFromSuperview];
    }
}


/**
 关闭定时器防止内存泄漏
 */
- (void)dealloc
{
    [self stopRoll];
}
              
@end
