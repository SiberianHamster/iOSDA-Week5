//
//  ReminderDetailViewController.m
//  MapReminder
//
//  Created by Mark Lin on 9/3/15.
//  Copyright (c) 2015 Mark Lin. All rights reserved.
//

#import "ReminderDetailViewController.h"
#import <MapKit/MapKit.h>
#import <Parse/Parse.h>
#import "locationItem.h"

@interface ReminderDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *xCoordinate;
@property (weak, nonatomic) IBOutlet UILabel *yCoordinate;
@property (weak, nonatomic) IBOutlet UITextField *locationName;



@end

@implementation ReminderDetailViewController

- (IBAction)addLocation:(UIButton *)sender {
  //  NSLog(@"hi");
  [self addLocationToParse];
}

// a button that adds the location name and coor. to parse

-(void)addLocationToParse{
  MKPointAnnotation *annotation = self.annotationItem.annotation;
  PFGeoPoint *currentLocation = [PFGeoPoint geoPointWithLatitude:annotation.coordinate.latitude longitude:annotation.coordinate.longitude];
//  PFObject *placeObject = [PFObject objectWithClassName:@"PlaceObject"];
//  [placeObject setObject:currentLocation forKey:@"location"];
//  [placeObject setObject:self.locationName.text forKey:@"name"];
//  [placeObject setObject:self.whoIsUser forKey:@"user"];
//  [placeObject saveInBackground];
  
  locationItem *placeObject = [locationItem objectWithClassName:@"MapReminder"];
  placeObject.name = self.locationName.text;
  placeObject.user = self.whoIsUser;
  placeObject.location = currentLocation;
  [placeObject saveInBackground];
  

  
  
}

- (void)viewDidLoad {
    [super viewDidLoad];
    MKPointAnnotation *annotation = self.annotationItem.annotation;
//  NSString *myString = [NSString stringWithFormat:@"%f", myDouble];

  _xCoordinate.text = [NSString stringWithFormat:@"%f", annotation.coordinate.longitude];
  _yCoordinate.text = [NSString stringWithFormat:@"%f", annotation.coordinate.latitude];
// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)regionManager:(CLLocationManager *)region didEnterRegion:(CLRegion *)anotherRegion {
  NSLog(@"hi hi");
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

