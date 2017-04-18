//
//  ViewController.m
//  DK_CustomPickerView
//
//  Created by apple on 17/4/18.
//  Copyright © 2017年 DeamonKing. All rights reserved.
//

#import "ViewController.h"
#import "CustomCityPickerView.h"
#import "CustomLevelOnePickerView.h"


@interface ViewController ()

@property (nonatomic, strong) UIButton *cityPickerViewBtn;
@property (nonatomic, strong) UIButton *levelOnePickerViewBtn;
@property (nonatomic, strong) UILabel *textLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.view addSubview:self.cityPickerViewBtn];
    [self.view addSubview:self.levelOnePickerViewBtn];
    [self.view addSubview:self.textLabel];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UILabel *)textLabel
{
    if (!_textLabel){
        _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, HEIGHT / 2, WIDTH - 36, 50)];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.layer.borderColor = [UIColor colorWithRed:123/255.0 green:125/255.0 blue:255/255.0 alpha:1].CGColor;
        _textLabel.layer.borderWidth = 0.5;
        _textLabel.layer.cornerRadius = 5;
        _textLabel.layer.masksToBounds = YES;
    }
    return _textLabel;
}

- (UIButton *)cityPickerViewBtn
{
	if (!_cityPickerViewBtn){
        _cityPickerViewBtn = [[UIButton alloc] initWithFrame:CGRectMake(16, 24, WIDTH - 36, 40)];
        [_cityPickerViewBtn setTitle:@"城市PickerView" forState:UIControlStateNormal];
        [_cityPickerViewBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_cityPickerViewBtn addTarget:self action:@selector(cityPickerViewBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _cityPickerViewBtn.layer.borderColor = [UIColor colorWithRed:123/255.0 green:125/255.0 blue:255/255.0 alpha:1].CGColor;
        _cityPickerViewBtn.layer.borderWidth = 0.5;
        _cityPickerViewBtn.layer.cornerRadius = 5;
        _cityPickerViewBtn.layer.masksToBounds = YES;
	}
	return _cityPickerViewBtn;
}

- (UIButton *)levelOnePickerViewBtn
{
	if (!_levelOnePickerViewBtn){
        _levelOnePickerViewBtn = [[UIButton alloc] initWithFrame:CGRectMake(16, CGRectGetMaxY(_cityPickerViewBtn.frame) + 16, WIDTH - 36, 40)];
        [_levelOnePickerViewBtn setTitle:@"一级联动PickerView" forState:UIControlStateNormal];
        [_levelOnePickerViewBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_levelOnePickerViewBtn addTarget:self action:@selector(levelOnePickerViewBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _levelOnePickerViewBtn.layer.borderColor = [UIColor colorWithRed:123/255.0 green:125/255.0 blue:255/255.0 alpha:1].CGColor;
        _levelOnePickerViewBtn.layer.borderWidth = 0.5;
        _levelOnePickerViewBtn.layer.cornerRadius = 5;
        _levelOnePickerViewBtn.layer.masksToBounds = YES;
	}
	return _levelOnePickerViewBtn;
}

- (void)cityPickerViewBtnClick:(id)sender {
    CustomCityPickerView *cityPVC = [[CustomCityPickerView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    
    __weak typeof(self) weakSelf = self;
    [cityPVC addButtonAction:^(NSString *province, NSString *city, NSString *district) {
        NSLog(@"%@ %@ %@", province, city, district);
        weakSelf.textLabel.text = [NSString stringWithFormat:@"%@%@%@", province, city, district];
    }];
    [cityPVC show];
}

- (void)levelOnePickerViewBtnClick:(id)sender {
    CustomLevelOnePickerView *levelOnePVC = [[CustomLevelOnePickerView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    NSArray *sexArr = @[@"男", @"女", @"人妖", @"未知性别"];
    [levelOnePVC.dataArrM addObjectsFromArray:sexArr];
    __weak typeof(self) weakSelf = self;
    [levelOnePVC addButtonAction:^(NSString *data) {
        NSLog(@"%@", data);
        weakSelf.textLabel.text = [NSString stringWithFormat:@"%@", data];
    }];
    [levelOnePVC show];
}




@end
