//
//  CustomCityPickerView.h
//  DK_CustomPickerView
//
//  Created by apple on 17/4/18.
//  Copyright © 2017年 DeamonKing. All rights reserved.
//

#import <UIKit/UIKit.h>



/**
 *  点击确定按钮的 block 回调
 *
 *  @param province 省份
 *  @param city     市
 *  @param district 区
 */
typedef void (^ButtonBlock) (NSString * province, NSString *city, NSString *district, NSString *selectedIndex);

@interface CustomCityPickerView : UIView

@property (nonatomic, copy) NSString *selectedIndex;

@property (nonatomic, copy) ButtonBlock buttonBlock;

- (void)addButtonAction:(ButtonBlock)buttonBlock;

- (void)show;

@end
