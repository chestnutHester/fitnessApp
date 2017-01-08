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

@interface ViewController : UIViewController
//Week Day View Bar
@property (weak, nonatomic) IBOutlet UILabel *day1Label;
@property (weak, nonatomic) IBOutlet UILabel *day2Label;
@property (weak, nonatomic) IBOutlet UILabel *day3Label;
@property (weak, nonatomic) IBOutlet UILabel *day4Label;
@property (weak, nonatomic) IBOutlet UILabel *day5Label;
@property (weak, nonatomic) IBOutlet UILabel *day6Label;
@property (weak, nonatomic) IBOutlet UILabel *day7Label;
@property (weak, nonatomic) IBOutlet UIImageView *weekViewBackground;
@property (weak, nonatomic) IBOutlet UIImageView *day1Image;
@property (weak, nonatomic) IBOutlet UIImageView *day2Image;
@property (weak, nonatomic) IBOutlet UIImageView *day3Image;
@property (weak, nonatomic) IBOutlet UIImageView *day4Image;
@property (weak, nonatomic) IBOutlet UIImageView *day5Image;
@property (weak, nonatomic) IBOutlet UIImageView *day6Image;
@property (weak, nonatomic) IBOutlet UIImageView *day7Image;


@end

