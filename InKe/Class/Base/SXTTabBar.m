//
//  SXTTabBar.m
//  InKe
//
//  Created by sjq on 17/8/28.
//  Copyright © 2017年 sjq. All rights reserved.
//

#import "SXTTabBar.h"

@interface SXTTabBar()

@property (nonatomic, strong) UIImageView *tabbgView;
@property (nonatomic, strong) NSArray *datalist;
@property (nonatomic, strong) UIButton *lastItem;           //记录最后一个选中的Button
@property (nonatomic, strong) UIButton *cameraButton;       //相机按钮

@end

@implementation SXTTabBar

- (UIImageView *)tabbgView
{
    if (!_tabbgView) {
        _tabbgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"global_tab_bg"]];
    }
    return _tabbgView;
}

- (NSArray *)datalist
{
    if (!_datalist) {
        _datalist = @[@"tab_live",@"tab_me"];
    }
    return _datalist;
}

- (UIButton *)cameraButton
{
    if (!_cameraButton) {
        _cameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cameraButton setImage:[UIImage imageNamed:@"tab_launch"] forState:UIControlStateNormal];
        [_cameraButton sizeToFit];
        [_cameraButton addTarget:self action:@selector(clickItem:) forControlEvents:UIControlEventTouchUpInside];
        _cameraButton.tag = SXTItemTypeLanch;
    }
    return _cameraButton;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //设置tabbar背景
        [self addSubview:self.tabbgView];
        
        for (NSInteger i = 0; i < self.datalist.count; i++) {
            UIButton *item = [UIButton buttonWithType:UIButtonTypeCustom];
            item.adjustsImageWhenHighlighted = NO;//去除高亮状态
            
            [item setImage:[UIImage imageNamed:self.datalist[i]] forState:UIControlStateNormal];
            [item setImage:[UIImage imageNamed:[self.datalist[i] stringByAppendingString:@"_p"]] forState:UIControlStateSelected];
            [item addTarget:self action:@selector(clickItem:) forControlEvents:UIControlEventTouchUpInside];
            item.tag = SXTItemTypeLive +i;
            if (i == 0) {
                item.selected = YES;
                self.lastItem = item;
            }
            
            [self addSubview:item];
        }
        
        //添加直播按钮
        [self addSubview:self.cameraButton];
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.tabbgView.frame = self.bounds;
    CGFloat width = self.bounds.size.width / self.datalist.count;
    
    for (NSInteger i = 0; i < [self subviews].count; i++) {
        UIView *btnView = [self subviews][i];
        if ([btnView isKindOfClass:[UIButton class]]) {
            btnView.frame = CGRectMake((btnView.tag - SXTItemTypeLive) * width, 0, width, self.bounds.size.height);
        }
    }
    [self.cameraButton sizeToFit];
    self.cameraButton.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height-40);
}

- (void)clickItem:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(tabbar:clickButton:)]) {
        [self.delegate tabbar:self clickButton:button.tag];
    }
    
    if (self.block) {
        self.block(self,button.tag);
    }
    
    if (button.tag == SXTItemTypeLanch) {
        return;
    }
    
    self.lastItem.selected = NO;
    button.selected = YES;
    self.lastItem = button;
    
    //设置动画
    [UIView animateWithDuration:0.2 animations:^{
        //将button扩大1.2倍
        button.transform = CGAffineTransformMakeScale(1.2, 1.2);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            //恢复原始状态
            button.transform = CGAffineTransformIdentity;
        }];
    }];
    
    
}

//- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
//    UIView *view = [super hitTest:point withEvent:event];
//
//    if (view == nil) {
//        //将坐标由当前视图发送到 指定视图 fromView是无法响应的范围小父视图
//
//        CGPoint stationPoint = [_cameraButton convertPoint:point fromView:self];
//
//        if (CGRectContainsPoint(_cameraButton.bounds, stationPoint))
//        {
//            view = _cameraButton;
//        }
//
//    }
//    return view;
//}

////重写该方法后可以让超出父视图范围的子视图响应事件
//- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
//    UIView *view = [super hitTest:point withEvent:event];
//    if (view == nil) {
//        for (UIView *subView in self.subviews) {
//            CGPoint tp = [subView convertPoint:point fromView:self];
//            if (CGRectContainsPoint(subView.bounds, tp)) {
//                view = subView;
//            }
//        }
//    }
//    return view;
//}
//
//-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
//    //if内的条件应该为，当触摸点point超出蓝色部分，但在黄色部分时
////    if (.....){
////        return YES;
////    }
//    return YES;
//}

@end
