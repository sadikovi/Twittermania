//
//  CircleImageView.m
//  Twittermania
//
//  Created by Ivan Sadikov on 27/06/14.
//  Copyright (c) 2014 Ivan Sadikov. All rights reserved.
//

#import "CircleImageView.h"

#define CGFloatZero 0.0f;

@implementation CircleImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setup];
    }
    return self;
}

- (void)setup {
    /*
    CGFloat side = (self.frame.size.width > self.frame.size.height) ? self.frame.size.height : self.frame.size.width;
    CGRect squareFrame = CGRectMake(0, 0, side, side);
    self.frame = squareFrame;
    */
    self.backgroundColor = nil;
    self.opaque = NO;
    self.contentMode = UIViewContentModeRedraw;
}

- (void)awakeFromNib {
    NSLog(@"CircleImageView: awake");
    [self setup];
    [self setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    NSLog(@"CircleImageView: drawrect");
    CGFloat radius = self.bounds.size.width;
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:10];
    
    [path addClip];
    [[UIColor blueColor] setFill];
    UIRectFill(self.bounds);
    
    [[UIColor whiteColor] setStroke];
    [path stroke];
}

@end
