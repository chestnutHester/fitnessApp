//
//  WeekViewItem.h
//  fitnessApp
//
//  Created by Hester Corne on 08/01/2017.
//  Copyright © 2017 Hester Corne. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WeekViewItem : NSObject
@property(strong,nonatomic) UILabel *label;
@property(strong,nonatomic) UIImageView *image;
-(WeekViewItem*)initWithLabel:(UILabel*)label image:(UIImageView*)image;
@end
