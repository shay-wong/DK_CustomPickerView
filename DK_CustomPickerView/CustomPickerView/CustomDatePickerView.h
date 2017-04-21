//
//  CustomDatePickerView.h
//  DK_CustomPickerView
//
//  Created by apple on 17/4/21.
//  Copyright © 2017年 DeamonKing. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  点击确定按钮的 block 回调
 *
 *  @param data 返回的数据
 */
typedef void (^buttonBlock) (NSString *data);

@interface CustomDatePickerView : UIView

@property (nonatomic, copy) buttonBlock buttonBlock;

- (void)show;

- (void)addButtonAction:(buttonBlock)buttonBlock;

@end
