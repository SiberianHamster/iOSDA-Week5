//
//  ReminderDetailViewController.h
//  MapReminder
//
//  Created by Mark Lin on 9/3/15.
//  Copyright (c) 2015 Mark Lin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <ParseUI/ParseUI.h>

@interface ReminderDetailViewController : UIViewController
@property MKAnnotationView *annotationItem;
@property PFUser *whoIsUser;

@end
