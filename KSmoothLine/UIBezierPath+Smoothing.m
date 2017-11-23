//
//  UIBezierPath+Smoothing.m
//  HeadManage
//
//  Created by a111 on 17/5/5.
//  Copyright © 2017年 Tenghu. All rights reserved.
//

#import "UIBezierPath+Smoothing.h"
#import "UIBezierPath+Points.h"

#define POINT(_INDEX_) [(NSValue *)[points objectAtIndex:_INDEX_] CGPointValue]

@implementation UIBezierPath (Smoothing)

- (UIBezierPath *)smoothedPath
{
    NSMutableArray *points = [[self points] mutableCopy];
    if (points.count < 2) {
        return [self copy];
    }
    
    UIBezierPath *smoothedPath = [UIBezierPath bezierPath];
    smoothedPath.lineWidth = self.lineWidth;
    [smoothedPath moveToPoint:POINT(0)];
   
    for (int index = 1; index < points.count; index ++) {
       
        CGPoint p2 = POINT(index - 1);
        CGPoint p3 = POINT(index);
        
    [smoothedPath addCurveToPoint:p3 controlPoint1:CGPointMake((p2.x+p3.x)/2, p2.y) controlPoint2:CGPointMake((p2.x+p3.x)/2, p3.y)]; //三次曲线
        
    }
    [smoothedPath addLineToPoint:POINT(points.count - 1)];
    return smoothedPath;
    
}

@end

