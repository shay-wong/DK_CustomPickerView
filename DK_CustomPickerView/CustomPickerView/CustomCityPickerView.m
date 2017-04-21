//
//  CustomCityPickerView.m
//  DK_CustomPickerView
//
//  Created by apple on 17/4/18.
//  Copyright © 2017年 DeamonKing. All rights reserved.
//

#import "CustomCityPickerView.h"

#define PROVINCE_COMPONENT  0
#define CITY_COMPONENT      1
#define DISTRICT_COMPONENT  2

@interface CustomCityPickerView ()<UIPickerViewDelegate, UIPickerViewDataSource>

{
    UIView *view;
    UIView *btnView;
    UIPickerView *picker;
    UIButton *rightButton;
    UIButton *leftButton;
    
    NSMutableArray *arrayM;
    NSMutableArray *province;
    NSMutableArray *city;
    NSMutableArray *district;
    
    
    NSString *selectedProvince;
}

@property (nonatomic, strong) NSMutableArray *selectedArr;

@end

@implementation CustomCityPickerView

const CGFloat CustomCityPVRowHeight = 35.0f;
const CGFloat CustonCityPVHeight = 250.0f;
const CGFloat CustonCityPVBtnViewWidth = 40.0f;
const CGFloat CustonCityPVBtnViewHeight = 40.0f;

- (NSMutableArray *)selectedArr {
    if (!_selectedArr) {
        _selectedArr = [NSMutableArray array];
        [_selectedArr addObjectsFromArray:@[@"0",@"0",@"2"]];
    }
    return _selectedArr;
}

- (void)setSelectedIndex:(NSString *)selectedIndex {
    _selectedIndex = selectedIndex;
    
    [self.selectedArr removeAllObjects];
    [self.selectedArr addObjectsFromArray:[self.selectedIndex componentsSeparatedByString:@","]];
    [self loadData];
    for (NSInteger i = 0; i < self.selectedArr.count; i ++) {
        NSInteger index = [self.selectedArr[i] integerValue];
        [picker selectRow:index inComponent:i animated:NO];
    }
}


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self creatPickerView];
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    }
    return self;
}


- (void)loadData {
    [province removeAllObjects];
    [city removeAllObjects];
    [district removeAllObjects];
    
    NSInteger provinceIndex = [[self.selectedArr objectAtIndex:PROVINCE_COMPONENT] integerValue];
    NSInteger cityIndex = [[self.selectedArr objectAtIndex:CITY_COMPONENT] integerValue];
    NSInteger districtIndex = [[self.selectedArr objectAtIndex:DISTRICT_COMPONENT] integerValue];
    
    
    //得到省份的数组
    for (NSDictionary *dict in arrayM) {
        [province addObjectsFromArray:dict.allKeys];
    }
    //得到市的数组
    NSArray *array2 = arrayM[provinceIndex][province[provinceIndex]];
    for (NSDictionary *dict in array2) {
        [city addObjectsFromArray:dict.allKeys];
    }
    NSArray *array3 = [[arrayM[provinceIndex] objectForKey: province[provinceIndex]][cityIndex] objectForKey: city[cityIndex]];
    //得到区的数组
    for (NSString *str in array3) {
        [district addObject:str];
    }
    selectedProvince = [province objectAtIndex: provinceIndex];
}

- (void)creatPickerView {
    
    arrayM = [NSMutableArray array];
    province = [NSMutableArray array];
    city = [NSMutableArray array];
    district = [NSMutableArray array];

    //获取城市数据
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"area" ofType:@"plist"];
    arrayM = [[NSMutableArray alloc] initWithContentsOfFile:plistPath];
    
    [self loadData];
    
    view = [[UIView alloc] initWithFrame:CGRectMake(0, HEIGHT, WIDTH, CustonCityPVHeight)];
    view.backgroundColor = [UIColor whiteColor];
    
    picker = [[UIPickerView alloc] initWithFrame: CGRectMake(0, 0, WIDTH, CustonCityPVHeight)];
    picker.dataSource = self;
    picker.delegate = self;
    picker.showsSelectionIndicator = YES;
    [view addSubview: picker];
    
    btnView = [[UIView alloc] initWithFrame:CGRectMake(0, HEIGHT, WIDTH, CustonCityPVBtnViewHeight)];
    btnView.backgroundColor = [UIColor whiteColor];
    btnView.layer.borderWidth = 0.5;
    btnView.layer.borderColor = [[[UIColor blackColor] colorWithAlphaComponent:0.3] CGColor];
    
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
        self.buttonBlock(provinceStr, cityStr, districtStr, [NSString stringWithFormat:@"%ld,%ld,%ld", provinceIndex, cityIndex, districtIndex]);
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
        
        [city removeAllObjects];
        
        [district removeAllObjects];
        //得到市的model的数组
        for (NSDictionary *dict in [arrayM[row] objectForKey:selectedProvince]) {
            [city addObjectsFromArray:dict.allKeys];
            //得到区的model的数组
            for (NSString *str in dict[city[0]]) {
                [district addObject:str];
            }
        }
        
        [picker selectRow:0 inComponent: CITY_COMPONENT animated: YES];
        [picker selectRow:0 inComponent: DISTRICT_COMPONENT animated: YES];
        [picker reloadComponent: CITY_COMPONENT];
        [picker reloadComponent: DISTRICT_COMPONENT];
        
    }
    else if (component == CITY_COMPONENT) {
        
        NSString *cityName=[city objectAtIndex:row];
        [district removeAllObjects];
        //得到区的model的数组
        for (NSString *str in [[arrayM[[province indexOfObject:selectedProvince]] objectForKey:selectedProvince][row] objectForKey:cityName]) {
            [district addObject:str];
        }
        [picker selectRow:0 inComponent: DISTRICT_COMPONENT animated: YES];
        [picker reloadComponent: DISTRICT_COMPONENT];
    }
    
}


- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return (WIDTH - 16)/3;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return CustomCityPVRowHeight;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel* pickerLabel = nil;
    if (!pickerLabel) {
        pickerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, WIDTH/3, CustomCityPVRowHeight)];
        pickerLabel.numberOfLines = 0;
        pickerLabel.lineBreakMode = NSLineBreakByWordWrapping;
        pickerLabel.textAlignment = NSTextAlignmentCenter;
        pickerLabel.backgroundColor = [UIColor clearColor];
        [pickerLabel setFont:[UIFont systemFontOfSize:13]];
    }
    //调用上一个委托方法，获得要展示的title
    pickerLabel.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    
    
    return pickerLabel;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self remove];
}

- (void)show {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect viewFrame = view.frame;
        viewFrame.origin.y = HEIGHT - CustonCityPVHeight;
        view.frame = viewFrame;
        CGRect btnViewFrame = btnView.frame;
        btnViewFrame.origin.y = HEIGHT - CustonCityPVHeight - CustomCityPVRowHeight;
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
