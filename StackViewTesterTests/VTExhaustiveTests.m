
//  VTExhaustiveTests.m
//  ViewTester
//
//  Created by Kevin Wong on 11/8/15.
//  Copyright © 2015 Kevin Wong. All rights reserved.
//

#import "VTBaseViewTest.h"

void cleanupLayer(CALayer* layer)
{
    [layer setContents:nil];
    layer.contents = nil;
    for (CALayer* l in [layer sublayers])
    {
        cleanupLayer(l);
    }
}

#define TEST_EXHAUSTIVE 0

@interface VTControlStackView : UIStackView
@end


typedef NS_ENUM(NSInteger, VTViewType)
{
    VTViewTypeSimple,
    VTViewTypeWithLabels,
};

typedef NS_ENUM(NSInteger, VTHiddenViews)
{
    VTHiddenViewsNone,
    VTHiddenViewsOdd,
};

@interface VTStackViewParameters : NSObject

@property (nonatomic) VTViewType viewType;
@property (nonatomic) VTHiddenViews hiddenViews;

@property (nonatomic) UILayoutConstraintAxis axis;
@property (nonatomic) UIStackViewDistribution distribution;
@property (nonatomic) UIStackViewAlignment alignment;
@property (nonatomic) CGFloat spacing;
@property (nonatomic,getter=isBaselineRelativeArrangement) BOOL baselineRelativeArrangement;
@property (nonatomic,getter=isLayoutMarginsRelativeArrangement) BOOL layoutMarginsRelativeArrangement;

@property (nonatomic) UIEdgeInsets layoutMargins;

@property (nonatomic, getter=isDefaultSize) BOOL defaultSize;
@property (nonatomic) CGSize size;

@property (nonatomic, readonly, getter=isValid) BOOL valid;
@property (nonatomic, copy) NSString* key;

@end

@implementation VTStackViewParameters : NSObject

- (BOOL)isValid
{
    BOOL baseline = (_alignment == UIStackViewAlignmentFirstBaseline || _alignment == UIStackViewAlignmentLastBaseline);
    if (baseline && _axis != UILayoutConstraintAxisHorizontal)
    {
        return FALSE;
    }
    
    if (baseline && !_defaultSize)
    {
        return FALSE;
    }
    
    if (_baselineRelativeArrangement && _axis != UILayoutConstraintAxisVertical)
    {
        return FALSE;
    }
    
    return TRUE;
}

@end



@interface VTExhaustiveTests : VTBaseViewTest

@property (nonatomic, copy) NSMutableDictionary* metadata;

@end

@implementation VTExhaustiveTests

- (void)setUp
{
    [super setUp];
    
    _metadata = [NSMutableDictionary dictionary];
    
    [self setSaveSnapshot:FALSE];
}

