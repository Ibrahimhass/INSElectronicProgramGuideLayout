//
//  Constants.m
//  INSElectronicProgramGuideLayout
//
//  Created by Ibrahim Hassan on 21/05/20.
//  Copyright © 2020 inspace.io. All rights reserved.
//

#import "Constants.h"

NSString *const INSEPGLayoutElementKindSectionHeader = @"INSEPGLayoutElementKindSectionHeader";
NSString *const INSEPGLayoutElementKindHourHeader = @"INSEPGLayoutElementKindHourHeader";
NSString *const INSEPGLayoutElementKindHalfHourHeader = @"INSEPGLayoutElementKindHalfHourHeader";
NSString *const INSEPGLayoutElementKindSectionHeaderBackground = @"INSEPGLayoutElementKindSectionHeaderBackground";
NSString *const INSEPGLayoutElementKindHourHeaderBackground = @"INSEPGLayoutElementKindHourHeaderBackground";
NSString *const INSEPGLayoutElementKindCurrentTimeIndicator = @"INSEPGLayoutElementKindCurrentTimeIndicator";
NSString *const INSEPGLayoutElementKindCurrentTimeIndicatorVerticalGridline = @"INSEPGLayoutElementKindCurrentTimeIndicatorVerticalGridline";
NSString *const INSEPGLayoutElementKindVerticalGridline = @"INSEPGLayoutElementKindVerticalGridline";
NSString *const INSEPGLayoutElementKindHalfHourVerticalGridline = @"INSEPGLayoutElementKindHalfHourVerticalGridline";
NSString *const INSEPGLayoutElementKindHorizontalGridline = @"INSEPGLayoutElementKindHorizontalGridline";
NSString *const INSEPGLayoutElementKindFloatingItemOverlay = @"INSEPGLayoutElementKindFloatingItemOverlay";

NSUInteger const INSEPGLayoutMinOverlayZ = 1000.0; // Allows for 900 items in a section without z overlap issues
NSUInteger const INSEPGLayoutMinCellZ = 100.0;  // Allows for 100 items in a section's background
NSUInteger const INSEPGLayoutMinBackgroundZ = 0.0;

@implementation Constants

@end

