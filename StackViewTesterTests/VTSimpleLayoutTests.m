//
//  VTSimpleLayoutTests.m
//  ViewTester
//
//  Created by Kevin Wong on 11/4/15.
//  Copyright © 2015 Kevin Wong. All rights reserved.
//

#import "VTBaseViewTest.h"
#import <objc/runtime.h>

@interface VTSimpleLayoutTests : VTBaseViewTest

@end

@implementation VTSimpleLayoutTests

- (void) testDefaults
{
    VTTestAll();
}

- (void) testDefaultAlignment
{
    [self setSetupStackViewBlock:^(UIStackView* stackView) {
        [stackView setAxis:UILayoutConstraintAxisHorizontal];
        [stackView vt_safe_setBaselineRelativeArrangement:FALSE];
        [stackView setDistribution:UIStackViewDistributionFill];
        [stackView setLayoutMarginsRelativeArrangement:FALSE];
        [stackView setSpacing:0.0f];
    }];
    
    VTTestAll();
}


- (void) testDefaultAxis
{
    [self setSetupStackViewBlock:^(UIStackView* stackView) {
        [stackView setAlignment:UIStackViewAlignmentFill];
        [stackView vt_safe_setBaselineRelativeArrangement:FALSE];
        [stackView setDistribution:UIStackViewDistributionFill];
        [stackView setLayoutMarginsRelativeArrangement:FALSE];
        [stackView setSpacing:0.0f];
    }];
    
    VTTestAll();
}

- (void) testDefaultBaselineRelativeArrangement
{
    [self setSetupStackViewBlock:^(UIStackView* stackView) {
        [stackView setAlignment:UIStackViewAlignmentFill];
        [stackView setAxis:UILayoutConstraintAxisHorizontal];
        [stackView setDistribution:UIStackViewDistributionFill];
        [stackView setLayoutMarginsRelativeArrangement:FALSE];
        [stackView setSpacing:0.0f];
    }];
    
    VTTestAll();
}

- (void) testDefaultDistribution
{
    [self setSetupStackViewBlock:^(UIStackView* stackView) {
        [stackView setAlignment:UIStackViewAlignmentFill];
        [stackView setAxis:UILayoutConstraintAxisHorizontal];
        [stackView vt_safe_setBaselineRelativeArrangement:FALSE];
        [stackView setLayoutMarginsRelativeArrangement:FALSE];
        [stackView setSpacing:0.0f];
    }];
    
    VTTestAll();
}

- (void) testDefaultLayoutMarginRelativeArrangement
{
    [self setSetupStackViewBlock:^(UIStackView* stackView) {
        [stackView setAlignment:UIStackViewAlignmentFill];
        [stackView setAxis:UILayoutConstraintAxisHorizontal];
        [stackView vt_safe_setBaselineRelativeArrangement:FALSE];
        [stackView setDistribution:UIStackViewDistributionFill];
        [stackView setSpacing:0.0f];
    }];
    
    VTTestAll();
}

- (void) testDefaultSpacing
{
    [self setSetupStackViewBlock:^(UIStackView* stackView) {
        [stackView setAlignment:UIStackViewAlignmentFill];
        [stackView setAxis:UILayoutConstraintAxisHorizontal];
        [stackView vt_safe_setBaselineRelativeArrangement:FALSE];
        [stackView setDistribution:UIStackViewDistributionFill];
        [stackView setLayoutMarginsRelativeArrangement:FALSE];
        [stackView setSpacing:0.0f];
    }];
    
    VTTestAll();
}

- (void) testEmpty
{
    [self setAddArrangedViews:FALSE];
    
    VTTestAll();
}

- (void) testInsert
{
    [self setSetupStackViewBlock:^(UIStackView* stackView) {
        [stackView vt_applyConsistentDefaults];
        
        UIColor* color = [UIColor colorWithHue:0.5 saturation:0.5 brightness:0.5 alpha:1];
        UIView* testView = [[VTTestView alloc] initWithSize:CGSizeMake(10, 100) color:color];
        [stackView insertArrangedSubview:testView atIndex:0];
    }];

    VTTestAll();
}

- (void) testHiddenViews1
{
    [self setSetupStackViewBlock:^(UIStackView* stackView) {
        [stackView vt_applyConsistentDefaults];

        [[[stackView arrangedSubviews] objectAtIndex:1] setHidden:TRUE];
        [[[stackView arrangedSubviews] objectAtIndex:3] setHidden:TRUE];
    }];
    
    VTTestAll();
}

