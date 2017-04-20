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
#import "CustomLevelThreePickerView.h"

//推荐的定义枚举类型的方式
typedef NS_ENUM(NSInteger, DK_PickerViewType) {
    DK_PickerViewTypeCity = 0,
    DK_PickerViewTypeLevelOne,
    DK_PickerViewTypeLevelTwo,
    DK_PickerViewTypeLevelThree
};


@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ViewController

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.view addSubview:self.tableView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    NSString *title;
    NSString *detail = @"请选择";
    switch (indexPath.row) {
        case DK_PickerViewTypeCity:
            title = @"城市选择";
            break;
        case DK_PickerViewTypeLevelOne:
            title = @"一级联动";
            break;
        case DK_PickerViewTypeLevelTwo:
            title = @"二级联动";
            break;
        case DK_PickerViewTypeLevelThree:
            title = @"三级联动";
            break;
    }
    cell.textLabel.text = title;
    cell.detailTextLabel.text = detail;
    cell.detailTextLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case DK_PickerViewTypeCity:
            [self cityPickerViewClick:indexPath];
            break;
        case DK_PickerViewTypeLevelOne:
            [self levelOnePickerViewClick:indexPath];
            break;
        case DK_PickerViewTypeLevelTwo:
            
            break;
        case DK_PickerViewTypeLevelThree:
            [self levelThreePickerViewClick:indexPath];
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (void)cityPickerViewClick:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    CustomCityPickerView *cityPVC = [[CustomCityPickerView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    
    [cityPVC addButtonAction:^(NSString *province, NSString *city, NSString *district) {
        NSLog(@"%@ %@ %@", province, city, district);
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@%@%@", province, city, district];
    }];
    [cityPVC show];
}

- (void)levelOnePickerViewClick:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    CustomLevelOnePickerView *levelOnePVC = [[CustomLevelOnePickerView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    NSArray *sexArr = @[@"男", @"女", @"人妖", @"未知性别"];
    [levelOnePVC.dataArrM addObjectsFromArray:sexArr];
    
    [levelOnePVC addButtonAction:^(NSString *data) {
        NSLog(@"%@", data);
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", data];
    }];
    [levelOnePVC show];
}

- (void)levelThreePickerViewClick:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    CustomLevelThreePickerView *levelOnePVC = [[CustomLevelThreePickerView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    NSArray *sexArr = @[@"男", @"女", @"人妖", @"未知性别,未知性别,未知性别,未知性别,"];
    [levelOnePVC.dataArrM addObjectsFromArray:sexArr];
    
    [levelOnePVC addButtonAction:^(NSString *data) {
        NSLog(@"%@", data);
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", data];
    }];
    [levelOnePVC show];
}




@end
