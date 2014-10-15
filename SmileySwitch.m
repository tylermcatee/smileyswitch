//
//  SmileySwitch.m
//  SmileySwitch
//
//  Created by Tyler McAtee on 10/15/14.
//  Copyright (c) 2014 Apple. All rights reserved.
//

#import "SmileySwitch.h"

@interface SmileySwitch()

// Background layers
@property (nonatomic, weak) CAShapeLayer *backgroundLayer;
@property (nonatomic, weak) CALayer *centerContainer;

// The animated layers
@property (nonatomic, weak) CATextLayer *leftColon;
@property (nonatomic, weak) CATextLayer *rightColon;
@property (nonatomic, weak) CATextLayer *parenthesis;

@end

@implementation SmileySwitch

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self sharedInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self sharedInit];
    }
    return self;
}

-(void)sharedInit {
    
    float radiusValue = self.bounds.size.width/4.;
    
    // Add the background layer
    CAShapeLayer *backgroundLayer = [CAShapeLayer layer];
    backgroundLayer.fillColor = self.backgroundColor.CGColor;
    UIBezierPath *ovalPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:radiusValue];
    backgroundLayer.path = ovalPath.CGPath;
    backgroundLayer.shadowRadius = 3.0;
    backgroundLayer.shadowOpacity = 0.3;
    backgroundLayer.shadowColor = [UIColor blackColor].CGColor;
    [self.layer addSublayer:backgroundLayer];
    self.backgroundLayer = backgroundLayer; // Store weak pointer
    [self setBackgroundShadow]; // Set the background shadow
    
    // Add the center container
    CALayer *centerContainer = [CALayer layer];
    centerContainer.frame = CGRectInset(self.bounds, self.bounds.size.width / 8., self.bounds.size.height / 8.);
    [self.layer addSublayer:centerContainer];
    self.centerContainer = centerContainer;
    
    // Add the left colon
    CATextLayer *leftColon = [CATextLayer layer];
    leftColon.contentsScale = [UIScreen mainScreen].scale;
    leftColon.string = @":";
    leftColon.foregroundColor = [self isOn] ? self.onColor.CGColor : self.offColor.CGColor;
    leftColon.frame = CGRectOffset(self.centerContainer.bounds, 0, -self.bounds.size.height / 8.); // To account for the colon offset heights
    leftColon.alignmentMode = kCAAlignmentLeft;
    leftColon.fontSize = self.centerContainer.frame.size.height;
    [self.centerContainer addSublayer:leftColon];
    self.leftColon = leftColon;
    
    // Add the right colon
    CATextLayer *rightColon = [CATextLayer layer];
    rightColon.contentsScale = [UIScreen mainScreen].scale;
    rightColon.string = @":";
    rightColon.foregroundColor = [self isOn] ? self.onColor.CGColor : self.offColor.CGColor;
    rightColon.frame = CGRectOffset(self.centerContainer.bounds, 0, -self.bounds.size.height / 8.); // To account for the colon offset heights
    rightColon.alignmentMode = kCAAlignmentRight;
    rightColon.fontSize = self.centerContainer.frame.size.height;
    [self.centerContainer addSublayer:rightColon];
    self.rightColon = rightColon;
    
    // Add the moving parenthesis
    CATextLayer *parenthesis = [CATextLayer layer];
    parenthesis.contentsScale = [UIScreen mainScreen].scale;
    parenthesis.string = @")";
    parenthesis.foregroundColor = [self isOn] ? self.onColor.CGColor : self.offColor.CGColor;
    parenthesis.alignmentMode = kCAAlignmentCenter;
    parenthesis.fontSize = self.centerContainer.frame.size.height - self.bounds.size.height / 6.;
    [self.centerContainer addSublayer:parenthesis];
    self.parenthesis = parenthesis;
    
    // Move the parenthesis to its current position
    [self setParenthesisFrame];
    
    // Add the gesture recognizers
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    [self addGestureRecognizer:tapGestureRecognizer];
}

-(void)setParenthesisFrame {
    float offset = [self isOn] ? -1 : 1;
    offset = offset * (self.centerContainer.bounds.size.width/2. - 15);
    [CATransaction begin];
    [CATransaction setAnimationDuration:0.5];
    self.parenthesis.frame = CGRectOffset(self.centerContainer.bounds, offset, 0);
    [CATransaction commit];
}

-(void)setBackgroundShadow {
    [CATransaction begin];
    [CATransaction setAnimationDuration:0.5];
    self.backgroundLayer.shadowOffset = CGSizeMake([self isOn] ? -5 : 5, 1);
    [CATransaction commit];
}

#pragma mark -
#pragma mark Action Handling Methods

-(void)tapped:(UITapGestureRecognizer *)gestureRecognizer {
    [self setOn:!self.on];
}

-(void)setOn:(BOOL)on {
    _on = on;
    [self setParenthesisFrame];
    [self setBackgroundShadow];
    self.parenthesis.foregroundColor = _on ? self.onColor.CGColor : self.offColor.CGColor;
    self.leftColon.foregroundColor = [self isOn] ? self.onColor.CGColor : self.offColor.CGColor;
    self.rightColon.foregroundColor = [self isOn] ? self.onColor.CGColor : self.offColor.CGColor;
}

#pragma mark -
#pragma mark Color Getters (Lazily instantiated if not overwritten)

@synthesize backgroundColor = _backgroundColor;

-(void)setBackgroundColor:(UIColor *)backgroundColor {
    _backgroundColor = backgroundColor;
    if (self.backgroundLayer) {
        self.backgroundLayer.fillColor = backgroundColor.CGColor; // Update the background layer
    }
}

-(UIColor *)backgroundColor {
    if (!_backgroundColor) {
        _backgroundColor = [UIColor colorWithRed:247.0f/255.0f green:244.0f/255.0f blue:242.0f/255.0f alpha:1.0];
    }
    return _backgroundColor;
}

@synthesize onColor = _onColor;

-(void)setOnColor:(UIColor *)onColor {
    _onColor = onColor;
}

-(UIColor *)onColor {
    if (!_onColor) {
        _onColor = [UIColor colorWithRed:61.0f/255.0f green:180.0f/255.0f blue:5.0f/255.0f alpha:1.0];
    }
    return _onColor;
}

@synthesize offColor = _offColor;

-(void)setOffColor:(UIColor *)offColor {
    _offColor = offColor;
}

-(UIColor *)offColor {
    if (!_offColor) {
        _offColor = [UIColor colorWithRed:180.0f/255.0f green:180.0f/255.0f blue:180.0f/255.0f alpha:1.0];
    }
    return _offColor;
}

@end
