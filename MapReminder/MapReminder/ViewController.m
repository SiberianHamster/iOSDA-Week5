//
//  ViewController.m
//  MapReminder
//
//  Created by Mark Lin on 8/31/15.
//  Copyright (c) 2015 Mark Lin. All rights reserved.
//

#import "ViewController.h"
#import <MapKit/MapKit.h>
#import "Stack.h"
#import <CoreLocation/CoreLocation.h>



@interface ViewController () <CLLocationManagerDelegate, MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
- (IBAction)disneylandButton:(UIButton *)sender;
- (IBAction)homeButton:(UIButton *)sender;
- (IBAction)disneyWorldButton:(UIButton *)sender;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (nonatomic,strong) UILongPressGestureRecognizer *longPressDetector;
@property (nonatomic,strong) UIView *rightCalloutAccessoryView;



@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.mapView.delegate = self;
  self.mapView.showsUserLocation = true;
  
  NSLog(@"%d",[CLLocationManager authorizationStatus]);
  
  self.locationManager = [[CLLocationManager alloc]init];
  self.locationManager.delegate = self;
  [self.locationManager requestWhenInUseAuthorization];
  [self.locationManager startUpdatingLocation];

  
  
  self.longPressDetector = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGestures:)];
  self.longPressDetector.minimumPressDuration = 0.8f;
  self.longPressDetector.allowableMovement = 10.0f;
  [self.view addGestureRecognizer:self.longPressDetector];

//  NSMutableArray *myAwesomeStack = [NSMutableArray arrayWithObjects: nil];
//  Stack *blah = [[Stack alloc]init];
  

  
}



-(void)handleLongPressGestures:(UILongPressGestureRecognizer *)sender
{
  if ([sender isEqual:self.longPressDetector]){
    if (sender.state == UIGestureRecognizerStateBegan)
    {
      CGPoint point = [sender locationOfTouch: 0 inView: self.mapView];
      CLLocationCoordinate2D coord = [self.mapView convertPoint:point toCoordinateFromView:self.mapView];
      NSLog(@"X: %f, Y: %f",coord.latitude, coord.longitude);
      MKPointAnnotation *annotation = [[MKPointAnnotation alloc]init];
      annotation.coordinate = coord;
      annotation.title = @"Target Location";
      [self.mapView addAnnotation:annotation];
    }
  }
}

-(void)viewDidAppear:(BOOL)animated{
  [super viewDidAppear:animated];
  [self.mapView setRegion:MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(47.623565, -122.336098), 150, 150) animated:true];
}

- (IBAction)disneylandButton:(UIButton *)sender {
  [self.mapView setRegion:MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(33.8102936, -117.9189478), 1000, 1000) animated:true];
}

- (IBAction)homeButton:(UIButton *)sender {
  [self.mapView setRegion:MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(47.623565, -122.336098), 150, 150) animated:true];
}

- (IBAction)disneyWorldButton:(UIButton *)sender {
  [self.mapView setRegion:MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(28.418625, -81.581566), 5000, 5000) animated:true];
}

#pragma mark - CLLocationManagerDelegate
-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
  switch (status) {
    case kCLAuthorizationStatusAuthorizedWhenInUse:
      [self.locationManager startUpdatingLocation];
      break;
      
    default:
      break;
  }
}
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
  CLLocation *location = locations.lastObject;
  NSLog(@"lat: %f, long: %f, speed: %f", location.coordinate.latitude, location.coordinate.longitude, location.speed);
}

#pragma mark - MKMapview Delegate
-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
  
  if ([annotation isKindOfClass:[MKUserLocation class]]){
    return nil;
  };
  MKPinAnnotationView *pinView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"AnnotationView"];
  pinView.annotation = annotation;
  if(!pinView){
    pinView = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"AnnotationView"];
  }
  pinView.animatesDrop = true;
  pinView.pinColor = MKPinAnnotationColorPurple;
  pinView.canShowCallout = true;
  UIButton *rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
  [rightCalloutAccessoryView addTarget:self action:@selector(buttonPressed) forControlEvents:UIControlEventTouchUpInside];
  pinView.rightCalloutAccessoryView = rightCalloutAccessoryView;
  return pinView;
}

-(void)buttonPressed{
  [self performSegueWithIdentifier:@"ReminderDetailViewController" sender:nil];
}


#pragma mark - prepareSegue
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
//  if ([[segue identifier] isEqualToString:@"ReminderDetailViewController"]){
//    
//    NSIndexPath *indexPath =
//  }
}

@end
