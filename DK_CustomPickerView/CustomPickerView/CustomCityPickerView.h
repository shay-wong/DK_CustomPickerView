//
//  CustomCityPickerView.h
//  BeautifulPainting
//
//  Created by 王 on 16/8/12.
//  Copyright © 2016年 BeautifulPainting. All rights reserved.
//

#import <UIKit/UIKit.h>



/**
 *  点击确定按钮的 block 回调
 *
 *  @param province 省份
 *  @param city     市
 *  @param district 区
 */
typedef void (^ButtonBlock) (NSString * province, NSString *city, NSString *district);

@interface CustomCityPickerView : UIView

@property (nonatomic, copy) ButtonBlock buttonBlock;

- (void)addButtonAction:(ButtonBlock)buttonBlock;

- (void)show;

@end
