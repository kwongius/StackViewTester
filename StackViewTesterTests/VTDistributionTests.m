//
//  VTDistributionTests.m
//  ViewTester
//
//  Created by Kevin Wong on 11/8/15.
//  Copyright © 2015 Kevin Wong. All rights reserved.
//

#import "VTBaseViewTest.h"

@interface VTDistributionTests : VTBaseViewTest

@end

@implementation VTDistributionTests

- (void) testDistributionFill
{
    // FirstBaseline should only work for vertical
    [self setSetupStackViewBlock:^(UIStackView* stackView) {
        [stackView vt_applyConsistentDefaults];
        [stackView setAlignment:UIStackViewAlignmentCenter];
        [stackView setDistribution:UIStackViewDistributionFill];
    }];
    
    VTTestAll();
    VTTestAllWithSizes();
}

- (void) testDistributionFillEqually
{
    // FirstBaseline should only work for vertical
    [self setSetupStackViewBlock:^(UIStackView* stackView) {
        [stackView vt_applyConsistentDefaults];
        [stackView setAlignment:UIStackViewAlignmentCenter];
        [stackView setDistribution:UIStackViewDistributionFillEqually];
    }];
    
    VTTestAll();
    VTTestAllWithSizes();
}

- (void) testDistributionFillProportionally
{
    // FirstBaseline should only work for vertical
    [self setSetupStackViewBlock:^(UIStackView* stackView) {
        [stackView vt_applyConsistentDefaults];
        [stackView setAlignment:UIStackViewAlignmentCenter];
        [stackView setDistribution:UIStackViewDistributionFillProportionally];
    }];
    
    VTTestAll();
    VTTestAllWithSizes();
}

- (void) testDistributionEqualSpacing
{
    // FirstBaseline should only work for vertical
    [self setSetupStackViewBlock:^(UIStackView* stackView) {
        [stackView vt_applyConsistentDefaults];
        [stackView setAlignment:UIStackViewAlignmentCenter];
        [stackView setDistribution:UIStackViewDistributionEqualSpacing];
    }];
    
    VTTestAll();
    VTTestAllWithSizes();
}

- (void) testDistributionEqualCentering
{
    // FirstBaseline should only work for vertical
    [self setSetupStackViewBlock:^(UIStackView* stackView) {
        [stackView vt_applyConsistentDefaults];
        [stackView setAlignment:UIStackViewAlignmentCenter];
        [stackView setDistribution:UIStackViewDistributionEqualCentering];
    }];
    
    VTTestAll();
    VTTestAllWithSizes();
}

@end
