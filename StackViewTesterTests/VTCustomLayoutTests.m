//
//  VTCustomLayoutTests.m
//  StackViewTester
//
//  Created by Kevin Wong on 12/12/15.
//  Copyright © 2015 Kevin Wong. All rights reserved.
//

#import "VTBaseViewTest.h"

@interface VTCustomLayoutTests : VTBaseViewTest

@end

@implementation VTCustomLayoutTests

- (void) test_custom
{
    [self setSetupArrangedViews:^NSArray* (UIStackView* stackView) {
        NSMutableArray* array = [NSMutableArray array];
        for (int i = 0; i < 7; i++)
        {
            UIColor* color = [UIColor colorWithHue:i / 7.0 saturation:1 brightness:1 alpha:1];
            UIView* view = [[UIView alloc] init];
            [view setBackgroundColor:color];
            
            [view autoMatchDimension:ALDimensionWidth toDimension:ALDimensionHeight ofView:view];
            
            [array addObject:view];
        }
        return array;
    }];
    
    [self setSetupStackViewBlock:^(UIStackView* stackView) {
        [stackView vt_applyConsistentDefaults];
        [stackView setAlignment:UIStackViewAlignmentFill];
        [stackView setDistribution:UIStackViewDistributionEqualSpacing];
        [stackView setSpacing:20];
        [stackView vt_setExplicitSize:CGSizeMake(500, 50)];
    }];
    
    VTTestAll();
}

- (void) test_customNested
{
    [self setSetupArrangedViews:^NSArray* (UIStackView* stackView) {

        NSMutableArray* stackViews = [NSMutableArray array];

        for (int i = 0; i < 5; i++)
        {
            UIStackView* sv = [[[stackView class] alloc] initWithArrangedSubviews:@[]];
            [sv vt_applyConsistentDefaults];
            [sv setAxis:UILayoutConstraintAxisVertical];
            [sv setSpacing:20];

            [stackViews addObject:sv];
        }
        

        for (int i = 0; i < 25; i++)
        {
            UIColor* color = [UIColor colorWithHue:i / 25.0 saturation:1 brightness:1 alpha:1];

            UIView* view = [[VTTestView alloc] initWithSize:CGSizeMake(50, 50) color:color];
            
            [[stackViews objectAtIndex:(i / 5)] addArrangedSubview:view];
        }
        return stackViews;
    }];
    
    [self setSetupStackViewBlock:^(UIStackView* stackView) {
        [stackView vt_applyConsistentDefaults];
        [stackView setAxis:UILayoutConstraintAxisHorizontal];
        [stackView setSpacing:20];

    }];
    
    VTTestAll();
}

@end
