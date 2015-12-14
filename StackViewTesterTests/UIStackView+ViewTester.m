
//
//  UIStackView+ViewTester.m
//  ViewTester
//
//  Created by Kevin Wong on 11/7/15.
//  Copyright © 2015 Kevin Wong. All rights reserved.
//

#import "UIStackView+ViewTester.h"

#import <TZStackView/TZStackView-Swift.h>
#import <OAStackView/OAStackView.h>
#import <FDStackView/FDStackView.h>

#import <PureLayout/PureLayout.h>

#import <objc/runtime.h>


static inline BOOL vt_addMethod(Class class, Class sender, SEL selector)
{
    Method method = class_getInstanceMethod(sender, selector);
    return class_addMethod(class, selector, method_getImplementation(method), method_getTypeEncoding(method));
}

static inline void vt_swizzleInstanceMethod(Class class, Class sender, SEL originalSelector, SEL swizzledSelector)
{
    NSCAssert([class instancesRespondToSelector:originalSelector], @"Instances of %@ must respond to selector %@", NSStringFromClass(class), NSStringFromSelector(originalSelector));

    vt_addMethod(class, class, originalSelector);
    vt_addMethod(class, sender, swizzledSelector);
    
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    method_exchangeImplementations(originalMethod, swizzledMethod);
}

@implementation UIView (ViewTester)

