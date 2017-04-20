//
//  CustomLevelThreePickerView.h
//  DK_CustomPickerView
//
//  Created by apple on 17/4/20.
//  Copyright © 2017年 DeamonKing. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  点击确定按钮的 block 回调
 *
 *  @param data 返回的数据
 */
typedef void (^buttonBlock) (NSString *data);

@interface CustomLevelThreePickerView : UIView

/**
 *  传入要显示的参数数组，存放字符串
 */
@property (nonatomic, strong) NSMutableArray *dataArrM;

@property (nonatomic, copy) buttonBlock buttonBlock;

- (void)show;

- (void)addButtonAction:(buttonBlock)buttonBlock;

@end
