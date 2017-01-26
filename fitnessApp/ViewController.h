//
//  ViewController.h
//  fitnessApp
//
//  Created by Hester Corne on 05/01/2017.
//  Copyright © 2017 Hester Corne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeekDay.h"
#import "WeekViewItem.h"
#import "HeartRateView.h"

@interface ViewController : UIViewController
//Week Day View Bar Labels
@property (weak, nonatomic) IBOutlet UILabel *day1Label;
@property (weak, nonatomic) IBOutlet UILabel *day2Label;
@property (weak, nonatomic) IBOutlet UILabel *day3Label;
@property (weak, nonatomic) IBOutlet UILabel *day4Label;
@property (weak, nonatomic) IBOutlet UILabel *day5Label;
@property (weak, nonatomic) IBOutlet UILabel *day6Label;
@property (weak, nonatomic) IBOutlet UILabel *day7Label;
//Week Day View Bar Background
@property (weak, nonatomic) IBOutlet UIImageView *weekViewBackground;
//Week Day View Bar Images
@property (weak, nonatomic) IBOutlet UIImageView *day1Image;
@property (weak, nonatomic) IBOutlet UIImageView *day2Image;
@property (weak, nonatomic) IBOutlet UIImageView *day3Image;
@property (weak, nonatomic) IBOutlet UIImageView *day4Image;
@property (weak, nonatomic) IBOutlet UIImageView *day5Image;
@property (weak, nonatomic) IBOutlet UIImageView *day6Image;
@property (weak, nonatomic) IBOutlet UIImageView *day7Image;
//Workout Overview
@property (weak, nonatomic) IBOutlet UILabel *todayLabel;
@property (weak, nonatomic) IBOutlet UILabel *workoutTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *parameter1Label;
@property (weak, nonatomic) IBOutlet UILabel *parameter2Label;
@property (weak, nonatomic) IBOutlet UILabel *parameter3Label;
@property (weak, nonatomic) IBOutlet UILabel *parameter4Label;
@property (weak, nonatomic) IBOutlet UILabel *parameter5Label;
@property (weak, nonatomic) IBOutlet HeartRateView *heartRateView;

@end

