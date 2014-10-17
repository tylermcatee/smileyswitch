//
//  SmileySwitch.h
//  SmileySwitch
//
//  Created by Tyler McAtee on 10/15/14.
//  Copyright (c) 2014 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SmileySwitch : UIControl

@property (nonatomic, getter=isOn) BOOL on;

// Customization properties
@property (nonatomic, strong) UIColor *backingColor; // Default is a shade of grey
@property (nonatomic, strong) UIColor *onColor; // Default is a shade of green
@property (nonatomic, strong) UIColor *offColor; // Default is a shade of red
@property (nonatomic) BOOL shouldDisplayShadows; // Default is YES, if NO will not display the shadows under the layers.

/*!
 @method SmileySwitch
 @abstract Initializes an instance of SmileySwitch with frame (0, 0, 90, 44).
*/
+(instancetype)SmileySwitch;

@end
