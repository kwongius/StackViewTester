//
//  VTAlignmentTests.m
//  ViewTester
//
//  Created by Kevin Wong on 11/8/15.
//  Copyright © 2015 Kevin Wong. All rights reserved.
//

#import "VTBaseViewTest.h"

@interface VTAlignmentTests : VTBaseViewTest

@end

@implementation VTAlignmentTests

- (void) testAlignmentFill_Horizontal
{
    [self setSetupStackViewBlock:^(UIStackView* stackView) {
        [stackView vt_applyConsistentDefaults];
        [stackView setAxis:UILayoutConstraintAxisHorizontal];
        [stackView setAlignment:UIStackViewAlignmentFill];
    }];
    
    VTTestAll();
    VTTestAllWithSizes();
}

- (void) testAlignmentFill_Vertical
{
    [self setSetupStackViewBlock:^(UIStackView* stackView) {
        [stackView vt_applyConsistentDefaults];
        [stackView setAxis:UILayoutConstraintAxisVertical];
        [stackView setAlignment:UIStackViewAlignmentFill];
    }];
    
    VTTestAll();
    VTTestAllWithSizes();
}

- (void) testAlignmentLeading_Horizontal
{
    [self setSetupStackViewBlock:^(UIStackView* stackView) {
        [stackView vt_applyConsistentDefaults];
        [stackView setAxis:UILayoutConstraintAxisHorizontal];
        [stackView setAlignment:UIStackViewAlignmentLeading];
    }];
    
    VTTestAll();
    VTTestAllWithSizes();
}

- (void) testAlignmentLeading_Vertical
{
    [self setSetupStackViewBlock:^(UIStackView* stackView) {
        [stackView vt_applyConsistentDefaults];
        [stackView setAxis:UILayoutConstraintAxisVertical];
        [stackView setAlignment:UIStackViewAlignmentLeading];
    }];
    
    VTTestAll();
    VTTestAllWithSizes();
}

- (void) testAlignmentTop_Horizontal
{
    // Should be a duplicate of UIStackViewAlignmentLeading
    [self setSetupStackViewBlock:^(UIStackView* stackView) {
        [stackView vt_applyConsistentDefaults];
        [stackView setAxis:UILayoutConstraintAxisHorizontal];
        [stackView setAlignment:UIStackViewAlignmentTop];
    }];
    
    VTTestAll();
    VTTestAllWithSizes();
}

- (void) testAlignmentTop_Vertical
{
    // Should be a duplicate of UIStackViewAlignmentLeading
    [self setSetupStackViewBlock:^(UIStackView* stackView) {
        [stackView vt_applyConsistentDefaults];
        [stackView setAxis:UILayoutConstraintAxisVertical];
        [stackView setAlignment:UIStackViewAlignmentTop];
    }];
    
    VTTestAll();
    VTTestAllWithSizes();
}

- (void) testAlignmentFirstBaseline
{
    [self setSetupStackViewBlock:^(UIStackView* stackView) {
        [stackView vt_applyConsistentDefaults];
        [stackView setAxis:UILayoutConstraintAxisHorizontal];
        [stackView setAlignment:UIStackViewAlignmentFirstBaseline];
    }];
    
    VTTestAll();
    VTTestAllWithSizes();
}

- (void) testAlignmentFirstBaselineInvalidAxis
{
    // FirstBaseline should only work for vertical
    [self setSetupStackViewBlock:^(UIStackView* stackView) {
        [stackView vt_applyConsistentDefaults];
        [stackView setAxis:UILayoutConstraintAxisVertical];
        [stackView setAlignment:UIStackViewAlignmentFirstBaseline];
    }];
    
    VTTestAll();
    VTTestAllWithSizes();
}

- (void) testAlignmentCenterHorizontal
{
    [self setSetupStackViewBlock:^(UIStackView* stackView) {
        [stackView vt_applyConsistentDefaults];
        [stackView setAxis:UILayoutConstraintAxisHorizontal];
        [stackView setAlignment:UIStackViewAlignmentCenter];
    }];
    
    VTTestAll();
    VTTestAllWithSizes();
}

- (void) testAlignmentCenterVertical
{
    [self setSetupStackViewBlock:^(UIStackView* stackView) {
        [stackView vt_applyConsistentDefaults];
        [stackView setAxis:UILayoutConstraintAxisVertical];
        [stackView setAlignment:UIStackViewAlignmentCenter];
    }];
    
    VTTestAll();
    VTTestAllWithSizes();
}

- (void) testAlignmentTrailing_Horizontal
{
    [self setSetupStackViewBlock:^(UIStackView* stackView) {
        [stackView vt_applyConsistentDefaults];
        [stackView setAxis:UILayoutConstraintAxisHorizontal];
        [stackView setAlignment:UIStackViewAlignmentTrailing];
    }];
    
    VTTestAll();
    VTTestAllWithSizes();
}

- (void) testAlignmentTrailing_Vertical
{
    [self setSetupStackViewBlock:^(UIStackView* stackView) {
        [stackView vt_applyConsistentDefaults];
        [stackView setAxis:UILayoutConstraintAxisVertical];
        [stackView setAlignment:UIStackViewAlignmentTrailing];
    }];
    
    VTTestAll();
    VTTestAllWithSizes();
}

- (void) testAlignmentBottom_Horizontal
{
    // Should be a duplicate of UIStackViewAlignmentLeading
    [self setSetupStackViewBlock:^(UIStackView* stackView) {
        [stackView vt_applyConsistentDefaults];
        [stackView setAxis:UILayoutConstraintAxisHorizontal];
        [stackView setAlignment:UIStackViewAlignmentBottom];
    }];
    
    VTTestAll();
    VTTestAllWithSizes();
}

- (void) testAlignmentBottom_Vertical
{
    // Should be a duplicate of UIStackViewAlignmentLeading
    [self setSetupStackViewBlock:^(UIStackView* stackView) {
        [stackView vt_applyConsistentDefaults];
        [stackView setAxis:UILayoutConstraintAxisVertical];
        [stackView setAlignment:UIStackViewAlignmentBottom];
    }];
    
    VTTestAll();
    VTTestAllWithSizes();
}

- (void) testAlignmentLastBaseline
{
    [self setSetupStackViewBlock:^(UIStackView* stackView) {
        [stackView vt_applyConsistentDefaults];
        [stackView setAxis:UILayoutConstraintAxisHorizontal];
        [stackView setAlignment:UIStackViewAlignmentLastBaseline];
    }];
    
    VTTestAll();
    VTTestAllWithSizes();
}

- (void) testAlignmentLastBaselineInvalidAxis
{
    // FirstBaseline should only work for vertical
    [self setSetupStackViewBlock:^(UIStackView* stackView) {
        [stackView vt_applyConsistentDefaults];
        [stackView setAxis:UILayoutConstraintAxisVertical];
        [stackView setAlignment:UIStackViewAlignmentLastBaseline];
    }];
    
    VTTestAll();
    VTTestAllWithSizes();
}

@end
