//
//  VTInterfaceTests.m
//  ViewTester
//
//  Created by Kevin Wong on 11/20/15.
//  Copyright © 2015 Kevin Wong. All rights reserved.
//

#import "VTBaseViewTest.h"
#import <objc/runtime.h>


@interface VTInterfaceTests : VTBaseViewTest
@end

@implementation VTInterfaceTests

NSArray<NSString*>* publicMethodsForClass(Class cls)
{
    unsigned int count;
    Method* methods = class_copyMethodList([cls class], &count);
    
    if (methods == NULL)
    {
        return @[];
    }
    
    NSMutableArray* selectorNames = [NSMutableArray array];
    
    for (int i = 0; i < count; i++)
    {
        SEL selector = method_getName(methods[i]);
        NSString* selectorName = NSStringFromSelector(selector);
        
        if ([selectorName hasPrefix:@"_"] || [selectorName hasPrefix:@"."] || [selectorName hasPrefix:@"vt_"])
        {
            continue;
        }
        [selectorNames addObject:selectorName];
    }
    
    return selectorNames;
}

#define VTTestMethodsMatch(class, methods) \
({ \
    NSMutableArray* invalidMethods = [NSMutableArray array]; \
    for (NSString* str in methods) \
    { \
        SEL sel = NSSelectorFromString(str); \
        XCTAssertTrue([class instancesRespondToSelector:sel], @"%@ doesn't respond to selector: %@", [self identifierFromClass:class], str); \
        if (![class instancesRespondToSelector:sel]) \
        { \
            [invalidMethods addObject:str]; \
        } \
    } \
    [self writeMetadata:invalidMethods forClass:class withMetadataName:@"missingMethods"]; \
})

- (void) testMethods
{
    NSMutableArray* baseMethods = [NSMutableArray arrayWithArray:publicMethodsForClass([UIStackView class])];

    // Public header is marked read only for the arrangedSubviews property,
    // even though the selector still exists privately
    [baseMethods removeObject:@"setArrangedSubviews:"];
    
    // Remove UI View methods. Not necessary, but base methods now only contains UIStackView selector names
    [baseMethods removeObjectsInArray:publicMethodsForClass([UIView class])];

    VTTestMethodsMatch([OAStackView class], baseMethods);
    VTTestMethodsMatch([TZStackView class], baseMethods);
    VTTestMethodsMatch([FDStackView class], baseMethods);
}

- (void) testConstants_OAStackViewAlignment_DuplicateNames
{
    // Assert duplicate names
    XCTAssertEqual(OAStackViewAlignmentTop, OAStackViewAlignmentLeading);
    XCTAssertEqual(OAStackViewAlignmentBottom, OAStackViewAlignmentTrailing);
}

- (void) testConstants_OAStackViewAlignment_UnderlyingValue
{
    // Ensure alignments match up
    XCTAssertEqual(UIStackViewAlignmentFill, OAStackViewAlignmentFill);
    XCTAssertEqual(UIStackViewAlignmentLeading, OAStackViewAlignmentLeading);
    XCTAssertEqual(UIStackViewAlignmentTop, OAStackViewAlignmentTop);
    XCTAssertEqual(UIStackViewAlignmentLeading, OAStackViewAlignmentLeading);
    XCTAssertEqual(UIStackViewAlignmentFirstBaseline, OAStackViewAlignmentFirstBaseline);
    XCTAssertEqual(UIStackViewAlignmentCenter, OAStackViewAlignmentCenter);
    XCTAssertEqual(UIStackViewAlignmentTrailing, OAStackViewAlignmentTrailing);
    XCTAssertEqual(UIStackViewAlignmentBottom, OAStackViewAlignmentBottom);
    XCTAssertEqual(UIStackViewAlignmentLastBaseline, OAStackViewAlignmentLastBaseline);
}

- (void) testConstants_OAStackViewDistribution
{
    XCTAssertEqual(UIStackViewDistributionFill, OAStackViewDistributionFill);
    XCTAssertEqual(UIStackViewDistributionFillEqually, OAStackViewDistributionFillEqually);
    XCTAssertEqual(UIStackViewDistributionFillProportionally, OAStackViewDistributionFillProportionally);
    XCTAssertEqual(UIStackViewDistributionEqualSpacing, OAStackViewDistributionEqualSpacing);
    XCTAssertEqual(UIStackViewDistributionEqualCentering, OAStackViewDistributionEqualCentering);
}

- (void) testConstants_TZStackViewAlignment_DuplicateNames
{
    // Assert duplicate names
    XCTAssertEqual(TZStackViewAlignmentTop, TZStackViewAlignmentLeading);
    XCTAssertEqual(TZStackViewAlignmentBottom, TZStackViewAlignmentTrailing);
}

- (void) testConstants_TZStackViewAlignment_UnderlyingValue
{
    // Ensure alignments match up
    XCTAssertEqual(UIStackViewAlignmentFill, TZStackViewAlignmentFill);
    XCTAssertEqual(UIStackViewAlignmentLeading, TZStackViewAlignmentLeading);
    XCTAssertEqual(UIStackViewAlignmentTop, TZStackViewAlignmentTop);
    XCTAssertEqual(UIStackViewAlignmentLeading, TZStackViewAlignmentLeading);
    XCTAssertEqual(UIStackViewAlignmentFirstBaseline, TZStackViewAlignmentFirstBaseline);
    XCTAssertEqual(UIStackViewAlignmentCenter, TZStackViewAlignmentCenter);
    XCTAssertEqual(UIStackViewAlignmentTrailing, TZStackViewAlignmentTrailing);
    XCTAssertEqual(UIStackViewAlignmentBottom, TZStackViewAlignmentBottom);
//    XCTAssertEqual(UIStackViewAlignmentLastBaseline, TZStackViewAlignmentLastBaseline);
    XCTFail(@"TZStackViewAlignmentLastBaseline is not defined");
}

- (void) testConstants_TZStackViewDistribution
{
    XCTAssertEqual(UIStackViewDistributionFill, TZStackViewDistributionFill);
    XCTAssertEqual(UIStackViewDistributionFillEqually, TZStackViewDistributionFillEqually);
    XCTAssertEqual(UIStackViewDistributionFillProportionally, TZStackViewDistributionFillProportionally);
    XCTAssertEqual(UIStackViewDistributionEqualSpacing, TZStackViewDistributionEqualSpacing);
    XCTAssertEqual(UIStackViewDistributionEqualCentering, TZStackViewDistributionEqualCentering);
}

@end
