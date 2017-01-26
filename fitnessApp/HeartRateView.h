//
//  HeartRateView.h
//  fitnessApp
//
//  Created by Hester Corne on 24/01/2017.
//  Copyright © 2017 Hester Corne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <HealthKit/HealthKit.h>

@interface HeartRateView : UIView
-(void)plotHeartRate:(NSArray *)dataPoints;
@end
