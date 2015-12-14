//
//  VTTestView.m
//  ViewTester
//
//  Created by Kevin Wong on 11/8/15.
//  Copyright © 2015 Kevin Wong. All rights reserved.
//

#import "VTTestView.h"

@implementation VTTestView

- (instancetype) initWithSize:(CGSize)size
{
    self = [super initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    if (self == nil)
    {
        return nil;
    }
    
    _size = size;
    
    return self;
}

- (instancetype) initWithSize:(CGSize)size color:(UIColor *)color
{
    self = [self initWithSize:size];
    if (self == nil)
    {
        return nil;
    }
    
    [self setBackgroundColor:color];
    
    return self;
}

- (void)setSize:(CGSize)size
{
    _size = size;
    [self invalidateIntrinsicContentSize];
}

- (CGSize)intrinsicContentSize
{
    return [self size];
}

@end

@implementation VTTestViewGroups

NSArray* setTags(NSArray* views)
{
    for (int i = 0; i < [views count]; i++)
    {
        [[views objectAtIndex:i] setTag:i];
    }
    
    return views;
}


+ (NSArray<UIView *> *)singleView
{
    UIView* view = [[VTTestView alloc] initWithSize:CGSizeMake(50, 50) color:[UIColor redColor]];
    return @[view];
}

+ (NSArray<UIView *> *)simpleViews
{
    NSMutableArray* array = [NSMutableArray array];
    for (int i = 0; i < 5; i++)
    {
        UIColor* color = [UIColor colorWithHue:i / 5.0 saturation:1 brightness:1 alpha:1];
        [array addObject:[[VTTestView alloc] initWithSize:CGSizeMake(10 * (i + 1), 10 * (i + 1)) color:color]];
    }
    
    return setTags(array);
}

+ (NSArray<UIView *> *)viewsWithLabels
{
    NSMutableArray* array = [NSMutableArray array];
    UIColor* color;
    NSString* alphabet = @"A B C D E F";
    
    color = [UIColor colorWithHue:0 saturation:1 brightness:1 alpha:1];
    [array addObject:[[VTTestView alloc] initWithSize:CGSizeMake(10, 10) color:color]];
    
    UILabel* label;
    label = [[UILabel alloc] init];
    [label setText:alphabet];
    [label setBackgroundColor:[UIColor colorWithHue:0.15 saturation:1 brightness:1 alpha:1]];
    
    [array addObject:label];
    
    color = [UIColor colorWithHue:0.3 saturation:1 brightness:1 alpha:1];
    [array addObject:[[VTTestView alloc] initWithSize:CGSizeMake(30, 30) color:color]];
    
    label = [[UILabel alloc] init];
    [label setText:alphabet];
    [label setNumberOfLines:0];
    [label setBackgroundColor:[UIColor colorWithHue:0.45 saturation:1 brightness:1 alpha:1]];
    [array addObject:label];
    
    label = [[UILabel alloc] init];
    [label setText:alphabet];
    [label setNumberOfLines:0];
    [label setPreferredMaxLayoutWidth:10];
    [label setBackgroundColor:[UIColor colorWithHue:0.6 saturation:1 brightness:1 alpha:1]];
    [array addObject:label];
    
    color = [UIColor colorWithHue:0.75 saturation:1 brightness:1 alpha:1];
    [array addObject:[[VTTestView alloc] initWithSize:CGSizeMake(50, 50) color:color]];
    
    return setTags(array);
}

@end