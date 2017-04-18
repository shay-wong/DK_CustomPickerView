//
//  CustomCityPickerView.m
//  BeautifulPainting
//
//  Created by 王 on 16/8/12.
//  Copyright © 2016年 BeautifulPainting. All rights reserved.
//

#import "CustomCityPickerView.h"
#import "AddressFMDBManager.h"
#import "ProvinceAddressModel.h"
#import "CityAddressModel.h"
#import "DistrictModel.h"

#define PROVINCE_COMPONENT  0
#define CITY_COMPONENT      1
#define DISTRICT_COMPONENT  2

@interface CustomCityPickerView ()<UIPickerViewDelegate, UIPickerViewDataSource>

{
    UIPickerView *picker;
    UIButton *rightButton;
    UIButton *leftButton;
    
    NSMutableArray *province;
    NSMutableArray *city;
    NSMutableArray *district;
    
    NSString *selectedProvince;
}

@property (nonatomic, strong) UIView *view;
@property (nonatomic, strong) UIView *btnView;

@end

@implementation CustomCityPickerView

const CGFloat CustomCityPVRowHeight = 35.0f;
const CGFloat CustonCityPVHeight = 250.0f;
const CGFloat CustonCityPVBtnViewWidth = 40.0f;
const CGFloat CustonCityPVBtnViewHeight = 40.0f;

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self creatPickerView];
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    }
    return self;
}

- (void)creatPickerView {
    province = [[NSMutableArray alloc] initWithCapacity:5];
    city = [[NSMutableArray alloc] initWithCapacity:5];
    district = [[NSMutableArray alloc] initWithCapacity:5];
    
    AddressFMDBManager *addFMDBManager = [AddressFMDBManager sharedAddressFMDBManager];
    
    //得到省份的model数组
    NSArray *arr = [NSArray arrayWithArray:[addFMDBManager selectAllProvince]];
    for (ProvinceAddressModel *provinceModel in arr) {
        [province addObject:provinceModel.name];
    }
    
    //得到市的model的数组
    NSArray *arr2 = [NSArray arrayWithArray:[addFMDBManager selectAllCityFrom:1]];
    
    for (CityAddressModel *cityModel in arr2) {
        [city addObject:cityModel.name];
    }
    
    //得到区的model的数组
    NSArray *arr3 = [NSArray arrayWithArray:[addFMDBManager selectAllDistrictFrom:1]];
    for (DistrictModel *districtModel in arr3) {
        [district addObject:districtModel.name];
    }
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, HEIGHT, WIDTH, CustonCityPVHeight)];
    view.backgroundColor = [UIColor whiteColor];
    self.view = view;
    
    picker = [[UIPickerView alloc] initWithFrame: CGRectMake(0, 0, WIDTH, CustonCityPVHeight)];
    picker.dataSource = self;
    picker.delegate = self;
    picker.showsSelectionIndicator = YES;
    [picker selectRow: 0 inComponent: 0 animated: YES];
    [view addSubview: picker];
    
    selectedProvince = [province objectAtIndex: 0];
    
    UIView *btnView = [[UIView alloc] initWithFrame:CGRectMake(0, HEIGHT, WIDTH, CustonCityPVBtnViewHeight)];
    btnView.backgroundColor = [UIColor whiteColor];
    btnView.layer.borderWidth = 0.5;
    btnView.layer.borderColor = [[[UIColor blackColor] colorWithAlphaComponent:0.3] CGColor];
    self.btnView = btnView;
    
    rightButton = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH - CustonCityPVBtnViewWidth - 10, 0, CustonCityPVBtnViewWidth, CustonCityPVBtnViewHeight)];
    [rightButton setTitle: @"完成" forState: UIControlStateNormal];
    [rightButton setTitleColor:[UIColor colorWithRed:58/255.0 green:112/255.0 blue:234/255.0 alpha:1] forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [rightButton addTarget: self action: @selector(rightButtonClicked:) forControlEvents: UIControlEventTouchUpInside];
    [btnView addSubview:rightButton];
    
    leftButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 0, CustonCityPVBtnViewWidth, CustonCityPVBtnViewHeight)];
    [leftButton setTitle: @"取消" forState: UIControlStateNormal];
    [leftButton setTitleColor:[UIColor colorWithRed:58/255.0 green:112/255.0 blue:234/255.0 alpha:1] forState:UIControlStateNormal];
    leftButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [leftButton addTarget: self action: @selector(leftButtonClicked:) forControlEvents: UIControlEventTouchUpInside];
    [btnView addSubview:leftButton];
    
    
    [self addSubview:view];
    [self addSubview:btnView];
    
}

#pragma mark- button clicked

- (void)addButtonAction:(ButtonBlock)buttonBlock {
    self.buttonBlock = buttonBlock;
}

- (void)rightButtonClicked:(UIButton *)sender {
    NSInteger provinceIndex = [picker selectedRowInComponent: PROVINCE_COMPONENT];
    NSInteger cityIndex = [picker selectedRowInComponent: CITY_COMPONENT];
    NSInteger districtIndex = [picker selectedRowInComponent: DISTRICT_COMPONENT];
    
    NSString *provinceStr = [province objectAtIndex: provinceIndex];
    NSString *cityStr = [city objectAtIndex: cityIndex];
    NSString *districtStr = [district objectAtIndex:districtIndex];
    
    if ([provinceStr isEqualToString: cityStr]) {
        if ([cityStr isEqualToString:districtStr]) {
            districtStr = @"";
            cityStr = @"";
        } else {
            cityStr = @"";
        }
    }
    else if ([cityStr isEqualToString: districtStr]) {
        districtStr = @"";
    }
    
    if (self.buttonBlock) {
        self.buttonBlock(provinceStr, cityStr, districtStr);
    }
    [self remove];
    
    
}

