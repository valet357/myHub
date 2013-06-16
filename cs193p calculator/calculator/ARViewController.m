//
//  ARViewController.m
//  calculator
//
//  Created by Aleksey Rygin on 28.05.13.
//  Copyright (c) 2013 Aleksey Rygin. All rights reserved.
//

#import "ARViewController.h"

@interface ARViewController ()
@property (readonly) ARCalculatorBrain *brain;
@end

@implementation ARViewController

-(ARCalculatorBrain *) brain
{
    if(!brain) brain = [[ARCalculatorBrain alloc] init];
    return brain;
}

-(IBAction)digitPressed:(UIButton *)sender
{
    NSString *digit = sender.titleLabel.text;
    NSRange range = [display.text rangeOfString:@"."];
    
    if (userIsInTheMiddleOfTypingANumber) {
        if ([digit isEqual:@"."])  {
            if (range.location == NSNotFound) {
                display.text = [display.text stringByAppendingString:digit];
            }
        }
        else {
            display.text = [display.text stringByAppendingString:digit];
        }
    }
    else {
        if ([digit isEqual:@"."])  {
            display.text = @"0.";
        }
        else  {
            display.text = digit;
        }
        userIsInTheMiddleOfTypingANumber = YES;
    }
}

-(IBAction)operationPressed:(UIButton *)sender
{
    if(userIsInTheMiddleOfTypingANumber){
        self.brain.operand = [display.text doubleValue];
        userIsInTheMiddleOfTypingANumber = NO;
    }
    NSString *operation = sender.titleLabel.text;
    [self.brain performOperation:operation];
    display.text = [NSString stringWithFormat:@"%g", self.brain.operand];
    //display.text = self.brain.description;
    memory.text = [NSString stringWithFormat:@"%g", self.brain.memory];
}

-(IBAction)setVariableAsOperand:(UIButton *)sender
{
    [self.brain setVariableAsOperand:sender.titleLabel.text];
}

@end
