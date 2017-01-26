//
//  HeartRateView.m
//  fitnessApp
//
//  Created by Hester Corne on 24/01/2017.
//  Copyright © 2017 Hester Corne. All rights reserved.
//

#import "HeartRateView.h"

@interface HeartRateView()
@property CGPoint startPoint;
@property CGPoint endPoint;
@property CGPoint axisOrigin;
@end

@implementation HeartRateView

//
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {

    
    // Get the context
    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetFillColorWithColor(context, [UIColor orangeColor].CGColor);
//    CGContextFillPath(context);
    
    //Find the coordinates for the axes
    CGPoint origin = rect.origin;
    CGFloat startX = origin.x + 10;
    CGFloat startY = origin.y + 10;
    _startPoint = CGPointMake(startX, startY);
    
    CGFloat endX = rect.size.width - 10;
    CGFloat endY = rect.size.height - 10;
    _endPoint = CGPointMake(endX, endY);
    
    _axisOrigin = CGPointMake(startX, endY);
    
    //Draw the x axis
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, startX, endY);
    CGContextAddLineToPoint(context, endX, endY);
    CGContextClosePath(context);
    CGContextSetStrokeColorWithColor(context, [UIColor blueColor].CGColor);
    CGContextStrokePath(context);
    
    //Draw the y axis
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, startX, startY);
    CGContextAddLineToPoint(context, startX, endY);
    CGContextClosePath(context);
    CGContextSetStrokeColorWithColor(context, [UIColor blueColor].CGColor);
    CGContextStrokePath(context);
}

-(void)plotHeartRate:(NSArray *)dataPoints{
    CGFloat min = 999;
    CGFloat max = 0;
    
    for(HKQuantitySample *sample in dataPoints){
        CGFloat heartRate = [sample.quantity doubleValueForUnit:[[HKUnit countUnit] unitDividedByUnit:[HKUnit minuteUnit]]];
        if(heartRate > max){
            max = heartRate;
        }
        if(heartRate < min){
            min = heartRate;
        }
    }
    
    NSLog(@"Min: %f, Max: %f", min, max);
    NSLog(@"Plotting...");
    
    //Scale the x axis
    CGFloat xSpread = (CGFloat)(_endPoint.x - _startPoint.x)/dataPoints.count;
    CGFloat ySpread = (CGFloat)(_startPoint.y - _endPoint.y)/(max-min);
    
    UIGraphicsBeginImageContext(CGSizeMake(300, 109));
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, _axisOrigin.x, _endPoint.y);
    
    int i=0;
    for(HKQuantitySample *sample in dataPoints){
        CGFloat heartRate = [sample.quantity doubleValueForUnit:[[HKUnit countUnit] unitDividedByUnit:[HKUnit minuteUnit]]];
        CGFloat xCoord = i*xSpread + _startPoint.x;
        CGFloat yCoord = (heartRate - min) * ySpread + _endPoint.y;
        CGContextAddLineToPoint(context, xCoord, yCoord);
        //CGContextMoveToPoint(context, xCoord, yCoord);

        i++;
    }
    
    CGContextClosePath(context);
    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
    CGContextStrokePath(context);
    
    UIGraphicsEndImageContext();
}

@end
