//
//  Constants.h
//  INSElectronicProgramGuideLayout
//
//  Created by Ibrahim Hassan on 21/05/20.
//  Copyright © 2020 inspace.io. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const INSEPGLayoutElementKindSectionHeader;
extern NSString *const INSEPGLayoutElementKindHourHeader;
extern NSString *const INSEPGLayoutElementKindHalfHourHeader;

extern NSString *const INSEPGLayoutElementKindSectionHeaderBackground;
extern NSString *const INSEPGLayoutElementKindHourHeaderBackground;

extern NSString *const INSEPGLayoutElementKindCurrentTimeIndicator;
extern NSString *const INSEPGLayoutElementKindCurrentTimeIndicatorVerticalGridline;

extern NSString *const INSEPGLayoutElementKindVerticalGridline;
extern NSString *const INSEPGLayoutElementKindHalfHourVerticalGridline;
extern NSString *const INSEPGLayoutElementKindHorizontalGridline;

extern NSString *const INSEPGLayoutElementKindFloatingItemOverlay;

extern NSUInteger const INSEPGLayoutMinOverlayZ;
extern NSUInteger const INSEPGLayoutMinCellZ;
extern NSUInteger const INSEPGLayoutMinBackgroundZ;


NS_ASSUME_NONNULL_BEGIN

@interface Constants : NSObject

@end

NS_ASSUME_NONNULL_END
