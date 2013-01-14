//
//  MPCoreLocationController.h
//  myPlate
//
//  Created by Daniel Dinu on 12/20/12.
//  Copyright (c) 2012 Daniel Dinu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@protocol CoreLocationControllerDelegate
@required
- (void)locationUpdate:(CLLocation *)location; // Our location updates are sent here
- (void)locationError:(NSError *)error; // Any errors are sent here
@end

@interface MPCoreLocationController : NSObject <CLLocationManagerDelegate>
{
    CLLocationManager *locMgr;
	id delegate;

}

@property (nonatomic, retain) CLLocationManager *locMgr;
@property (nonatomic, assign) id delegate;


@end
