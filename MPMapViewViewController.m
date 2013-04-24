//
//  MPMapViewViewController.m
//  myPlate
//
//  Created by Daniel Dinu on 2/26/13.
//  Copyright (c) 2013 Daniel Dinu. All rights reserved.
//

#import "MPMapViewViewController.h"
#define METERS_PER_MILE 1609.344
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "MKMapView+ZoomLevel.h"
#import "MyLocation.h"


@interface MPMapViewViewController ()

@end

@implementation MPMapViewViewController

@synthesize mapView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}




- (void)viewDidLoad
{
    QBLPlace *place = [QBLPlace place];
    place.geoDataID = 34691;
    place.photoID = 447; // ID of file in Content module
    place.title = @"My place title";
    place.address = @"London, Gadge st, 34";
    place.placeDescription = @"My place description";
    
    [QBLocation createPlace:place delegate:self];
        [super viewDidLoad];
	// Do any additional setup after loading the view.
    }

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setMapView:nil];
    [super viewDidUnload];
}
@end
