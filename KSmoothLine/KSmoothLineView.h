//
//  KSmoothLineView.h
//  KSmoothLineChart
//
//  Created by tenghu on 2017/11/23.
//  Copyright © 2017年 tenghu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KSmoothLineView : UIView

- (void)reloadViews;

#pragma mark - DataSource
@property (nonatomic, strong) NSArray<NSString *> *data;
@property (nonatomic, assign) NSRange yRange;
@property (nonatomic, assign) CGFloat ySpace;
@property (nonatomic, assign) CGFloat itemW;
@property (nonatomic ,strong)UIColor *storkColor;
@property (nonatomic, assign)UIEdgeInsets chartMargin;

@end