- (void) vt_setSnapshotImage:(UIImage*)image
{
    objc_setAssociatedObject(self, @selector(vt_snapshotImage), image, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIImage*) vt_snapshotImage
{
    return objc_getAssociatedObject(self, @selector(vt_snapshotImage));
}

static void* vt_constraints = &vt_constraints;

- (void) vt_setExplicitSize:(CGSize)size
{
    NSArray* constraints = [self autoSetDimensionsToSize:size];
    
    objc_setAssociatedObject(self, @selector(vt_explicitSize), [NSValue valueWithCGSize:size], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &vt_constraints, constraints, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSValue*) vt_explicitSize
{
    return objc_getAssociatedObject(self, @selector(vt_explicitSize));
}

- (void) vt_removeExplicitSize
{
    NSArray* constraints = objc_getAssociatedObject(self, &vt_constraints);
    [constraints autoRemoveConstraints];

    objc_setAssociatedObject(self, @selector(vt_explicitSize), nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &vt_constraints, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


@end

@implementation UIStackView (ViewTester)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSArray* classes = @[[OAStackView class], [TZStackView class], [FDStackView class]];
        for (Class c in classes)
        {
            [self addMethodsForClass:c];
        }
    });
}

+ (void) addMethodsForClass:(Class)c
{
    vt_addMethod(c, self, @selector(vt_applyConsistentDefaults));

    // Required for OAStackView, which does not properly maintain it's array of arranged subviews
    // This is required as of version 0.2.0 (230798bc02a662d292e2d5ee872f92ba2a263a59)
    vt_swizzleInstanceMethod(c, self, @selector(initWithArrangedSubviews:), @selector(vt_initWithArrangedSubviews:));
    vt_swizzleInstanceMethod(c, self, @selector(insertArrangedSubview:atIndex:), @selector(vt_insertArrangedSubview:atIndex:));
    vt_swizzleInstanceMethod(c, self, @selector(removeArrangedSubview:), @selector(vt_removeArrangedSubview:));
    vt_swizzleInstanceMethod(c, self, @selector(arrangedSubviews), @selector(vt_arrangedSubviews));

    vt_addMethod(c, self, @selector(vt_safe_setBaselineRelativeArrangement:));
    vt_addMethod(c, self, @selector(vt_safe_isBaselineRelativeArrangement));
    vt_addMethod(c, self, @selector(vt_safe_isLayoutMarginsRelativeArrangement));
    
    vt_addMethod(c, self, @selector(vt_metadata));
    
    vt_swizzleInstanceMethod(c, self, @selector(setAlignment:), @selector(vt_setAlignment:));
    vt_swizzleInstanceMethod(c, self, @selector(alignment), @selector(vt_alignment));
}

#pragma mark - Fix alignment

static inline TZStackViewAlignment alignmentToTzStackViewAlignment(UIStackViewAlignment alignment)
{
    switch (alignment) {
        case UIStackViewAlignmentFill:
            return TZStackViewAlignmentFill;
        case UIStackViewAlignmentLeading:
            return TZStackViewAlignmentLeading;
//        case UIStackViewAlignmentTop:
//            return TZStackViewAlignmentTop;
        case UIStackViewAlignmentFirstBaseline:
            return TZStackViewAlignmentFirstBaseline;
        case UIStackViewAlignmentCenter:
            return TZStackViewAlignmentCenter;
        case UIStackViewAlignmentTrailing:
            return TZStackViewAlignmentTrailing;
//        case UIStackViewAlignmentBottom:
//            return TZStackViewAlignmentBottom;
        case UIStackViewAlignmentLastBaseline:
            return TZStackViewAlignmentFill;
//            return TZStackViewAlignmentLastBaseline;
    }
}

- (UIStackViewAlignment)vt_alignment
{
    if ([self class] == [TZStackView class])
    {
        return [objc_getAssociatedObject(self, @selector(alignment)) integerValue];
    }
    else
    {
        return [self vt_alignment];
    }
}

- (void)vt_setAlignment:(UIStackViewAlignment)alignment
{
    if ([self class] == [TZStackView class])
    {
        objc_setAssociatedObject(self, @selector(alignment), @(alignment), OBJC_ASSOCIATION_RETAIN_NONATOMIC);

        [self vt_setAlignment:(NSInteger)alignmentToTzStackViewAlignment(alignment)];
    }
    else
    {
        [self vt_setAlignment:alignment];
    }
}

#pragma mark - Fix arrangedSubviews

- (instancetype)vt_initWithArrangedSubviews:(NSArray<__kindof UIView *> *)views
{
    id _self = [self vt_initWithArrangedSubviews:views];
    
    if ([self class] == [OAStackView class])
    {
        objc_setAssociatedObject(self, @selector(arrangedSubviews), [NSMutableArray arrayWithArray:views ?: @[]], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }

    return _self;
}

- (NSArray<UIView *> *)vt_arrangedSubviews
{
    if ([self class] == [OAStackView class])
    {
        return [objc_getAssociatedObject(self, @selector(arrangedSubviews)) copy];
    }
    
    return [self vt_arrangedSubviews];
}

- (void)vt_insertArrangedSubview:(UIView *)view atIndex:(NSUInteger)stackIndex
{
    if ([self class] == [OAStackView class])
    {
        [objc_getAssociatedObject(self, @selector(arrangedSubviews)) insertObject:view atIndex:stackIndex];
    }

    [self vt_insertArrangedSubview:view atIndex:stackIndex];
}

- (void)vt_removeArrangedSubview:(UIView *)view
{
    if ([self class] == [OAStackView class])
    {
        [objc_getAssociatedObject(self, @selector(arrangedSubviews)) removeObject:view];
    }

    [self vt_removeArrangedSubview:view];
}

#pragma mark - Baseline Relative Arrangement

- (void) vt_safe_setBaselineRelativeArrangement:(BOOL)baselineRelativeArrangement
{
    if ([self respondsToSelector:@selector(setBaselineRelativeArrangement:)])
    {
        [self setBaselineRelativeArrangement:baselineRelativeArrangement];
    }
    else
    {
        objc_setAssociatedObject(self, @selector(isBaselineRelativeArrangement), @(baselineRelativeArrangement), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

- (BOOL) vt_safe_isBaselineRelativeArrangement
{
    if ([self respondsToSelector:@selector(isBaselineRelativeArrangement)])
    {
        return [self isBaselineRelativeArrangement];
    }
    
    return [objc_getAssociatedObject(self, @selector(isBaselineRelativeArrangement)) boolValue];
}

#pragma mark - Layout Margins Relative Arrangement

- (BOOL) vt_safe_isLayoutMarginsRelativeArrangement
{
    if ([self class] == [TZStackView class])
    {
        return [(TZStackView*)self layoutMarginsRelativeArrangement];
    }

    return [self isLayoutMarginsRelativeArrangement];
}




#pragma mark -

- (void)vt_applyConsistentDefaults
{
    [self setAlignment:UIStackViewAlignmentFill];
    [self setAxis:UILayoutConstraintAxisHorizontal];
    // TZStackView doesn't respond to baseline relative arrangement
    [self vt_safe_setBaselineRelativeArrangement:FALSE];
    [self setDistribution:UIStackViewDistributionFill];
    [self setLayoutMarginsRelativeArrangement:FALSE];
    [self setSpacing:0.0f];
}

- (NSDictionary*) vt_metadata
{
    NSMutableDictionary* metadata = [NSMutableDictionary dictionary];

    NSString* alignment;
    NSString* axis;
    NSString* distribution;
    NSString* explicitSize;
    
    switch ([self alignment]) {
        case UIStackViewAlignmentFill:
            alignment = @"Fill";
            break;
        case UIStackViewAlignmentLeading:
            alignment = @"Leading";
            break;
        case UIStackViewAlignmentFirstBaseline:
            alignment = @"FirstBaseline";
            break;
        case UIStackViewAlignmentCenter:
            alignment = @"Center";
            break;
        case UIStackViewAlignmentTrailing:
            alignment = @"Trailing";
            break;
        case UIStackViewAlignmentLastBaseline:
            alignment = @"LastBaseline";
            break;
            
        default:
            break;
    }
    
    switch ([self axis]) {
        case UILayoutConstraintAxisHorizontal:
            axis = @"Horizontal";
            break;
        case UILayoutConstraintAxisVertical:
            axis = @"Vertical";
            break;
    }

    switch ([self distribution]) {
        case UIStackViewDistributionFill:
            distribution = @"Fill";
            break;
        case UIStackViewDistributionFillEqually:
            distribution = @"FillEqually";
            break;
        case UIStackViewDistributionFillProportionally:
            distribution = @"FillProportionally";
            break;
        case UIStackViewDistributionEqualSpacing:
            distribution = @"EqualSpacing";
            break;
        case UIStackViewDistributionEqualCentering:
            distribution = @"EqualCentering";
            break;
    }
    
    NSValue* sizeValue = [self vt_explicitSize];
    explicitSize = sizeValue ? NSStringFromCGSize([sizeValue CGSizeValue]) : @"not set";

    metadata[@"alignment"] = alignment;
    metadata[@"axis"] = axis;
    metadata[@"distribution"] = distribution;
    metadata[@"spacing"] = @([self spacing]);
    metadata[@"baselineRelativeArrangement"] = @([self vt_safe_isBaselineRelativeArrangement]);
    metadata[@"layoutMarginRelativeArrangement"] = @([self vt_safe_isLayoutMarginsRelativeArrangement]);
    metadata[@"layoutMargins"] = NSStringFromUIEdgeInsets([self layoutMargins]);
    metadata[@"explicitSize"] = explicitSize;
    
    return metadata;
}

@end


#pragma mark - OAStackView Arranged Subviews

#if FALSE
#import "VTTestView.h"
#import <XCTest/XCTest.h>

@interface OAStackViewArrangedSubviewsTest : XCTestCase
@end

@implementation OAStackViewArrangedSubviewsTest

- (void) testInit
{
    OAStackView* stackView = [[OAStackView alloc] init];
    XCTAssertNotNil([stackView arrangedSubviews]);
    XCTAssertEqual([[stackView arrangedSubviews] count], 0);
}

- (void) testInitWithEmptySubviews
{
    OAStackView* stackView = [[OAStackView alloc] initWithArrangedSubviews:@[]];
    XCTAssertNotNil([stackView arrangedSubviews]);
    XCTAssertEqual([[stackView arrangedSubviews] count], 0);
}

- (void) testInitWithSubviews
{
    NSArray* views = [VTTestViewGroups simpleViews];
    OAStackView* stackView = [[OAStackView alloc] initWithArrangedSubviews:views];
    XCTAssertNotNil([stackView arrangedSubviews]);
    XCTAssertEqual([[stackView arrangedSubviews] count], 5);
    
    XCTAssertEqual([[[stackView arrangedSubviews] objectAtIndex:0] tag], 0);
    XCTAssertEqual([[[stackView arrangedSubviews] objectAtIndex:4] tag], 4);
}

- (void) testAddArranged
{
    NSArray* views = [VTTestViewGroups simpleViews];
    
    OAStackView* stackView = [[OAStackView alloc] init];
    
    for (UIView* view in views)
    {
        [stackView addArrangedSubview:view];
    }
    XCTAssertNotNil([stackView arrangedSubviews]);
    XCTAssertEqual([[stackView arrangedSubviews] count], 5);

    XCTAssertEqual([[[stackView arrangedSubviews] objectAtIndex:0] tag], 0);
    XCTAssertEqual([[[stackView arrangedSubviews] objectAtIndex:4] tag], 4);
}

- (void) testInsertArranged
{
    NSArray* views = [VTTestViewGroups simpleViews];
    
    OAStackView* stackView = [[OAStackView alloc] init];
    
    for (UIView* view in views)
    {
        [stackView insertArrangedSubview:view atIndex:0];
    }
    XCTAssertNotNil([stackView arrangedSubviews]);
    XCTAssertEqual([[stackView arrangedSubviews] count], 5);
    
    XCTAssertEqual([[[stackView arrangedSubviews] objectAtIndex:4] tag], 0);
    XCTAssertEqual([[[stackView arrangedSubviews] objectAtIndex:0] tag], 4);
}

- (void) testInsertAndAddArranged
{
    NSArray* views = [VTTestViewGroups simpleViews];
    
    OAStackView* stackView = [[OAStackView alloc] init];
    
    // 2 1 0 3 4
    [stackView insertArrangedSubview:views[0] atIndex:0];
    [stackView insertArrangedSubview:views[1] atIndex:0];
    [stackView insertArrangedSubview:views[2] atIndex:0];
    [stackView addArrangedSubview:views[3]];
    [stackView addArrangedSubview:views[4]];
    
    XCTAssertNotNil([stackView arrangedSubviews]);
    XCTAssertEqual([[stackView arrangedSubviews] count], 5);
    
    XCTAssertEqual([[[stackView arrangedSubviews] objectAtIndex:0] tag], 2);
    XCTAssertEqual([[[stackView arrangedSubviews] objectAtIndex:4] tag], 4);
}
@end
#endif