//
//  CustomDatePickerView.m
//  DK_CustomPickerView
//
//  Created by apple on 17/4/21.
//  Copyright © 2017年 DeamonKing. All rights reserved.
//

#import "CustomDatePickerView.h"

@interface CustomDatePickerView ()

{
    UIView *view;
    UIView *btnView;
    UIDatePicker *picker;
    UIButton *rightButton;
    UIButton *leftButton;
    
    NSString *selectedData;
    
}

@end

@implementation CustomDatePickerView

const CGFloat CustomDatePVRowHeight = 35.0f;
const CGFloat CustomDatePVHeight = 250.0f;
const CGFloat CustomDatePVBtnViewWidth = 40.0f;
const CGFloat CustomDatePVBtnViewHeight = 40.0f;

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self creatPickerView];
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    }
    return self;
}

- (void)creatPickerView {
    
    view = [[UIView alloc] initWithFrame:CGRectMake(0, HEIGHT, WIDTH, CustomDatePVHeight)];
    view.backgroundColor = [UIColor whiteColor];
    
    picker = [[UIDatePicker alloc] initWithFrame: CGRectMake(0, 0, WIDTH, CustomDatePVHeight)];
    //设置地区
    picker.locale = [NSLocale localeWithLocaleIdentifier:@"zh"];
    //设置日期格式
    picker.datePickerMode = UIDatePickerModeDate;
    
    [view addSubview: picker];
    
    btnView = [[UIView alloc] initWithFrame:CGRectMake(0, HEIGHT, WIDTH, 40)];
    btnView.backgroundColor = [UIColor whiteColor];
    btnView.layer.borderWidth = 0.5;
    btnView.layer.borderColor = [[[UIColor blackColor] colorWithAlphaComponent:0.3] CGColor];
    
    rightButton = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH - CustomDatePVBtnViewWidth - 10, 0, CustomDatePVBtnViewWidth, CustomDatePVBtnViewHeight)];
    [rightButton setTitle: @"完成" forState: UIControlStateNormal];
    [rightButton setTitleColor:[UIColor colorWithRed:58/255.0 green:112/255.0 blue:234/255.0 alpha:1] forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [rightButton addTarget: self action: @selector(rightButtonClicked:) forControlEvents: UIControlEventTouchUpInside];
    [btnView addSubview:rightButton];
    
    leftButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 0, CustomDatePVBtnViewWidth, CustomDatePVBtnViewHeight)];
    [leftButton setTitle: @"取消" forState: UIControlStateNormal];
    [leftButton setTitleColor:[UIColor colorWithRed:58/255.0 green:112/255.0 blue:234/255.0 alpha:1] forState:UIControlStateNormal];
    leftButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [leftButton addTarget: self action: @selector(leftButtonClicked:) forControlEvents: UIControlEventTouchUpInside];
    [btnView addSubview:leftButton];
    
    [self addSubview:view];
    [self addSubview:btnView];
    
}

#pragma mark- button clicked

- (void)addButtonAction:(buttonBlock)buttonBlock {
    self.buttonBlock = buttonBlock;
}

- (void)rightButtonClicked:(UIButton *)sender {
//    NSInteger dataIndex = [picker selectedRowInComponent:0];
//    
//    NSString *dataStr = [self.dataArrM objectAtIndex:dataIndex];
//    
//    if (self.buttonBlock) {
//        self.buttonBlock(dataStr);
//    }
    [self remove];
    
}

- (void)leftButtonClicked:(UIButton *)sender {
    [self remove];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self remove];
}

- (void)show {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect viewFrame = view.frame;
        viewFrame.origin.y = HEIGHT - CustomDatePVHeight;
        view.frame = viewFrame;
        CGRect btnViewFrame = btnView.frame;
        btnViewFrame.origin.y = HEIGHT - CustomDatePVHeight - CustomDatePVRowHeight;
        btnView.frame = btnViewFrame;
    }];
}

- (void)remove {
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        
        CGRect viewFrame = view.frame;
        viewFrame.origin.y = HEIGHT;
        view.frame = viewFrame;
        CGRect btnViewFrame = btnView.frame;
        btnViewFrame.origin.y = HEIGHT;
        btnView.frame = btnViewFrame;
        
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
    }];
}

@end
