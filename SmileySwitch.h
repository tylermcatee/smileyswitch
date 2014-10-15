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

@property (nonatomic, strong) UIColor *backgroundColor; // Default is a shade of grey
@property (nonatomic, strong) UIColor *onColor; // Default is a shade of green
@property (nonatomic, strong) UIColor *offColor; // Default is a shade of red

@end
