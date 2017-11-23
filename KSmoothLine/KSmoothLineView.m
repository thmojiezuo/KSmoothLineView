//
//  KSmoothLineView.m
//  KSmoothLineChart
//
//  Created by tenghu on 2017/11/23.
//  Copyright © 2017年 tenghu. All rights reserved.
//

#import "KSmoothLineView.h"
#import "UIBezierPath+Smoothing.h"

@interface KSmoothLineView ()
{
    NSArray<NSString *> *_arrangeData;
    NSRange _validRange;
    NSInteger _countX;
    
}
@end

@implementation KSmoothLineView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.data = [NSArray array];
        self.yRange = NSMakeRange(0, 0);
        self.ySpace = 0;
        self.itemW = 55.0;
        _chartMargin = UIEdgeInsetsMake(0, 26+5, 0, 0); // 上左下右
        //self.backgroundColor = [UIColor groupTableViewBackgroundColor];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    self.data = _data;
    self.yRange = _yRange;
    self.ySpace = _ySpace;
    
    [self draw];
}
- (void)reloadViews {
    [self.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    [self draw];
}
- (void)draw {
    
    if ( _countX > _validRange.location) {
        [self.layer addSublayer:[self creatChart]];
    }
}

- (void)setData:(NSArray *)data {
    _data = data;
    _countX = _data.count;
    [self confirmValidRange];
    
    _arrangeData = [_data copy];
    
}
-(void)setItemW:(CGFloat)itemW{
    _itemW = itemW;
}
-(void)setChartMargin:(UIEdgeInsets)chartMargin{
    _chartMargin = chartMargin;
}
- (void)setYRange:(NSRange)yRange {
    _yRange = yRange;
}

- (void)setYSpace:(CGFloat)ySpace {
    _ySpace = ySpace;
}
-(void)setStorkColor:(UIColor *)storkColor{
    _storkColor = storkColor;
}
#pragma mark - creatChart

- (CALayer *)creatChart {
    CALayer *layer = [CALayer layer];
    [layer addSublayer:[self creatLines]];
    [layer addSublayer:[self creatPoints]];
    [layer addSublayer:[self textLayer]];
    return layer;
}
#pragma mark //画折线
- (CALayer *)creatLines {
    float intervalX =  self.itemW;
    float unitY = _ySpace / _yRange.length;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    CAShapeLayer *layer = [CAShapeLayer layer];
    
    for (NSUInteger i = _validRange.location; i < _validRange.location + _validRange.length; i++) {
        if (![self isValidUnit:i]) {
            continue;
        }
        float x = i * intervalX;
        float y = [_data[i]  floatValue] * unitY;
        CGPoint point = CGPointMake(_chartMargin.left + x, self.bounds.size.height - y);
        if (i == _validRange.location) {
            [path moveToPoint:point];
        } else {
            [path addLineToPoint:point];
        }
    }
    ;
    layer.lineWidth = 1.0;
    layer.strokeColor = _storkColor.CGColor;
    layer.fillColor = [[UIColor clearColor] CGColor];
    layer.path = [path smoothedPath].CGPath;
    
    return layer;
}

#pragma mark //画折线上的点
- (CALayer *)creatPoints {
    CAShapeLayer *rootLayer = [[CAShapeLayer alloc] init];
    float intervalX =  self.itemW;
    float unitY = _ySpace / _yRange.length;
    
    for (NSUInteger i = _validRange.location; i < _validRange.location + _validRange.length; i++) {
        if (![self isValidUnit:i]) {
            continue;
        }
        float x = i * intervalX;
        float y = [_data[i] floatValue] * unitY;
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path addArcWithCenter:CGPointZero radius:2.5 startAngle:0 endAngle:2 * M_PI clockwise:NO];
        
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.fillColor = [UIColor whiteColor].CGColor;
        layer.path = path.CGPath;
        
        layer.bounds = CGPathGetBoundingBox(layer.path);
        
        layer.position = CGPointMake(_chartMargin.left + x, self.bounds.size.height - y);
        layer.borderWidth = 1;
        layer.borderColor = _storkColor.CGColor;
        layer.masksToBounds = YES;
        layer.cornerRadius = 2.5;
        [rootLayer addSublayer:layer];
    }
    
    return rootLayer;
}
#pragma mark - 画折线上点对应的text
- (CALayer *)textLayer{
    
    CAShapeLayer *rootLayer = [[CAShapeLayer alloc] init];
    float intervalX =  self.itemW;
    float unitY = _ySpace / _yRange.length;
    
    for (NSUInteger i = _validRange.location; i < _validRange.location + _validRange.length; i++) {
        if (![self isValidUnit:i]) {
            continue;
        }
        float x = i * intervalX;
        float y = [_data[i] floatValue] * unitY;
        
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path addArcWithCenter:CGPointZero radius:2.5 startAngle:0 endAngle:2 * M_PI clockwise:NO];
        
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.fillColor = [UIColor whiteColor].CGColor;
        layer.path = path.CGPath;
        
        CATextLayer *textLayer = [CATextLayer layer];
        textLayer.foregroundColor = [UIColor whiteColor].CGColor;
        textLayer.backgroundColor =  [UIColor clearColor].CGColor;
        textLayer.fontSize = 7.5;
        textLayer.alignmentMode = kCAAlignmentCenter;
        textLayer.contentsScale = [[UIScreen mainScreen] scale];
        CGRect bounds = CGPathGetBoundingBox(layer.path);
        bounds.size = CGSizeMake(self.itemW, 10);
        textLayer.bounds = bounds;
        textLayer.position = CGPointMake(_chartMargin.left + x, self.bounds.size.height - y-10);
        textLayer.string = [NSString stringWithFormat:@"%@",_data[i]];
        
        [rootLayer addSublayer:textLayer];
    }
    
    return rootLayer;
    
}
#pragma mark - Private

- (void)confirmValidRange {
    NSInteger firstValid = 0;
    NSInteger lastValid = 0;
    for (firstValid = 0; firstValid < _countX; firstValid++) {
        if ([self isValidUnit:firstValid]) {
            break;
        }
    }
    for (lastValid = _countX - 1; lastValid >= 0; lastValid--) {
        if ([self isValidUnit:lastValid]) {
            break;
        }
    }
    _validRange = NSMakeRange(firstValid, lastValid - firstValid + 1);
}

- (BOOL)isValidUnit:(NSUInteger)count {
    NSString *dictionary = _data[count];
    
    if (dictionary == nil
        || dictionary.length == 0
        ||  [dictionary isEqualToString:@""]) {
        return NO;
    } else {
        return YES;
    }
}

@end
