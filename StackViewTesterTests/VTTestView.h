//
//  VTTestView.h
//  ViewTester
//
//  Created by Kevin Wong on 11/8/15.
//  Copyright © 2015 Kevin Wong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VTTestView : UIView

- (instancetype) initWithSize:(CGSize)size;
- (instancetype) initWithSize:(CGSize)size color:(UIColor *)color;

@property (nonatomic) CGSize size;

@end

@interface VTTestViewGroups : NSObject

+ (NSArray<UIView*>*) singleView;

+ (NSArray<UIView*>*) simpleViews;

+ (NSArray<UIView*>*) viewsWithLabels;

@end
