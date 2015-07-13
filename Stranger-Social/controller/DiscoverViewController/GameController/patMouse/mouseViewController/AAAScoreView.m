//
//  AAAScoreView.m
//  Gamify
//
//  Created by Håkon Bogen on 12.02.14.
//  Copyright (c) 2014 Haaakon Bogen. All rights reserved.
//

#import "AAAScoreView.h"
#import "AAAGamificationManager.h"
#import <QuartzCore/QuartzCore.h>
const NSString  *kScoreLabelKey = @"scoreLabelKey";
const NSString  *kScoreToSetKey = @"scoreToSetKey";
@interface AAAScoreView ()

@end
@implementation AAAScoreView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
       
        self.scoreLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        self.backgroundColor = [UIColor clearColor];
        self.scoreChangeLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        [self.scoreLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:30]];
        [self.scoreChangeLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:30]];
        [self.scoreLabel setTextColor:kGetColor(240, 241, 112)];
        [self.scoreLabel setTextAlignment:NSTextAlignmentCenter];
        [self.scoreChangeLabel setTextColor:kGetColor(240, 241, 112)];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.scoreLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        self.backgroundColor = [UIColor clearColor];
        self.scoreChangeLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        [self.scoreLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:30]];
        [self.scoreChangeLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:30]];
        [self.scoreLabel setTextColor:[UIColor blackColor]];
        [self.scoreChangeLabel setTextColor:[UIColor blackColor]];
    }
    
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (self.scoreLabel.superview == nil) {
        [self addSubview: self.scoreLabel];
    }
    
    if (self.scoreChangeLabel.superview == nil) {
        [self addSubview: self.scoreChangeLabel];
    }
    
    [self.scoreLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.scoreChangeLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.scoreLabel
                                                     attribute:NSLayoutAttributeLeft
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeLeft
                                                    multiplier:1.0
                                                      constant:0.0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.scoreLabel
                                                     attribute:NSLayoutAttributeRight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeRight
                                                    multiplier:1.0
                                                      constant:0.0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.scoreLabel
                                                     attribute:NSLayoutAttributeCenterY
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterY
                                                    multiplier:1.0
                                                      constant:0.0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.scoreChangeLabel
                                                     attribute:NSLayoutAttributeLeft
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeLeft
                                                    multiplier:1.0
                                                      constant:0.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.scoreChangeLabel
                                                     attribute:NSLayoutAttributeRight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeRight
                                                    multiplier:1.0
                                                      constant:0.0]];
    
    NSLayoutConstraint *yPositionConstraint = [NSLayoutConstraint constraintWithItem:self.scoreChangeLabel
                                                                           attribute:NSLayoutAttributeCenterY
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:self
                                                                           attribute:NSLayoutAttributeCenterY
                                                                          multiplier:1.0
                                                                            constant:1.0];
    [self addConstraint:yPositionConstraint];
    
    self.scoreChangeYConstraint = yPositionConstraint;
}

- (void)setScoreTextAlignment:(NSTextAlignment)textAlignment
{
    self.scoreLabel.textAlignment = textAlignment;
    self.scoreChangeLabel.textAlignment = textAlignment;
}
- (void)setScoreLabelColor:(UIColor *)color
{
    self.scoreLabel.textColor = color;
}

- (void)setScoreLabelFont:(UIFont*)font
{
    [self.scoreLabel setFont:font];
    self.scoreChangeLabel.font = font;
    [self layoutIfNeeded];
}

- (void)setScoreTo:(NSInteger)score scoreChange:(NSInteger)change
{
    if (self.incrementingTimer) {
        [self.incrementingTimer invalidate];
        self.incrementingTimer = nil;
    }
    // add animation for the change of score
    [self animateScoreChangeLabel];
    double delayInSeconds = 0.1;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.040 target:self selector:@selector(increment:) userInfo:@{kScoreLabelKey:self.scoreLabel, kScoreToSetKey : [NSNumber numberWithInteger:score]} repeats:YES];
        [timer fire];
        self.incrementingTimer = timer;
        if (change > 0) {
            self.scoreChangeLabel.text = [NSString stringWithFormat:@"+%ld",(long)change];
        }else {
            self.scoreChangeLabel.text = [NSString stringWithFormat:@"%ld",(long)change];
        }
    });
}

- (void)setScoreWithoutAnimation:(NSInteger) score
{
    [self.incrementingTimer invalidate];
    self.scoreLabel.text =  [NSString stringWithFormat:@"%ld", (long)score];
}

- (void)animateScoreChangeLabel
{
    [self removeConstraints:self.scoreChangeLabel.constraints];
    self.scoreChangeLabel.alpha = 0;
    __block NSLayoutConstraint *newYpositionConstraint;
    [CATransaction begin];
    [self.scoreChangeLabel.layer removeAllAnimations];
    [self.layer removeAllAnimations];
    [CATransaction commit];
    [self layoutSubviews];
    [self removeConstraint:self.scoreChangeYConstraint];
    NSLayoutConstraint *yPositionConstraint = [NSLayoutConstraint constraintWithItem:self.scoreChangeLabel
                                                                           attribute:NSLayoutAttributeCenterY
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:self
                                                                           attribute:NSLayoutAttributeCenterY
                                                                          multiplier:1.0
                                                                            constant:1.0];
    [self addConstraint:yPositionConstraint];
    self.scoreChangeYConstraint = yPositionConstraint;
    [self layoutSubviews];
    [UIView animateWithDuration:0.7 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.scoreChangeLabel.alpha = 1;
        [self  removeConstraint:self.scoreChangeYConstraint];
        
        newYpositionConstraint = [NSLayoutConstraint constraintWithItem:self.scoreChangeLabel
                                                              attribute:NSLayoutAttributeTop
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self
                                                              attribute:NSLayoutAttributeTop
                                                             multiplier:1.0
                                                               constant:-10.0];
        
        [self addConstraint:newYpositionConstraint];
        [self layoutSubviews];
    } completion:^(BOOL finished) {
        if (finished) {
            [UIView animateWithDuration:0.3 delay:0.2 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                self.scoreChangeLabel.alpha = 0;
            } completion:^(BOOL finished) {
                if ( finished){
                    [self removeConstraint:newYpositionConstraint];
                    [self addConstraint:self.scoreChangeYConstraint];
                }
            } ];
        }
    }];
}

- (void)increment:(NSTimer *)timer {
    
    UILabel *label = (UILabel *)timer.userInfo[kScoreLabelKey];
    NSNumber *goalValue = timer.userInfo[kScoreToSetKey];
    
    NSInteger currentValue = label.text.integerValue;
    
    if (currentValue < [goalValue integerValue] ) {
        currentValue++;
    } else {
        currentValue--;
    }
    label.text = [NSString stringWithFormat:@"%ld", (long)currentValue];
    if(currentValue == [goalValue integerValue]){
        [timer invalidate];//stops calling this method
    }
    
}

- (void)setup
{
    
}

- (void)show
{
    
}

@end