- (void)leftButtonClicked:(UIButton *)sender {
    [self remove];
}


#pragma mark- Picker Data Source Methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == PROVINCE_COMPONENT) {
        return [province count];
    }
    else if (component == CITY_COMPONENT) {
        return [city count];
    }
    else {
        return [district count];
    }
}


#pragma mark- Picker Delegate Methods

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == PROVINCE_COMPONENT) {
        return [province objectAtIndex: row];
    }
    else if (component == CITY_COMPONENT) {
        return [city objectAtIndex: row];
    }
    else {
        return [district objectAtIndex: row];
    }
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == PROVINCE_COMPONENT) {
        selectedProvince = [province objectAtIndex: row];
        
        AddressFMDBManager *addFMDBManager=[AddressFMDBManager sharedAddressFMDBManager];
        
        [city removeAllObjects];
        //得到市的model的数组
        NSArray *arr2=[NSArray arrayWithArray:[addFMDBManager selectAllCityFrom:row+1]];
        for (CityAddressModel *cityModel in arr2) {
            [city addObject:cityModel.name];
        }
        
        //获取城市id
        NSInteger cityId=[addFMDBManager selectIdFromCityWith:[city objectAtIndex:0]];
        
//        NSLog(@"城市id为:::%ld",cityId);
        [district removeAllObjects];
        //得到区的model的数组
        NSArray *arr3=[NSArray arrayWithArray:[addFMDBManager selectAllDistrictFrom:cityId]];
        for (DistrictModel *districtModel in arr3) {
            [district addObject:districtModel.name];
        }
        
        [picker selectRow:0 inComponent: CITY_COMPONENT animated: NO];
        [picker selectRow:0 inComponent: DISTRICT_COMPONENT animated: NO];
        [picker reloadComponent: CITY_COMPONENT];
        [picker reloadComponent: DISTRICT_COMPONENT];
        //        [picker reloadAllComponents];
        
    }
    else if (component == CITY_COMPONENT) {
        //        NSInteger *provinceIndex = [province indexOfObject: selectedProvince];
        AddressFMDBManager *addFMDBManager=[AddressFMDBManager sharedAddressFMDBManager];
        NSString *cityName=[city objectAtIndex:row];
        NSInteger cityId=[addFMDBManager selectIdFromCityWith:cityName];
//        NSLog(@"====%@",cityName);
        [district removeAllObjects];
        //得到区的model的数组
        NSArray *arr3=[NSArray arrayWithArray:[addFMDBManager selectAllDistrictFrom:cityId]];
        for (DistrictModel *districtModel in arr3) {
            [district addObject:districtModel.name];
        }
        [picker selectRow:0 inComponent: DISTRICT_COMPONENT animated: NO];
        [picker reloadComponent: DISTRICT_COMPONENT];
    }
    
}


- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    if (component == PROVINCE_COMPONENT) {
        return WIDTH * 2 / 8;
    }
    else if (component == CITY_COMPONENT) {
        return WIDTH * 3 / 8;
    } else if (component == DISTRICT_COMPONENT){
        return WIDTH * 3 / 8;
    }
    return 0;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return CustomCityPVRowHeight;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *myView = nil;
    
    if (component == PROVINCE_COMPONENT) {
        myView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, WIDTH * 2 / 8, CustomCityPVRowHeight)];
        myView.textAlignment = NSTextAlignmentCenter;
        myView.text = [province objectAtIndex:row];
        myView.font = [UIFont systemFontOfSize:15];
        myView.backgroundColor = [UIColor clearColor];
    }
    else if (component == CITY_COMPONENT) {
        myView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, WIDTH * 3 / 8, CustomCityPVRowHeight)];
        myView.textAlignment = NSTextAlignmentCenter;
        myView.text = [city objectAtIndex:row];
        myView.font = [UIFont systemFontOfSize:15];
        myView.backgroundColor = [UIColor clearColor];
    }
    else {
        myView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, WIDTH * 3 / 8, CustomCityPVRowHeight)];
        myView.textAlignment = NSTextAlignmentCenter;
        myView.text = [district objectAtIndex:row];
        myView.font = [UIFont systemFontOfSize:15];
        myView.backgroundColor = [UIColor clearColor];
    }
    
    return myView;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self remove];
}

- (void)show {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        CGRect viewFrame = weakSelf.view.frame;
        viewFrame.origin.y = HEIGHT - CustonCityPVHeight;
        weakSelf.view.frame = viewFrame;
        CGRect btnViewFrame = weakSelf.btnView.frame;
        btnViewFrame.origin.y = HEIGHT - CustonCityPVHeight - CustomCityPVRowHeight;
        weakSelf.btnView.frame = btnViewFrame;
    }];
}

- (void)remove {
//    [self removeFromSuperview];
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        
        CGRect viewFrame = weakSelf.view.frame;
        viewFrame.origin.y = HEIGHT;
        weakSelf.view.frame = viewFrame;
        CGRect btnViewFrame = weakSelf.btnView.frame;
        btnViewFrame.origin.y = HEIGHT;
        weakSelf.btnView.frame = btnViewFrame;
        
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
    }];
}

@end
