//
//  CityAddressModel.h
//  DK_CustomPickerView
//
//  Created by apple on 17/4/18.
//  Copyright © 2017年 DeamonKing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CityAddressModel : NSObject

@property (nonatomic,assign)NSInteger ID;      //id
@property (nonatomic,strong)NSString *name;    //名称
@property (nonatomic,assign)NSInteger postcode;//邮政编码
@property (nonatomic,assign)NSInteger province_id;//省ID
@end