- (void) testHiddenViews2
{
    [self setSetupStackViewBlock:^(UIStackView* stackView) {
        [stackView vt_applyConsistentDefaults];

        [[[stackView arrangedSubviews] objectAtIndex:0] setHidden:TRUE];
        [[[stackView arrangedSubviews] objectAtIndex:4] setHidden:TRUE];
    }];
    
    VTTestAll();
}

- (void) testHiddenViewsAllViews
{
    [self setSetupStackViewBlock:^(UIStackView* stackView) {
        [stackView vt_applyConsistentDefaults];
        
        for (UIView* view in [stackView arrangedSubviews])
        {
            [view setHidden:TRUE];
        }
    }];
    
    
    VTTestAll();
}

- (void) testHiddenViewsWithSpacing
{
    [self setSetupStackViewBlock:^(UIStackView* stackView) {
        [stackView vt_applyConsistentDefaults];
        
        [[[stackView arrangedSubviews] objectAtIndex:1] setHidden:TRUE];
        [[[stackView arrangedSubviews] objectAtIndex:3] setHidden:TRUE];
        [stackView setSpacing:10];
    }];
    
    VTTestAll();
}

- (void) testRemovedViews1
{
    [self setSetupStackViewBlock:^(UIStackView* stackView) {
        [stackView vt_applyConsistentDefaults];
        
        [stackView removeArrangedSubview:[[stackView arrangedSubviews] objectAtIndex:0]];
    }];
    
    VTTestAll();
}

- (void) testRemovedViews2
{
    [self setSetupStackViewBlock:^(UIStackView* stackView) {
        [stackView vt_applyConsistentDefaults];
        
        UIView* v0 = [[stackView arrangedSubviews] objectAtIndex:0];
        UIView* v1 = [[stackView arrangedSubviews] objectAtIndex:1];
        [stackView removeArrangedSubview:v0];
        [stackView removeArrangedSubview:v1];
    }];
    
    VTTestAll();
}

- (void) testRemovedViews3
{
    [self setSetupStackViewBlock:^(UIStackView* stackView) {
        [stackView vt_applyConsistentDefaults];
        
        UIView* v1 = [[stackView arrangedSubviews] objectAtIndex:1];
        UIView* v3 = [[stackView arrangedSubviews] objectAtIndex:3];
        [stackView removeArrangedSubview:v1];
        [stackView removeArrangedSubview:v3];
    }];
    
    VTTestAll();
}

- (void) testRemovedViews4
{
    [self setSetupStackViewBlock:^(UIStackView* stackView) {
        [stackView vt_applyConsistentDefaults];
        
        // Test removal in a different order
        UIView* v1 = [[stackView arrangedSubviews] objectAtIndex:1];
        UIView* v3 = [[stackView arrangedSubviews] objectAtIndex:3];
        [stackView removeArrangedSubview:v3];
        [stackView removeArrangedSubview:v1];
    }];
    
    VTTestAll();
}

- (void) testRemovedViews5
{
    [self setSetupStackViewBlock:^(UIStackView* stackView) {
        [stackView vt_applyConsistentDefaults];
        
        UIView* v0 = [[stackView arrangedSubviews] firstObject];
        UIView* v4 = [[stackView arrangedSubviews] lastObject];
        [stackView removeArrangedSubview:v0];
        [stackView removeArrangedSubview:v4];
    }];
    
    VTTestAll();
}

- (void) testRemovedViews6
{
    [self setSetupStackViewBlock:^(UIStackView* stackView) {
        [stackView vt_applyConsistentDefaults];
        
        NSArray* views = [stackView arrangedSubviews];
        for (UIView* view in views)
        {
            [stackView removeArrangedSubview:view];
        }
    }];
    
    VTTestAll();
}

- (void) testRemovedViews7
{
    [self setSetupStackViewBlock:^(UIStackView* stackView) {
        [stackView vt_applyConsistentDefaults];
        
        NSArray* views = [stackView arrangedSubviews];
        for (UIView* view in views)
        {
            [stackView removeArrangedSubview:view];
            [view removeFromSuperview];
        }
    }];
    
    VTTestAll();
}

- (void) testRemovedViewsWithSpacing
{
    [self setSetupStackViewBlock:^(UIStackView* stackView) {
        [stackView vt_applyConsistentDefaults];
        
        UIView* v1 = [[stackView arrangedSubviews] objectAtIndex:1];
        UIView* v3 = [[stackView arrangedSubviews] objectAtIndex:3];
        [stackView removeArrangedSubview:v1];
        [stackView removeArrangedSubview:v3];
        
        [stackView setSpacing:10];
    }];
    
    VTTestAll();
}