#if TEST_EXHAUSTIVE
- (void) testExhaustive
{
    NSDictionary* viewTypes = @{
                                @(VTViewTypeSimple) : @"simpleViews",
                                @(VTViewTypeWithLabels) : @"viewsWithLabels",
                                };
    
    NSDictionary* alignments = @{
                                 @(UIStackViewAlignmentFill) : @"fill",
                                 @(UIStackViewAlignmentLeading) : @"leading",
                                 @(UIStackViewAlignmentFirstBaseline) : @"firstBaseline",
                                 @(UIStackViewAlignmentCenter) : @"center",
                                 @(UIStackViewAlignmentTrailing) : @"trailing",
                                 @(UIStackViewAlignmentLastBaseline) : @"lastBaseline",
                                 };

    NSDictionary* axes = @{
                           @(UILayoutConstraintAxisHorizontal) : @"horizontal",
                           @(UILayoutConstraintAxisVertical) : @"vertical",
                           };
    
    NSDictionary* distributions = @{
                                    @(UIStackViewDistributionFill) : @"fill",
                                    @(UIStackViewDistributionFillEqually) : @"fillEqually",
                                    @(UIStackViewDistributionFillProportionally) : @"fillProportionally",
                                    @(UIStackViewDistributionEqualSpacing) : @"equalSpacing",
                                    @(UIStackViewDistributionEqualCentering) : @"equalCentering",
                                    };
    
    NSDictionary* spacings = @{
                               @(0) : @"sp0",
                               @(10) : @"sp10",
                               };
    
    NSDictionary* baselineArrangements = @{
                                           @(TRUE) : @"baseline+",
                                           @(FALSE) : @"baseline-",
                                           };

    NSDictionary* layoutMarginsArrangements = @{
                                                @(TRUE) : @"margins+",
                                                @(FALSE) : @"margins-",
                                                };

    NSDictionary* layoutMargins = @{
                                    [NSValue valueWithUIEdgeInsets:UIEdgeInsetsZero] : @"0.0.0.0",
                                    [NSValue valueWithUIEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)] : @"5.5.5.5",
                                    };
    
    NSDictionary* sizes = @{
                            [NSValue valueWithCGSize:CGSizeMake(2000, 2000)] : @"(2000,2000)",
                            [NSValue valueWithCGSize:CGSizeMake(20, 20)] : @"(20,20)",
                            [NSValue valueWithCGSize:CGSizeMake(-1, -1)] : @"default",
                            };
    
    NSDictionary* hiddenViews = @{
                                  @(0) : @"none",
                                  @(1) : @"oddviews",
                                  };
    

    //--------------------------------------------------//

    // Generate all possible permutations of parameters
    
    NSMutableArray* params = [NSMutableArray array];
    
    for (NSNumber* vt in [viewTypes allKeys])
    {
        for (NSNumber* al in [alignments allKeys])
        {
            for (NSNumber* ax in [axes allKeys])
            {
                for (NSNumber* d in [distributions allKeys])
                {
                    for (NSNumber* sp in [spacings allKeys])
                    {
                        for (NSNumber* ba in [baselineArrangements allKeys])
                        {
                            for (NSNumber* lma in [layoutMarginsArrangements allKeys])
                            {
                                for (NSValue* lm in [layoutMargins allKeys])
                                {
                                    for (NSValue* sz in [sizes allKeys])
                                    {
                                        for (NSNumber* hv in [hiddenViews allKeys])
                                        {
                                            VTStackViewParameters* p = [[VTStackViewParameters alloc] init];
                                            [p setViewType:(VTViewType)[vt unsignedIntegerValue]];
                                            [p setAlignment:(UIStackViewAlignment)[al unsignedIntegerValue]];
                                            [p setAxis:(UILayoutConstraintAxis)[ax unsignedIntegerValue]];
                                            [p setDistribution:(UIStackViewDistribution)[d unsignedIntegerValue]];
                                            [p setSpacing:[sp doubleValue]];
                                            [p setBaselineRelativeArrangement:[ba boolValue]];
                                            [p setLayoutMarginsRelativeArrangement:[lma boolValue]];
                                            [p setLayoutMargins:[lm UIEdgeInsetsValue]];
                                            [p setSize:[sz CGSizeValue]];
                                            [p setDefaultSize:([p size].width < 0 && [p size].height < 0)];
                                            [p setHiddenViews:(VTHiddenViews)[hv unsignedIntegerValue]];
                                            
                                            NSString* key = [NSString stringWithFormat:@"__%@_%@_%@_%@_%@_%@_%@_%@_%@_%@", viewTypes[vt], alignments[al], axes[ax], distributions[d], spacings[sp], baselineArrangements[ba], layoutMarginsArrangements[lma], layoutMargins[lm], sizes[sz], hiddenViews[hv]];
                                            [p setKey:key];

                                            [params addObject:p];
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    NSUInteger testCount = 0;
    NSUInteger totalTests = [params count];
    NSUInteger controlSuccessCount = 0;

    NSDate* startTime = [NSDate date];
    
    // Perform test for all parameters
    for (VTStackViewParameters* p in params)
    {
        NSTimeInterval elapsed = [[NSDate date] timeIntervalSinceDate:startTime];
        NSUInteger remainingTime = 0;
        if (testCount > 20)
        {
            NSUInteger remainingTests = totalTests - testCount;
            NSTimeInterval testRate = elapsed / testCount;
            remainingTime = (NSUInteger)(testRate * remainingTests);
        }
        testCount++;
        printf("\n\n==========\nTesting %zd/%zd\n", testCount, totalTests);
        if (remainingTime > 0)
        {
            printf("Remaining time: %zd:%02zd\n", remainingTime / 60, remainingTime % 60);
        }
        printf("\n\n\n");
        
        @autoreleasepool {
            switch ([p viewType])
            {
                case VTViewTypeSimple:
                    [self setSetupArrangedViews:^NSArray* (UIStackView* stackView) {
                        return [VTTestViewGroups simpleViews];
                    }];
                    break;
                case VTViewTypeWithLabels:
                    [self setSetupArrangedViews:^NSArray* (UIStackView* stackView) {
                        return [VTTestViewGroups viewsWithLabels];
                    }];
                    break;
            }
            
            [self setSetupStackViewBlock:^(UIStackView* stackView) {
                [stackView setAlignment:[p alignment]];
                [stackView setAxis:[p axis]];
                [stackView setDistribution:[p distribution]];
                [stackView setSpacing:[p spacing]];
                [stackView vt_safe_setBaselineRelativeArrangement:[p isBaselineRelativeArrangement]];
                [stackView setLayoutMarginsRelativeArrangement:[p isLayoutMarginsRelativeArrangement]];
                [stackView setLayoutMargins:[p layoutMargins]];
                if (![p isDefaultSize])
                {
                    [stackView vt_setExplicitSize:[p size]];
                }
                
                switch ([p hiddenViews])
                {
                    case VTHiddenViewsNone:
                        break;
                    case VTHiddenViewsOdd:
                        [[stackView arrangedSubviews] enumerateObjectsUsingBlock:^(UIView * obj, NSUInteger idx, BOOL * stop) {
                            [obj setHidden:idx % 2 == 1];
                        }];
                        break;
                }
            }];
            
            [self reinitializeAllStackViews];
            
            NSString* testNameWithSuffix = [NSString stringWithFormat:@"%@_%@", VTTestName(), [p key]];
            [self prepareBaseImage:[self uiStackView] testName:testNameWithSuffix];
            BOOL oaSuccess = VTSnapshotVerifyView([self oaStackView], testNameWithSuffix);
            BOOL tzSuccess = VTSnapshotVerifyView([self tzStackView], testNameWithSuffix);
            BOOL fdSuccess = VTSnapshotVerifyView([self fdStackView], testNameWithSuffix);
            BOOL vtControlSuccess = VTSnapshotVerifyView([self vtControlStackView], testNameWithSuffix);
            

            if (vtControlSuccess)
            {
                controlSuccessCount++;
            }
            
#define storeMetadata(class, success) \
({ \
    NSDictionary* sharedMetadata = @{@"success" : @(success), @"valid": @([p isValid]), @"hiddenViews" : hiddenViews[@([p hiddenViews])], @"viewTypes" : viewTypes[@([p viewType])]}; \
    NSMutableDictionary* testMetadata = [[[self uiStackView] vt_metadata] mutableCopy]; \
    [testMetadata addEntriesFromDictionary:sharedMetadata]; \
    [[self metadataForClass:class] addObject:testMetadata]; \
})

            storeMetadata([OAStackView class], oaSuccess);
            storeMetadata([TZStackView class], tzSuccess);
            storeMetadata([FDStackView class], fdSuccess);
            storeMetadata([VTControlStackView class], vtControlSuccess);
            
            
            // Forcibly cleanup the layer to help free up memory
            for (UIView* view in [self allStackViews])
            {
                cleanupLayer([view layer]);
            }
        }
    }
    
#if VT_TEST_OASTACKVIEW
    [self writeResultsMetadataForClass:[OAStackView class]];
#endif

#if VT_TEST_TZSTACKVIEW
    [self writeResultsMetadataForClass:[TZStackView class]];
#endif
    
#if VT_TEST_FDSTACKVIEW
    [self writeResultsMetadataForClass:[FDStackView class]];
#endif

#if VT_TEST_CONTROL_VTSTACKVIEW
    [self writeResultsMetadataForClass:[VTControlStackView class]];

    // check control
    NSAssert(controlSuccessCount == testCount, @"");
    //XCTAssertEqual(controlSuccessCount, testCount);
#endif

    NSTimeInterval duration = [[NSDate date] timeIntervalSinceDate:startTime];
    [self writeMetadata:@{
                          @"startTime" : @([startTime timeIntervalSince1970]),
                          @"tests" : @(testCount),
                          @"time" : @(duration)
                          } forClass:nil withMetadataName:@"exhaustiveTime"];
}
#endif

- (void) writeResultsMetadataForClass:(Class)cls
{
    [self writeMetadata:[self metadataForClass:cls] forClass:cls withMetadataName:@"metadata"];
}

- (NSMutableArray*) metadataForClass:(Class)cls
{
    NSString* className = NSStringFromClass(cls);
    NSMutableArray* metadata = [_metadata objectForKey:className];
    if (metadata == nil)
    {
        metadata = [NSMutableArray array];
        [_metadata setObject:metadata forKey:className];
    }
    
    return metadata;
}

@end
