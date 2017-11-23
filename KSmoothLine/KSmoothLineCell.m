//
//  KSmoothLineCell.m
//  KSmoothLineChart
//
//  Created by tenghu on 2017/11/23.
//  Copyright © 2017年 tenghu. All rights reserved.
//

#import "KSmoothLineCell.h"
#import "KSmoothLineView.h"

@interface KSmoothLineCell ()
{
    KSmoothLineView *_chartView;
}
@end

@implementation KSmoothLineCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 2);
    CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
    CGFloat lengths[] = {1,5};
    CGContextSetLineDash(context, 0, lengths,2);
    CGContextMoveToPoint(context, 0, 0); //设置线的起始点
    CGContextAddLineToPoint(context, 0, self.bounds.size.height); //设置线中间的一个点
    CGContextStrokePath(context);//直接把所有的点连起来
    
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    return self;
}

-(void)setColor:(UIColor *)color{
    _color = color;
}

-(void)setData:(NSArray *)data{
    _data = data;
    
    if (_chartView) {
        [_chartView removeFromSuperview];
        
    }
    
    CGFloat maxValue = [[data valueForKeyPath:@"@max.floatValue"] floatValue];
    
    _chartView = [[KSmoothLineView alloc]initWithFrame:CGRectMake(0, 10, data.count*41, 25)];
    _chartView.data = data;
    _chartView.ySpace = 25;
    _chartView.itemW = 41;
    _chartView.storkColor = _color;
    _chartView.yRange = NSMakeRange(0, maxValue);
    _chartView.chartMargin = UIEdgeInsetsMake(0, 24, 0, 0); // 上左下右
    [self.contentView addSubview:_chartView];
    //        [_chartView reloadViews];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
