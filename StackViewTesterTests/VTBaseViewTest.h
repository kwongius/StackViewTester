//
//  VTBaseViewTest.h
//  ViewTester
//
//  Created by Kevin Wong on 11/7/15.
//  Copyright © 2015 Kevin Wong. All rights reserved.
//

#import <OAStackView/OAStackView.h>
#import <TZStackView/TZStackView-Swift.h>
#import <FDStackView/FDStackView.h>

#import <FBSnapshotTestCase/FBSnapshotTestCase.h>
#import <FBSnapshotTestCase/FBSnapshotTestController.h>
#import "VTTestView.h"
#import "UIStackView+ViewTester.h"
#import <PureLayout/PureLayout.h>

#define VT_TEST_OASTACKVIEW 1
#define VT_TEST_TZSTACKVIEW 1
#define VT_TEST_FDSTACKVIEW 1
#define VT_TEST_CONTROL_VTSTACKVIEW 0

#define VT_SNAPSHOT_TESTING 1
#define VT_FRAME_TESTING 0





//! Test Name based on the selector
#define VTTestName() ({ NSStringFromSelector([[self invocation] selector]); })

//! Verify view against snapshot of the base image
#define VTSnapshotVerifyView(view, testName_) \
({ \
    BOOL match = FALSE; \
    if ( \
        view != nil && ( \
        (VT_TEST_OASTACKVIEW && view == [self oaStackView]) || \
        (VT_TEST_TZSTACKVIEW && view == [self tzStackView]) || \
        (VT_TEST_FDSTACKVIEW && view == [self fdStackView]) || \
        (VT_TEST_CONTROL_VTSTACKVIEW && view == [self vtControlStackView])    \
       )) \
    { \
        [self setupStackView:view]; \
        NSError* error; \
        BOOL match1 = (VT_SNAPSHOT_TESTING ? [self snapshotVerifyView:view testName:testName_ error:&error] : TRUE); \
        BOOL match2 = (VT_FRAME_TESTING ? [self compareViewFramesForView:[self uiStackView] toView:view] : TRUE); \
        XCTAssertTrue(match1, @"[%@]: Image comparison failed: %@", [self identifierFromClass:[view class]], error); \
        XCTAssertTrue(match2, @"[%@]: Arranged View frame mismatch", [self identifierFromClass:[view class]]); \
        match = match1 && match2; \
    } \
    match; \
})

//! Run snapshot verification for all classes
#define VTTestAll() ({ VTTestAllWithSuffix(nil); })

//! Run snapshot verification for all classes
#define VTTestAllWithSuffix(suffix) \
({ \
    NSString* testNameWithSuffix = suffix == nil ? nil : [NSString stringWithFormat:@"%@_%@", VTTestName(), suffix]; \
    [self prepareBaseImage:[self uiStackView] testName:testNameWithSuffix]; \
    VTSnapshotVerifyView([self oaStackView], testNameWithSuffix); \
    VTSnapshotVerifyView([self tzStackView], testNameWithSuffix); \
    VTSnapshotVerifyView([self fdStackView], testNameWithSuffix); \
    VTSnapshotVerifyView([self vtControlStackView], testNameWithSuffix); \
})

//! Run snapshots with different sizes
#define VTTestAllWithSizes() \
({ \
    [self reinitializeAllStackViews]; \
    [self setExplicitStackViewSize:CGSizeMake(1000, 1000)]; \
    VTTestAllWithSuffix(@"largeSize"); \
    [self reinitializeAllStackViews]; \
    [self setExplicitStackViewSize:CGSizeMake(25, 25)]; \
    VTTestAllWithSuffix(@"smallSize"); \
})

@interface VTBaseViewTest : FBSnapshotTestCase

// Common Setup
@property (nonatomic) BOOL addArrangedViews;
@property (nonatomic) BOOL removeOldArrangedSubviews;
@property (nonatomic, copy) NSArray* (^setupArrangedViews)(UIStackView* stackView);
@property (nonatomic, copy) void (^setupStackViewBlock)(UIStackView* stackView);

// Snapshot controller
@property (nonatomic, readonly) FBSnapshotTestController* snappy;
@property (nonatomic) BOOL saveSnapshot;

@property (nonatomic, copy) NSString* baseDirectory;

// Base view used for layout
@property (nonatomic, readonly) UIView* baseView;

// Stack views
@property (nonatomic, strong) UIStackView* uiStackView;

@property (nonatomic, strong) UIStackView* tzStackView;
@property (nonatomic, strong) UIStackView* oaStackView;
@property (nonatomic, strong) UIStackView* fdStackView;
@property (nonatomic, strong) UIStackView* vtControlStackView;

// Helper arrays
@property (nonatomic, readonly) NSArray* allStackViews;
@property (nonatomic, readonly) NSArray* mimicStackViews;

// Base image
@property (nonatomic, strong) UIImage* baseImage;

//! Recreate a fresh instance of the stack view
- (UIStackView*) reinitializeStackViewForClass:(Class)cls;
//! Recreate all stack views
- (void) reinitializeAllStackViews;

//! Prepare stack view based on common setup
- (void) setupStackView:(UIStackView*)stackView;

//! Set Explicit size
- (void) setExplicitStackViewSize:(CGSize)size;

//! Take a snapshot of a view and save it to disk
- (UIImage*) saveAndSnapshotView:(UIView*)view testName:(NSString*)testName identifier:(NSString*)identifier;

//! Determine whether or not a view matches a supplied base image
- (BOOL) compareView:(UIView*)view toBaseImage:(UIImage*)baseImage testName:(NSString*)testName withIdentifier:(NSString*)identifier error:(NSError* __autoreleasing *)error;

//! Write metadata to disk
- (void) writeMatchData:(BOOL)match withView:(UIView*)view testName:(NSString*)testName identifier:(NSString*)identifier;
- (void) writeMetadata:(id)metadata forClass:(Class)cls withMetadataName:(NSString*)name;

//! Helper method to get an identifier
- (NSString*) identifierFromClass:(Class)cls;


- (UIImage*) prepareBaseImage:(UIStackView*)stackView testName:(NSString*)testName;
- (BOOL)snapshotVerifyView:(UIStackView *)stackView testName:(NSString *)testName error:(NSError* __autoreleasing *)error;
- (BOOL)compareViewFramesForView:(UIStackView*)stackView1 toView:(UIStackView*)stackView2;

@end