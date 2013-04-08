//
//  MPMapViewViewController.h
//  myPlate
//
//  Created by Daniel Dinu on 2/26/13.
//  Copyright (c) 2013 Daniel Dinu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface MPMapViewViewController : UIViewController
{ IBOutlet CLLocationManager *locationManager;}
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end