- (void) testRemovedAndHiddenViews
{
    [self setSetupStackViewBlock:^(UIStackView* stackView) {
        [stackView vt_applyConsistentDefaults];
        
        UIView* v2 = [[stackView arrangedSubviews] objectAtIndex:2];
        UIView* v4 = [[stackView arrangedSubviews] objectAtIndex:4];
        [stackView removeArrangedSubview:v4];
        [v2 setHidden:TRUE];
    }];
    
    VTTestAll();
}

- (void) testSpacing
{
    [self setSetupStackViewBlock:^(UIStackView* stackView) {
        [stackView setAxis:UILayoutConstraintAxisVertical];
        [stackView setSpacing:10];
    }];
    
    VTTestAll();
}

#pragma mark - Alignment

#pragma mark - Distribution

- (void) testHideAndShow
{
    [self setSetupStackViewBlock:^(UIStackView* stackView) {
        [stackView vt_applyConsistentDefaults];
        [stackView setAlignment:UIStackViewAlignmentCenter];
        [stackView setDistribution:UIStackViewDistributionEqualCentering];

        [stackView layoutIfNeeded];
        
        NSArray* views = [stackView arrangedSubviews];
        for (UIView* view in views)
        {
            [view setHidden:TRUE];
        }
        [stackView layoutIfNeeded];
        
        for (UIView* view in views)
        {
            [view setHidden:FALSE];
        }
    }];
    
    VTTestAll();
}

- (void) testRemoveAndReinsert
{
    [self setSetupStackViewBlock:^(UIStackView* stackView) {
        [stackView vt_applyConsistentDefaults];
        [stackView setAlignment:UIStackViewAlignmentCenter];
        [stackView setDistribution:UIStackViewDistributionEqualCentering];
        
        [stackView layoutIfNeeded];
        
        NSArray* views = [stackView arrangedSubviews];
        
        for (UIView* view in views)
        {
            [stackView removeArrangedSubview:view];
            [view removeFromSuperview];
        }
        [stackView layoutIfNeeded];
        
        for (UIView* view in views)
        {
            [stackView addArrangedSubview:view];
        }
    }];
    
    VTTestAll();
}

- (void) testBackgroundColor
{
    [self setSetupStackViewBlock:^(UIStackView* stackView) {
        [stackView vt_applyConsistentDefaults];
        [stackView setAlignment:UIStackViewAlignmentCenter];
        [stackView setSpacing:20];
        
        [stackView setBackgroundColor:[UIColor purpleColor]];
    }];
    
    VTTestAll();
}

- (void) testExternalSubview
{
    [self setSetupStackViewBlock:^(UIStackView* stackView) {
        [stackView vt_applyConsistentDefaults];
        
        UIView* view = [[UIView alloc] init];
        [view setFrame:CGRectMake(10, 10, 20, 20)];
        [view setBackgroundColor:[UIColor purpleColor]];
        [stackView addSubview:view];
    }];
    
    VTTestAll();
}

#pragma mark -

- (void) testAxisHorizontal
{
    [self setSetupStackViewBlock:^(UIStackView* stackView) {
        [stackView vt_applyConsistentDefaults];
        [stackView setAxis:UILayoutConstraintAxisHorizontal];
    }];
    
    VTTestAll();
}

- (void) testAxisVertical
{
    [self setSetupStackViewBlock:^(UIStackView* stackView) {
        [stackView vt_applyConsistentDefaults];
        [stackView setAxis:UILayoutConstraintAxisHorizontal];
    }];
    
    VTTestAll();
}

#pragma mark - 

- (void) testLayoutMarginRelativeArrangementBaseDisabled
{
    [self setSetupStackViewBlock:^(UIStackView* stackView) {
        [stackView vt_applyConsistentDefaults];
        
        [stackView setLayoutMargins:UIEdgeInsetsMake(5, 10, 15, 20)];
        [stackView setSpacing:10];
        [stackView setLayoutMarginsRelativeArrangement:FALSE];
    }];
    
    VTTestAll();
}

- (void) testLayoutMarginRelativeArrangementEnabled
{
    [self setSetupStackViewBlock:^(UIStackView* stackView) {
        [stackView vt_applyConsistentDefaults];
        
        [stackView setLayoutMargins:UIEdgeInsetsMake(5, 10, 15, 20)];
        [stackView setSpacing:10];
        [stackView setLayoutMarginsRelativeArrangement:TRUE];
    }];
    
    VTTestAll();
}



@end
