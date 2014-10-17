//
//  SmileySwitch.m
//  SmileySwitch
//
//  Created by Tyler McAtee on 10/15/14.
//  Copyright (c) 2014 Apple. All rights reserved.
//

#import "SmileySwitch.h"

@interface SmileySwitch()

// Background layer
@property (nonatomic, weak) CAShapeLayer *backgroundLayer;

// The animated layers
@property (nonatomic, weak) CATextLayer *leftColon;
@property (nonatomic, weak) CATextLayer *rightColon;
@property (nonatomic, weak) CATextLayer *parenthesis;


@end

@implementation SmileySwitch

#pragma mark -
#pragma mark Initialization

+(instancetype)SmileySwitch {
    SmileySwitch *smiley = [[SmileySwitch alloc] init];
    return smiley;
}

-(instancetype)init {
    self = [self initWithFrame:CGRectMake(0, 0, 90, 44)];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addLayers];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self addLayers];
    }
    return self;
}

#pragma mark -
#pragma mark - Setting up the Layers

-(void)addLayers {
    
    float radiusValue = self.bounds.size.width/4.;
    self.shouldDisplayShadows = YES;
    
    // Add the background layer
    CAShapeLayer *backgroundLayer = [CAShapeLayer layer];
    backgroundLayer.fillColor = self.backingColor.CGColor;
    UIBezierPath *ovalPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:radiusValue];
    backgroundLayer.path = ovalPath.CGPath;
    backgroundLayer.shadowRadius = 3.0;
    backgroundLayer.shadowOpacity = 0.3;
    backgroundLayer.shadowColor = [UIColor blackColor].CGColor;
    [self.layer addSublayer:backgroundLayer];
    self.backgroundLayer = backgroundLayer; // Store weak pointer
    [self setBackgroundShadow]; // Set the background shadow
    
    // Add the left colon
    CATextLayer *leftColon = [CATextLayer layer];
    leftColon.contentsScale = [UIScreen mainScreen].scale;
    leftColon.foregroundColor = [self isOn] ? self.onColor.CGColor : self.offColor.CGColor;
    leftColon.string = @":";
    leftColon.alignmentMode = kCAAlignmentLeft;
    [self.layer addSublayer:leftColon];
    self.leftColon = leftColon;
    
    // Add the right colon
    CATextLayer *rightColon = [CATextLayer layer];
    rightColon.contentsScale = [UIScreen mainScreen].scale;
    rightColon.foregroundColor = [self isOn] ? self.onColor.CGColor : self.offColor.CGColor;
    rightColon.string = @":";
    rightColon.alignmentMode = kCAAlignmentRight;
    [self.layer addSublayer:rightColon];
    self.rightColon = rightColon;
    
    // Add the moving parenthesis
    CATextLayer *parenthesis = [CATextLayer layer];
    parenthesis.contentsScale = [UIScreen mainScreen].scale;
    parenthesis.foregroundColor = [self isOn] ? self.onColor.CGColor : self.offColor.CGColor;
    parenthesis.string = @")";
    parenthesis.alignmentMode = kCAAlignmentCenter;
    [self.layer addSublayer:parenthesis];
    self.parenthesis = parenthesis;

    float fontSize = self.bounds.size.height;
    
    // position the left colon
    leftColon.frame = CGRectOffset(self.bounds, self.bounds.size.width / 8., -self.bounds.size.height / 6.); // Experimentally determined to 'center' colon
    leftColon.font = (__bridge CFTypeRef)([UIFont fontWithName:@"ArialRoundedMTBold" size:fontSize]);
    leftColon.fontSize = fontSize;
    
    // position the right colon
    rightColon.frame = CGRectOffset(self.bounds, -self.bounds.size.width / 8., -self.bounds.size.height / 6.); // Experimentally determeind to 'center' colon
    rightColon.font = (__bridge CFTypeRef)([UIFont fontWithName:@"ArialRoundedMTBold" size:fontSize]);
    rightColon.fontSize = fontSize;
    
    // position the parenthesis (starting in center)
    fontSize /= 2; // parenthesis font size is half of the colon font size.
    parenthesis.fontSize = fontSize;
    parenthesis.font = (__bridge CFTypeRef)([UIFont fontWithName:@"ArialRoundedMTBold" size:fontSize]);
  
    // Move the parenthesis to its current position
    [self setParenthesisFrame];

    // Add the gesture recognizers
    
    // Tap gesture for turning it on immediately
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    [self addGestureRecognizer:tapGestureRecognizer];
}

-(void)setParenthesisFrame {
    // Move the parenthesis left or right depending on whether we are on or not
    float offset = self.bounds.size.width/ 2. - self.bounds.size.width / 8. - self.bounds.size.height / 2.;
    offset *= [self isOn] ? -1 : 1;
    [CATransaction begin];
    [CATransaction setAnimationDuration:0.5];
    self.parenthesis.frame = CGRectOffset(self.bounds, offset, self.bounds.size.height / 6.); // height offset experimentally determined to center.
    [CATransaction commit];
}

-(void)setParenthesisFramePartial:(CGFloat)percent {
    float offset = self.bounds.size.width/ 2. - self.bounds.size.width / 8. - self.bounds.size.height / 2.;
    offset *= [self isOn] ? -1 : 1;
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
    self.parenthesis.frame = CGRectOffset(self.bounds, -offset + 2 * percent * offset, self.bounds.size.height / 6.); // height offset experimentally determined to center.
    [CATransaction commit];
}

-(void)setBackgroundShadow {
    // Move the background shadow left or right depending on whether we are on or not
    [CATransaction begin];
    [CATransaction setAnimationDuration:0.1];
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
#pragma mark Color Getters / Setters

@synthesize backingColor = _backingColor;

-(void)setbackingColor:(UIColor *)backingColor {
    _backingColor = backingColor;
    if (self.backgroundLayer) {
        self.backgroundLayer.fillColor = backingColor.CGColor; // Update the background layer
    }
}

-(UIColor *)backingColor {
    if (!_backingColor) {
        _backingColor = [UIColor colorWithRed:247.0f/255.0f green:244.0f/255.0f blue:242.0f/255.0f alpha:1.0];
    }
    return _backingColor;
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

#pragma mark -
#pragma mark - Further setters / getters

-(void)setShouldDisplayShadows:(BOOL)shouldDisplayShadows {
    _shouldDisplayShadows = shouldDisplayShadows;
    if (_shouldDisplayShadows) {
        self.backgroundLayer.shadowRadius = 3.0;
        self.backgroundLayer.shadowOpacity = 0.3;
    } else {
        self.backgroundLayer.shadowRadius = 0.0;
        self.backgroundLayer.shadowOpacity = 0.0;
    }
}

@end
