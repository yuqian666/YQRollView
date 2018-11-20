//
//  YQRollView.h
//  YQRollView
//
//  Created by 虞谦 on 2018/11/19.
//  Copyright © 2018 虞谦. All rights reserved.
//

#import <UIKit/UIKit.h>

//视图滚动方向
typedef enum : NSUInteger {
    YQRollViewDirectionRight,
    YQRollViewDirectionLeft,
    YQRollViewDirectionDown,
    YQRollViewDirectionUp,
} YQRollViewDirection;


NS_ASSUME_NONNULL_BEGIN

@interface YQRollView : UIView

/**
 视图展示时间
 */
@property (nonatomic, assign) float waitTime;

/**
 滚动动画时间
 */
@property (nonatomic, assign) float animationTime;

/**
 滚动方向
 */
@property (nonatomic, assign) YQRollViewDirection rollDirection;


/**
 初始化方法

 @param rollDirection 滚动方向
 @param viewArray s滚动视图列表
 @return 滚动视图
 */
- (instancetype)initWithRollDirection:(YQRollViewDirection)rollDirection viewArray:(nonnull NSArray *)viewArray;

/**
 开始滚动
 */
- (void)startRoll;

/**
 停止滚动
 */
- (void)stopRoll;

@end

NS_ASSUME_NONNULL_END
