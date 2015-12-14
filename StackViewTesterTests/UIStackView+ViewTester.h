//
//  UIStackView+ViewTester.h
//  ViewTester
//
//  Created by Kevin Wong on 11/7/15.
//  Copyright © 2015 Kevin Wong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ViewTester)

- (void) vt_setSnapshotImage:(UIImage*)image;
- (UIImage*) vt_snapshotImage;

- (void) vt_setExplicitSize:(CGSize)size;
- (NSValue*) vt_explicitSize;
- (void) vt_removeExplicitSize;

@end

@interface UIStackView (ViewTester)

- (void) vt_applyConsistentDefaults;

- (void) vt_safe_setBaselineRelativeArrangement:(BOOL)baselineRelativeArrangement;
- (BOOL) vt_safe_isBaselineRelativeArrangement;

- (BOOL) vt_safe_isLayoutMarginsRelativeArrangement;

- (NSDictionary*) vt_metadata;

@end
