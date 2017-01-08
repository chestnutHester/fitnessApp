//
//  WeekViewItem.m
//  fitnessApp
//
//  Created by Hester Corne on 08/01/2017.
//  Copyright © 2017 Hester Corne. All rights reserved.
//

#import "WeekViewItem.h"

@implementation WeekViewItem
-(WeekViewItem*)initWithLabel:(UILabel*)label image:(UIImageView*)image{
    self = [super init];
    _label = label;
    _image = image;
    return self;
}
@end
