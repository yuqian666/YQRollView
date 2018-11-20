//
//  ViewController.m
//  YQRollView
//
//  Created by 虞谦 on 2018/11/19.
//  Copyright © 2018 虞谦. All rights reserved.
//

#import "ViewController.h"
#import "YQRollView.h"

@interface ViewController ()

@property (nonatomic, strong) YQRollView *rollView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    NSMutableArray *viewArray = [NSMutableArray array];
    for (int i = 0; i < 10; i ++) {
        UILabel *tempLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, screenSize.width - 100, 80)];
        tempLabel.text = [NSString stringWithFormat:@"第%d个Label",i+1];
        tempLabel.textColor = [UIColor yellowColor];
        tempLabel.font = [UIFont systemFontOfSize:32];
        tempLabel.textAlignment = NSTextAlignmentCenter;
        tempLabel.backgroundColor = [UIColor colorWithRed:(random()%255)/255.0 green:(random()%255)/255.0 blue:(random()%255)/255.0 alpha:1];
        [viewArray addObject:tempLabel];
    }
    
    //初始化滚动视图
    _rollView = [[YQRollView alloc] initWithRollDirection:YQRollViewDirectionRight viewArray:viewArray];
    //设置滚动动画时间
    _rollView.animationTime = 0.5;
    //设置滚动间隔时间
    _rollView.waitTime = 0.5;
    [self.view addSubview:_rollView];
    _rollView.frame = CGRectMake(50, screenSize.height/2-40, screenSize.width - 100, 80);
    
    
}

/**
 设置滚动方向

 @param sender sender description
 */
- (IBAction)setRollDirection:(UISegmentedControl *)sender {
    _rollView.rollDirection = sender.selectedSegmentIndex;
}

/**
 开始滚动

 @param sender sender description
 */
- (IBAction)startRoll:(id)sender {
    [_rollView startRoll];
}

/**
 停止滚动

 @param sender sender description
 */
- (IBAction)stopRoll:(UIButton *)sender {
    [_rollView stopRoll];
}


@end
