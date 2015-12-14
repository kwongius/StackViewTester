//
//  VTBaseViewTest.m
//  ViewTester
//
//  Created by Kevin Wong on 11/7/15.
//  Copyright © 2015 Kevin Wong. All rights reserved.
//

#import "VTBaseViewTest.h"
#import <objc/runtime.h>

@interface VTControlStackView : UIStackView
@end
@implementation VTControlStackView
@end

@implementation VTBaseViewTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.

    _baseDirectory = [NSProcessInfo processInfo].environment[@"VT_OUTPUT_IMAGE_DIR"];
    NSAssert(_baseDirectory != nil, @"VT_OUTPUT_IMAGE_DIR env variable must be set. Please add it to the run scheme or specify the variable when calling xcodebuild");

    // HACK:
    Ivar snapshotControllerIvar = class_getInstanceVariable([self class], "_snapshotController");
    _snappy = object_getIvar(self, snapshotControllerIvar);

    _addArrangedViews = TRUE;
    _removeOldArrangedSubviews = TRUE;
    _saveSnapshot = TRUE;

    [self setSetupArrangedViews:^NSArray* (UIStackView* stackView) {
        return [VTTestViewGroups simpleViews];
//        return [VTTestViewGroups viewsWithLabels];
    }];

    _baseView = [[UIView alloc] init];
    
    [self reinitializeStackViewForClass:[UIStackView class]];
    [self reinitializeStackViewForClass:[OAStackView class]];
    [self reinitializeStackViewForClass:[TZStackView class]];
    [self reinitializeStackViewForClass:[FDStackView class]];
    [self reinitializeStackViewForClass:[VTControlStackView class]];

    _mimicStackViews = @[_tzStackView, _oaStackView, _fdStackView];
    _allStackViews = [@[_uiStackView] arrayByAddingObjectsFromArray:_mimicStackViews];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];

    [_allStackViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

#pragma mark -

- (UIStackView *)reinitializeStackViewForClass:(Class)cls
{
    UIStackView* stackView = [[cls alloc] initWithArrangedSubviews:@[]];
    if (cls == [UIStackView class])
    {
        [[self uiStackView] removeFromSuperview];
        [self setUiStackView:stackView];
    }
    else if (cls == [OAStackView class])
    {
        [[self oaStackView] removeFromSuperview];
        [self setOaStackView:stackView];
    }
    else if (cls == [TZStackView class])
    {
        [[self tzStackView] removeFromSuperview];
        [self setTzStackView:stackView];
    }
    else if (cls == [FDStackView class])
    {
        [[self fdStackView] removeFromSuperview];
        [self setFdStackView:stackView];
    }
    else if (cls == [VTControlStackView class])
    {
        [[self vtControlStackView] removeFromSuperview];
        [self setVtControlStackView:stackView];
    }
    else
    {
        NSAssert(FALSE, @"");
    }
    
    [stackView setTranslatesAutoresizingMaskIntoConstraints:FALSE];
    [[self baseView] addSubview:stackView];
    
    [stackView autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [stackView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    
    
    return stackView;
}

- (void)reinitializeAllStackViews
{
    for (UIStackView* stackView in [self allStackViews])
    {
        [self reinitializeStackViewForClass:[stackView class]];
    }
    
    _mimicStackViews = @[_oaStackView, _tzStackView, _fdStackView, _vtControlStackView];
    _allStackViews = [@[_uiStackView] arrayByAddingObjectsFromArray:_mimicStackViews];
}

- (void)setupStackView:(UIStackView *)stackView
{
    // Cleanup
    if ([self removeOldArrangedSubviews])
    {
        NSArray* views = [stackView arrangedSubviews];
        for (UIView* view in views)
        {
            [stackView removeArrangedSubview:view];
            [view removeFromSuperview];
        }
    }
    
    // Add views
    if ([self addArrangedViews] && [self setupArrangedViews] != nil)
    {
        NSArray* views = [self setupArrangedViews](stackView);
        for (UIView* view in views)
        {
            [stackView addArrangedSubview:view];
        }
    }
    
    // Configure
    if ([self setupStackViewBlock] != nil)
    {
        [self setupStackViewBlock](stackView);
    }

    // Layout
    [stackView layoutIfNeeded];
}

- (void)setExplicitStackViewSize:(CGSize)size
{
    for (UIView* view in [self allStackViews])
    {
        [view vt_setExplicitSize:size];
    }
}

- (UIImage*) saveAndSnapshotView:(UIView*)view testName:(NSString*)testName identifier:(NSString*)identifier
{
    UIImage* image = [self snapshotView:view];
    [self saveImage:image testName:testName identifier:identifier];
    return image;
}

- (BOOL) compareView:(UIView*)view toBaseImage:(UIImage*)baseImage testName:(NSString*)testName withIdentifier:(NSString*)identifier error:(NSError* __autoreleasing *)error
{
    UIImage* image = [self snapshotView:view];
    
    BOOL match = FALSE;
    if (image == nil && baseImage == nil)
    {
        match = TRUE;
    }
    else
    {
        match = [[self snappy] compareReferenceImage:baseImage toImage:image tolerance:0 error:error];
    }
    
    [self saveImage:image testName:testName identifier:identifier];
    
    return match;
}

- (void) writeMatchData:(BOOL)match withView:(UIView*)view testName:(NSString*)testName identifier:(NSString*)identifier
{
    if (![self saveSnapshot])
    {
        return;
    }
   
    NSString* baseDirectory = [_baseDirectory stringByAppendingPathComponent:NSStringFromClass([self class])];
    
    NSString* filename = [NSString stringWithFormat:@"%@_results", identifier];
    
    NSString* filePath = [[baseDirectory stringByAppendingPathComponent:testName] stringByAppendingPathComponent:filename];
    
    NSError* error;
    [[NSFileManager defaultManager] createDirectoryAtPath:[filePath stringByDeletingLastPathComponent] withIntermediateDirectories:TRUE attributes:nil error:&error];
    
    NSError* jsonError;
    NSDictionary* metadata = @{
                               @"success" : @(match),
                               @"frame" : @{
                                       @"x" : @([view frame].origin.x),
                                       @"y" : @([view frame].origin.y),
                                       @"width" : @([view frame].size.width),
                                       @"height" : @([view frame].size.height),
                                       },
                               };
    NSData* data = [NSJSONSerialization dataWithJSONObject:metadata options:0 error:&jsonError];
    [data writeToFile:filePath atomically:TRUE];
}

- (void) writeMetadata:(id)metadata forClass:(Class)cls withMetadataName:(NSString*)name
{
    NSString* baseDirectory = [_baseDirectory stringByAppendingPathComponent:@"../metadata"];
    baseDirectory = [baseDirectory stringByAppendingPathComponent:NSStringFromClass([self class])];
    
    [[NSFileManager defaultManager] createDirectoryAtPath:baseDirectory withIntermediateDirectories:TRUE attributes:nil error:NULL];
    
    NSString* identifier = (cls ? [self identifierFromClass:cls] : nil);
    
    NSString* fileName = (identifier ? [NSString stringWithFormat:@"%@_%@", name, identifier] : name);
    
    NSString* filePath = [baseDirectory stringByAppendingPathComponent:fileName];
    
    NSData* data = [NSJSONSerialization dataWithJSONObject:metadata options:NSJSONWritingPrettyPrinted	 error:NULL];
    
    [data writeToFile:filePath atomically:TRUE];
}

- (NSString*) identifierFromClass:(Class)cls
{
    if (cls == [TZStackView class])
    {
        return @"TZStackView";
    }
    return NSStringFromClass(cls);
}

- (UIImage *)prepareBaseImage:(UIStackView *)stackView testName:(NSString *)testName
{
    [self setupStackView:stackView];
    NSString* identifier = [self identifierFromClass:[stackView class]];
    testName = testName ?: VTTestName();
    UIImage* baseImage = [self saveAndSnapshotView:stackView testName:testName identifier:identifier];
    [self setBaseImage:baseImage];
    [self writeMatchData:TRUE withView:stackView testName:testName identifier:identifier];
    return baseImage;
}

- (BOOL)snapshotVerifyView:(UIStackView *)stackView testName:(NSString *)testName error:(NSError* __autoreleasing *)error
{
    BOOL match = FALSE;
    if (stackView != nil)
    {
        NSString* identifier = [self identifierFromClass:[stackView class]];
        testName = testName ?: VTTestName();
        match = [self compareView:stackView toBaseImage:[self baseImage] testName:testName withIdentifier:identifier error:error];
        [self writeMatchData:match withView:stackView testName:testName identifier:identifier];
    }
    return match;
}

- (BOOL)compareViewFramesForView:(UIStackView*)stackView1 toView:(UIStackView*)stackView2
{
    if ([[stackView1 arrangedSubviews] count] != [[stackView2 arrangedSubviews] count])
    {
        NSAssert(FALSE, @"");
        return FALSE;
    }
    
    for (int i = 0; i < [[stackView1 arrangedSubviews] count]; i++)
    {
        UIView* view1 = [[stackView1 arrangedSubviews] objectAtIndex:i];
        UIView* view2 = [[stackView2 arrangedSubviews] objectAtIndex:i];
        
        if (!CGRectEqualToRect([view1 frame], [view2 frame]))
        {
            return FALSE;
        }
    }
    
    return TRUE;
}

#pragma mark - Helper Methods

- (UIImage*) snapshotView:(UIView*)view
{
    [view layoutIfNeeded];
    
    if (CGRectIsEmpty([view frame]))
    {
        [view vt_setSnapshotImage:nil];
        return nil;
    }
    
    // HACK:
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    UIImage* image = [[self snappy] performSelector:@selector(_imageForViewOrLayer:) withObject:view];
#pragma clang diagnostic pop
    
    [view vt_setSnapshotImage:image];

    return image;
}

- (void) saveImage:(UIImage*)image testName:(NSString*)testName identifier:(NSString*)identifier
{
    if (![self saveSnapshot])
    {
        return;
    }
    
    NSString* baseDirectory = [_baseDirectory stringByAppendingPathComponent:NSStringFromClass([self class])];

    NSString* filename = [NSString stringWithFormat:@"%@_%@.png", testName, identifier];
    
    NSString* filePath = [[baseDirectory stringByAppendingPathComponent:testName] stringByAppendingPathComponent:filename];
    
    NSError* error;
    [[NSFileManager defaultManager] createDirectoryAtPath:[filePath stringByDeletingLastPathComponent] withIntermediateDirectories:TRUE attributes:nil error:&error];
    
    if (image != nil)
    {
        NSData* data = UIImagePNGRepresentation(image);
        NSError* error2;
        [data writeToFile:filePath options:NSDataWritingAtomic error:&error2];
    }
    else
    {
        NSError* error3;
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error3];
    }
}


@end