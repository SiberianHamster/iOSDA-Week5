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
#import "ReminderDetailViewController.h"
#import <ParseUI/ParseUI.h>
#import <Parse/Parse.h>
#import "locationItem.h"

@interface ViewController () <CLLocationManagerDelegate, MKMapViewDelegate, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate>

- (IBAction)logInLogOut:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *logInLogOutOutlet;
- (IBAction)Refresh:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
- (IBAction)disneylandButton:(UIButton *)sender;
- (IBAction)homeButton:(UIButton *)sender;
- (IBAction)disneyWorldButton:(UIButton *)sender;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (nonatomic,strong) UILongPressGestureRecognizer *longPressDetector;
@property (nonatomic,strong) UIView *rightCalloutAccessoryView;
@property MKAnnotationView *annotationItem;
@property PFQuery *query;
@property PFGeoPoint *userGeoPoint;
@property MKUserLocation *userCoord;
@property NSArray *regions;


@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  if ([PFUser currentUser]) {
    self.logInLogOutOutlet.titleLabel.text = @"LogOut";
  }
  
  self.mapView.delegate = self;
  self.mapView.showsUserLocation = true;
  
  NSLog(@"%d",[CLLocationManager authorizationStatus]);
  
  self.locationManager = [[CLLocationManager alloc]init];
  self.locationManager.delegate = self;
  [self.locationManager requestWhenInUseAuthorization];//change this
  [self.locationManager startUpdatingLocation];

  
  
  self.longPressDetector = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGestures:)];
  self.longPressDetector.minimumPressDuration = 0.8f;
  self.longPressDetector.allowableMovement = 10.0f;
  [self.view addGestureRecognizer:self.longPressDetector];

//  NSMutableArray *myAwesomeStack = [NSMutableArray arrayWithObjects: nil];
//  Stack *blah = [[Stack alloc]init];
    [self.mapView setRegion:MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(47.623565, -122.336098), 150, 150) animated:true];
}


  -(void)anotherFunction{
  if ([CLLocationManager isMonitoringAvailableForClass:[CLCircularRegion class]]) {
    self.userCoord = self.mapView.userLocation;
    
    self.userGeoPoint = [PFGeoPoint geoPointWithLatitude: self.userCoord.coordinate.latitude longitude:self.userCoord.coordinate.longitude];
    NSLog(@"user geo point other: %@", self.userGeoPoint);

    
    self.query = [PFQuery queryWithClassName:@"MapReminder"];
    NSLog(@"Hi, %@",self.query);
    
//    CLCircularRegion *region = [[CLCircularRegion alloc] initWithCenter:CLLocationCoordinate2DMake(47.6235, -122.3363) radius:200 identifier:@"Code Fellows"];
//    [self.locationManager startMonitoringForRegion:region];
    
//    MKCircle *circle = [MKCircle circleWithCenterCoordinate:CLLocationCoordinate2DMake(47.6235, -122.3363) radius:100];
//    [self.mapView addOverlay:circle];
    

    int x = 0;
    while (x < self.regions.count) {
      locationItem *currentItem = self.regions[x];
      
      [self.locationManager startMonitoringForRegion:self.regions[x]];
      CLCircularRegion *region = [[CLCircularRegion alloc] initWithCenter:CLLocationCoordinate2DMake(currentItem.location.latitude, currentItem.location.longitude) radius:100 identifier:currentItem.name];
      [self.locationManager startMonitoringForRegion:region];
      
      MKCircle *circle = [MKCircle circleWithCenterCoordinate:CLLocationCoordinate2DMake(currentItem.location.latitude, currentItem.location.longitude) radius:100];
      [self.mapView addOverlay:circle];


      x = x + 1;
    }
    
  }
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
-(void)viewWillAppear:(BOOL)animated{
  if ([PFUser currentUser]){
    NSLog(@"user is logged in");
    //code for changing button to logout
  } else {
    NSLog(@"No User");
    //code for changing button to login
  }
  
  
}

-(void)viewDidAppear:(BOOL)animated{
  [super viewDidAppear:animated];
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
    pinView.rightCalloutAccessoryView = rightCalloutAccessoryView;
//  [rightCalloutAccessoryView addTarget:self action:@selector(buttonPressed) forControlEvents:UIControlEventTouchUpInside];


  return pinView;
}

//-(void)buttonPressed{
//  [self performSegueWithIdentifier:@"ReminderDetailViewController" sender:nil];
//}


#pragma mark - prepareSegue
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
  if ([[segue identifier] isEqualToString:@"ReminderDetailViewController"]){
    ReminderDetailViewController *destinationController = segue.destinationViewController;
    destinationController.whoIsUser = [PFUser currentUser];
    destinationController.annotationItem = self.annotationItem; // sends the data to detail VC
  }
}

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
  self.annotationItem = view;
  [self performSegueWithIdentifier:@"ReminderDetailViewController" sender:view];
}

-(void)logScreen{
PFLogInViewController *logInController = [[PFLogInViewController alloc] init];
  logInController.delegate = self;
[self presentViewController:logInController animated:YES completion:nil];
}


-(void)logInViewController:(PFLogInViewController * __nonnull)logInController didLogInUser:(PFUser * __nonnull)user{
    [self dismissViewControllerAnimated:true completion:nil];
  };

-(void)logInViewControllerDidCancelLogIn:(PFLogInViewController * __nonnull)logInController {
  
}


- (IBAction)logInLogOut:(UIButton *)sender {
  if ([PFUser currentUser]) {
    [sender setTitle:@"LogIn" forState:(UIControlStateNormal)];
    NSLog(@"There is a user");
      [PFUser logOut];
    NSLog(@"logging out user");
  }
  else{
    [sender setTitle:@"LogOut" forState:(UIControlStateNormal)];
    [self logScreen];
}}

-(MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
  MKCircleRenderer *circleRenderer = [[MKCircleRenderer alloc] initWithOverlay:overlay];
  
  circleRenderer.strokeColor = [UIColor grayColor];
  circleRenderer.fillColor = [UIColor grayColor];
  circleRenderer.alpha = 0.5;
  
  return circleRenderer;
}

-(void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
  NSLog(@"you entered");
}

-(void)getCheckLocation{
  NSLog(@"user geo point: %@", self.userGeoPoint);
  [self.query whereKey:@"location" nearGeoPoint:self.userGeoPoint withinMiles:10.0];
  self.regions = [self.query findObjects];
  NSLog(@"items returned: %lu",(unsigned long)self.regions.count);
}

- (IBAction)Refresh:(UIButton *)sender {
      self.userGeoPoint = [PFGeoPoint geoPointWithLatitude: self.userCoord.coordinate.latitude longitude:self.userCoord.coordinate.longitude];
    [self getCheckLocation];
    [self anotherFunction];
  
}
@end
