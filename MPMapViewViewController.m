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


- (NSString *)deviceLocation {
    }


- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    
    if ([self.mapView showsUserLocation]) {
        MKMapPoint annotationPoint = MKMapPointForCoordinate(mapView.userLocation.coordinate);
        MKMapRect zoomRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0.1, 0.1);
        for (id <MKAnnotation> annotation in mapView.annotations)
        {
            MKMapPoint annotationPoint = MKMapPointForCoordinate(annotation.coordinate);
            MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0.1, 0.1);
            zoomRect = MKMapRectUnion(zoomRect, pointRect);
        }
        [mapView setVisibleMapRect:zoomRect animated:YES];
[self.mapView setCenterCoordinate:self.mapView.userLocation.location.coordinate animated:YES];        // and of course you can use here old and new location values
    }
}
- (void)removeAllPinsButUserLocation1
{ id userLocation = [mapView userLocation];
    NSMutableArray *pins = [[NSMutableArray alloc] initWithArray:[mapView annotations]];
    if ( userLocation != nil ) {
        [pins removeObject:userLocation]; // avoid removing user location off the map
    }
    
    [mapView removeAnnotations:pins];
    pins = nil;
}
-(void) callAfterSixtySecond:(NSTimer*) t
{    [self removeAllPinsButUserLocation1];

    NSString *theLocation = [NSString stringWithFormat:@"latitude: %f longitude: %f", locationManager.location.coordinate.latitude, locationManager.location.coordinate.longitude];
    
    NSString *post3=[NSString stringWithFormat:@"lat=%f&longi=%f&id=%@", locationManager.location.coordinate.latitude,locationManager.location.coordinate.longitude,[[NSUserDefaults standardUserDefaults] valueForKey:@"userid"]];
    //NSLog(@"post string is :%@",post3);
    NSData *postData3 = [post3 dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength3 = [NSString stringWithFormat:@"%d", [postData3 length]];
    
    NSMutableURLRequest *cerere3 = [[NSMutableURLRequest alloc] init];
    [cerere3 setURL:[NSURL URLWithString:@"http://thewebcap.com/dev/ios/location.php"]];
    [cerere3 setHTTPMethod:@"POST"];
    [cerere3 setValue:postLength3 forHTTPHeaderField:@"Content-Length"];
    [cerere3 setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [cerere3 setHTTPBody:postData3];
    NSURLResponse* response3 = nil;
    NSError* error3=nil;
    NSData *serverReply3 = [NSURLConnection sendSynchronousRequest:cerere3 returningResponse:&response3 error:&error3];
    NSString *replyString3 = [[NSString alloc] initWithBytes:[serverReply3 bytes] length:[serverReply3 length] encoding: NSASCIIStringEncoding];
    //NSLog(@"reply string is : %@",replyString3);
    
    NSString *post4=[NSString stringWithFormat:@"ID=%@", [[NSUserDefaults standardUserDefaults] valueForKey:@"userid"]];
    //NSLog(@"post string is :%@",post3);
    NSData *postData4 = [post4 dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength4 = [NSString stringWithFormat:@"%d", [postData4 length]];
    
    NSMutableURLRequest *cerere4 = [[NSMutableURLRequest alloc] init];
    [cerere4 setURL:[NSURL URLWithString:@"http://thewebcap.com/dev/ios/list_friends.php"]];
    [cerere4 setHTTPMethod:@"POST"];
    [cerere4 setValue:postLength4 forHTTPHeaderField:@"Content-Length"];
    [cerere4 setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [cerere4 setHTTPBody:postData4];
    NSURLResponse* response4 = nil;
    NSError* error4=nil;
    NSData *serverReply4 = [NSURLConnection sendSynchronousRequest:cerere4 returningResponse:&response4 error:&error4];
    NSString *replyString4 = [[NSString alloc] initWithBytes:[serverReply4 bytes] length:[serverReply4 length] encoding: NSASCIIStringEncoding];
    NSLog(@"reply string is : %@",replyString4);
    NSArray *prieteni = [replyString4 componentsSeparatedByString:@"*~*"];
    for(int i=0;i<[prieteni count];i++)
    {
        
        NSString *pr2 = [prieteni objectAtIndex:i];
        NSArray *pr1 = [pr2 componentsSeparatedByString:@"~;~"];
        NSLog(@"%@",pr2);
        
        NSString *post2=[NSString stringWithFormat:@"search=id&ID=%@",[pr1 objectAtIndex:0]];
        NSLog(@"post string is: %@",post2);
        NSData *postData2 = [post2 dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        
        NSString *postLength2 = [NSString stringWithFormat:@"%d", [postData2 length]];
        
        NSMutableURLRequest *cerere2 = [[NSMutableURLRequest alloc] init];
        [cerere2 setURL:[NSURL URLWithString:@"http://thewebcap.com/dev/ios/search.php"]];
        [cerere2 setHTTPMethod:@"POST"];
        [cerere2 setValue:postLength2 forHTTPHeaderField:@"Content-Length"];
        [cerere2 setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [cerere2 setHTTPBody:postData2];
        NSURLResponse* response2 = nil;
        NSError* error2=nil;
        NSData *serverReply2 = [NSURLConnection sendSynchronousRequest:cerere2 returningResponse:&response2 error:&error2];
        NSString *replyString2 = [[NSString alloc] initWithBytes:[serverReply2 bytes] length:[serverReply2 length] encoding: NSASCIIStringEncoding];
        NSLog(@"reply string is : %@",replyString2);
        NSArray *returnat = [replyString2 componentsSeparatedByString:@"*~*"];
        float lat = [[returnat objectAtIndex:13] floatValue];
        float longi = [[returnat objectAtIndex:14] floatValue];
        
        
        MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
        annotation.coordinate = CLLocationCoordinate2DMake(lat,longi);
        annotation.title = [pr1 objectAtIndex:1];
        annotation.subtitle = @"Subtitle";
        [mapView addAnnotation:annotation];
    }
    NSLog(@"%@",prieteni);
[self.mapView setCenterCoordinate:self.mapView.userLocation.location.coordinate  animated:YES];
}


- (void)viewDidLoad
{
       

    NSTimer* myTimer = [NSTimer scheduledTimerWithTimeInterval: 60.0 target:self
                                                      selector: @selector(callAfterSixtySecond:) userInfo: nil repeats: YES];
    locationManager = [[CLLocationManager alloc] init];
    locationManager.distanceFilter = 10.0f; // whenever we move
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters; // 100 m
    [locationManager startUpdatingLocation];
    
    [self.mapView.userLocation addObserver:self
                                forKeyPath:@"location"
                                   options:(NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld)
                                   context:NULL];
    NSString *theLocation = [NSString stringWithFormat:@"latitude: %f longitude: %f", locationManager.location.coordinate.latitude, locationManager.location.coordinate.longitude];
    
    NSString *post3=[NSString stringWithFormat:@"lat=%f&longi=%f&id=%@", locationManager.location.coordinate.latitude,locationManager.location.coordinate.longitude,[[NSUserDefaults standardUserDefaults] valueForKey:@"userid"]];
    //NSLog(@"post string is :%@",post3);
    NSData *postData3 = [post3 dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength3 = [NSString stringWithFormat:@"%d", [postData3 length]];
    
    NSMutableURLRequest *cerere3 = [[NSMutableURLRequest alloc] init];
    [cerere3 setURL:[NSURL URLWithString:@"http://thewebcap.com/dev/ios/location.php"]];
    [cerere3 setHTTPMethod:@"POST"];
    [cerere3 setValue:postLength3 forHTTPHeaderField:@"Content-Length"];
    [cerere3 setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [cerere3 setHTTPBody:postData3];
    NSURLResponse* response3 = nil;
    NSError* error3=nil;
    NSData *serverReply3 = [NSURLConnection sendSynchronousRequest:cerere3 returningResponse:&response3 error:&error3];
    NSString *replyString3 = [[NSString alloc] initWithBytes:[serverReply3 bytes] length:[serverReply3 length] encoding: NSASCIIStringEncoding];
    //NSLog(@"reply string is : %@",replyString3);
    
    NSString *post4=[NSString stringWithFormat:@"ID=%@", [[NSUserDefaults standardUserDefaults] valueForKey:@"userid"]];
    //NSLog(@"post string is :%@",post3);
    NSData *postData4 = [post4 dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength4 = [NSString stringWithFormat:@"%d", [postData4 length]];
    
    NSMutableURLRequest *cerere4 = [[NSMutableURLRequest alloc] init];
    [cerere4 setURL:[NSURL URLWithString:@"http://thewebcap.com/dev/ios/list_friends.php"]];
    [cerere4 setHTTPMethod:@"POST"];
    [cerere4 setValue:postLength4 forHTTPHeaderField:@"Content-Length"];
    [cerere4 setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [cerere4 setHTTPBody:postData4];
    NSURLResponse* response4 = nil;
    NSError* error4=nil;
    NSData *serverReply4 = [NSURLConnection sendSynchronousRequest:cerere4 returningResponse:&response4 error:&error4];
    NSString *replyString4 = [[NSString alloc] initWithBytes:[serverReply4 bytes] length:[serverReply4 length] encoding: NSASCIIStringEncoding];
    NSLog(@"reply string is : %@",replyString4);
    NSArray *prieteni = [replyString4 componentsSeparatedByString:@"*~*"];
    for(int i=0;i<[prieteni count];i++)
    {
        
        NSString *pr2 = [prieteni objectAtIndex:i];
        NSArray *pr1 = [pr2 componentsSeparatedByString:@"~;~"];
        NSLog(@"%@",pr2);
        
        NSString *post2=[NSString stringWithFormat:@"search=id&ID=%@",[pr1 objectAtIndex:0]];
        NSLog(@"post string is: %@",post2);
        NSData *postData2 = [post2 dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        
        NSString *postLength2 = [NSString stringWithFormat:@"%d", [postData2 length]];
        
        NSMutableURLRequest *cerere2 = [[NSMutableURLRequest alloc] init];
        [cerere2 setURL:[NSURL URLWithString:@"http://thewebcap.com/dev/ios/search.php"]];
        [cerere2 setHTTPMethod:@"POST"];
        [cerere2 setValue:postLength2 forHTTPHeaderField:@"Content-Length"];
        [cerere2 setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [cerere2 setHTTPBody:postData2];
        NSURLResponse* response2 = nil;
        NSError* error2=nil;
        NSData *serverReply2 = [NSURLConnection sendSynchronousRequest:cerere2 returningResponse:&response2 error:&error2];
        NSString *replyString2 = [[NSString alloc] initWithBytes:[serverReply2 bytes] length:[serverReply2 length] encoding: NSASCIIStringEncoding];
        NSLog(@"reply string is : %@",replyString2);
        NSArray *returnat = [replyString2 componentsSeparatedByString:@"*~*"];
        float lat = [[returnat objectAtIndex:13] floatValue];
        float longi = [[returnat objectAtIndex:14] floatValue];
        
        
        MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
        annotation.coordinate = CLLocationCoordinate2DMake(lat,longi);
        annotation.title = [pr1 objectAtIndex:1];
        annotation.subtitle = @"Subtitle";
        [mapView addAnnotation:annotation];
    }
    
    if ([self.mapView showsUserLocation]) {
        MKMapPoint annotationPoint = MKMapPointForCoordinate(mapView.userLocation.coordinate);
        MKMapRect zoomRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0.1, 0.1);
        for (id <MKAnnotation> annotation in mapView.annotations)
        {
            MKMapPoint annotationPoint = MKMapPointForCoordinate(annotation.coordinate);
            MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0.1, 0.1);
            zoomRect = MKMapRectUnion(zoomRect, pointRect);
        }
        [mapView setVisibleMapRect:zoomRect animated:YES];
        [self.mapView setCenterCoordinate:self.mapView.userLocation.location.coordinate  animated:YES];

    }

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
