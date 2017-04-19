//
//  ProvinceAddressModel.h
//  DK_CustomPickerView
//
//  Created by apple on 17/4/18.
//  Copyright © 2017年 DeamonKing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProvinceAddressModel : NSObject

@property (nonatomic,assign)NSInteger ID;      //省id
@property (nonatomic,strong)NSString *name;    //省名称
@property (nonatomic,assign)NSInteger postcode;//邮政编码


@end
