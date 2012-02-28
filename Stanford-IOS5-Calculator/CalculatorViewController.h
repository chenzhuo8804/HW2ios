//
//  CalculatorViewController.h
//  Stanford-IOS5-Calculator
//
//  Created by Zhuo Chen on 11/20/11.
//  Copyright (c) 2011 UB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalculatorViewController : UIViewController

/* display for result */
@property (weak, nonatomic) IBOutlet UILabel *display;

/* display for current program stack */
@property (weak, nonatomic) IBOutlet UILabel *display2;

/* display for dictionary */
@property (weak, nonatomic) IBOutlet UILabel *display3;

@end
