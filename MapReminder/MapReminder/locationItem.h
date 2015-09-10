//
//  locationItem.h
//  MapReminder
//
//  Created by Mark Lin on 9/6/15.
//  Copyright (c) 2015 Mark Lin. All rights reserved.
//

#import <Parse/Parse.h>

@interface locationItem : PFObject <PFSubclassing>

@property (strong,nonatomic) NSString *name;
@property (strong,nonatomic) PFGeoPoint *location;
@property (strong,nonatomic) PFUser *user;

@end
