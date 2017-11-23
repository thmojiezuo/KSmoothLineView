//
//  ViewController.m
//  KSmoothLineChart
//
//  Created by tenghu on 2017/11/10.
//  Copyright © 2017年 tenghu. All rights reserved.
//

#import "ViewController.h"
#import "KSmoothLineCell.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic ,strong)UIScrollView *scroller;  //柱状图的
@property (nonatomic ,strong)UITableView *lineTableView;
@property (nonatomic ,strong)NSMutableArray *lineData;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    _lineData = [[NSMutableArray alloc] init];
    NSArray *arr1 = @[@"1000",@"3000",@"0",@"2000",@"1500",@"2000",@"3000",@"2500",@"2000",@"1800"];
    [_lineData addObject:arr1];
    [_lineData addObject:arr1];
    
    NSArray *leftnArr = @[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9"];
    
    _scroller= [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64,  SCREEN_WIDTH , _lineData.count * 50)];
    _scroller.showsHorizontalScrollIndicator = YES;
    _scroller.contentSize = CGSizeMake(leftnArr.count*41+10, 0);
    _scroller.indicatorStyle=UIScrollViewIndicatorStyleWhite;
    [self.view addSubview:_scroller];
    
    _lineTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0,leftnArr.count*41+10 , 85) style:UITableViewStylePlain];
    _lineTableView.backgroundColor = [UIColor clearColor];
    _lineTableView.delegate = self;
    _lineTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _lineTableView.dataSource = self;
    _lineTableView.scrollEnabled = NO;
    [_lineTableView registerClass:[KSmoothLineCell class] forCellReuseIdentifier:@"user_id"];
    [_scroller addSubview:_lineTableView];
}

#pragma mark - UITableView Datasource
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 5)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
   
        return 5;
   
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  
        return _lineData.count;
   
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UIColor *color1 = [UIColor redColor];
    UIColor *color2 = [UIColor greenColor];
    NSArray *arr = @[color1,color2];
  
    KSmoothLineCell *cell = [tableView dequeueReusableCellWithIdentifier:@"user_id" forIndexPath:indexPath];
    cell.color = arr[indexPath.row];
    cell.data = _lineData[indexPath.row];
    return cell;
  
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 40;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
