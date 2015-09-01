//
//  ViewController.m
//  MapReminder
//
//  Created by Mark Lin on 8/31/15.
//  Copyright (c) 2015 Mark Lin. All rights reserved.
//

#import "ViewController.h"
#import <MapKit/MapKit.h>

@interface ViewController ()

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
- (IBAction)disneylandButton:(UIButton *)sender;
- (IBAction)homeButton:(UIButton *)sender;
- (IBAction)disneyWorldButton:(UIButton *)sender;
@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
}

-(void)viewDidAppear:(BOOL)animated{
  [self.mapView setRegion:MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(47.623565, -122.336098), 150, 150) animated:true];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
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
@end
