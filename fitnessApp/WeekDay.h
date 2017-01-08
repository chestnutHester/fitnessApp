//
//  WeekDay.h
//  fitnessApp
//
//  Created by Hester Corne on 08/01/2017.
//  Copyright © 2017 Hester Corne. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeekDay : NSObject

@property(nonatomic) int dayOfTheWeek;
@property(nonatomic) bool workout;
-(WeekDay*)initWithDayOfTheWeek:(int)dayOfTheWeek;
@end
