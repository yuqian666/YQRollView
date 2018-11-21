# YQRollView
简介：
    一个轮播图控件，可以控制轮播时间，调整轮播图滚动方向

基本使用：

    //滚动视图列表
    NSMutableArray *viewArray;
    //初始化滚动视图，YQRollViewDirectionRight为滚动方向
    _rollView = [[YQRollView alloc] initWithRollDirection:YQRollViewDirectionRight viewArray:viewArray];
    //设置滚动动画时间
    _rollView.animationTime = 0.5;
    //设置滚动间隔时间
    _rollView.waitTime = 0.5;
    [self.view addSubview:_rollView];
    
    //开始滚动
    [_rollView startRoll];

    //停止滚动
    [_rollView stopRoll];
    
  
