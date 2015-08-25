//
//  ViewRectCard.m
//  PupilsDistance
//
//  Created by Trinh Van Duong on 2/12/15.
//  Copyright (c) 2015 Trinh Van Duong. All rights reserved.
//

#import "ViewRectCard.h"

CGFloat kResizeThumbSize = 45.0f;

@implementation ViewRectCard

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    touchStart = [[touches anyObject] locationInView:self];
    isResizingLR = (self.bounds.size.width - touchStart.x < kResizeThumbSize && self.bounds.size.height - touchStart.y < kResizeThumbSize);
    isResizingUL = (touchStart.x <kResizeThumbSize && touchStart.y <kResizeThumbSize);
    isResizingUR = (self.bounds.size.width-touchStart.x < kResizeThumbSize && touchStart.y<kResizeThumbSize);
    isResizingLL = (touchStart.x <kResizeThumbSize && self.bounds.size.height -touchStart.y <kResizeThumbSize);
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint touchPoint = [[touches anyObject] locationInView:self];
    CGPoint previous = [[touches anyObject] previousLocationInView:self];
    
    CGFloat deltaWidth = touchPoint.x - previous.x;
    CGFloat deltaHeight = touchPoint.y - previous.y;
    
    // get the frame values so we can calculate changes below
    CGFloat x = self.frame.origin.x;
    CGFloat y = self.frame.origin.y;
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    
    if (isResizingLR) {
        self.frame = CGRectMake(x, y, touchPoint.x+deltaWidth, touchPoint.y+deltaWidth);
    } else if (isResizingUL) {
        self.frame = CGRectMake(x+deltaWidth, y+deltaHeight, width-deltaWidth, height-deltaHeight);
    } else if (isResizingUR) {
        self.frame = CGRectMake(x, y+deltaHeight, width+deltaWidth, height-deltaHeight);
    } else if (isResizingLL) {
        self.frame = CGRectMake(x+deltaWidth, y, width-deltaWidth, height+deltaHeight);
    } else {
        // not dragging from a corner -- move the view
        self.center = CGPointMake(self.center.x + touchPoint.x - touchStart.x,
                                  self.center.y + touchPoint.y - touchStart.y);
    }
}

@end
