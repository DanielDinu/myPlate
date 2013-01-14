//
//  MPMapViewController.h
//  myPlate
//
//  Created by Daniel Dinu on 12/17/12.
//  Copyright (c) 2012 Daniel Dinu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "MPCoreLocationController.h"

@interface MPMapViewController : UIViewController<CoreLocationControllerDelegate,CLLocationManagerDelegate> {
    CLLocationManager *locationManager;
	MPCoreLocationController *CLController;
	NSString *locLabel;
    NSString *latitudine;
    NSString *longitudine;
    
    __weak IBOutlet MKMapView *mapView;
    
}
@property (nonatomic, retain) MPCoreLocationController *CLController;
@property (weak, nonatomic) IBOutlet MKMapView *mapview;

@end
