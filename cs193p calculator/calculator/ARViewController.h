//
//  ARViewController.h
//  calculator
//
//  Created by Aleksey Rygin on 28.05.13.
//  Copyright (c) 2013 Aleksey Rygin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ARCalculatorBrain.h"

@interface ARViewController : UIViewController
{
    IBOutlet UILabel *display;
    IBOutlet UILabel *memory;
    ARCalculatorBrain *brain;
    BOOL userIsInTheMiddleOfTypingANumber;
}

-(IBAction)digitPressed:(UIButton *)sender;
-(IBAction)operationPressed:(UIButton *)sender;
-(IBAction)setVariableAsOperand:(UIButton *)sender;

@end
