//
//  MPAppDelegate.h
//  myPlate
//
//  Created by Daniel Dinu on 12/11/12.
//  Copyright (c) 2012 Daniel Dinu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MPAppDelegate : UIResponder <UIApplicationDelegate>
{CLLocationManager *locationManager;
    NSObject *overlayView;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UIWindow *overlay;

@property (strong, nonatomic) NSData *devTtrimis;

@end
