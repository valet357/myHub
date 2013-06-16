//
//  ARCalculatorBrain.m
//  calculator
//
//  Created by Aleksey Rygin on 28.05.13.
//  Copyright (c) 2013 Aleksey Rygin. All rights reserved.
//

#import "ARCalculatorBrain.h"


@implementation ARCalculatorBrain

@synthesize operand;
@synthesize memory;
@synthesize waitingOperand;
@synthesize waitingOperation;

// overriding the default initializer
- (id) init {
    // initializing the internalExpression array
    internalExpression = [[NSMutableArray alloc] init];
    return self;
}

- (void) setOperand: (double) newOperand {
    operand = newOperand;
    // add the operand to the expression array
    [internalExpression addObject:[NSNumber numberWithDouble:operand]];
}

// getter for expression property
- (id) expression {
    // return a copy of the internal expression array
    NSMutableArray *exp = [internalExpression copy];
    //[exp autorelease];
    return exp;
}

-(void)performWaitingOperation
{
    if([@"+" isEqual:self.waitingOperation]){
        operand = self.waitingOperand + self.operand;
    }
    else if([@"-" isEqual:self.waitingOperation]){
        operand = self.waitingOperand - self.operand;
    }
    else if([@"*" isEqual:self.waitingOperation]){
        operand = self.waitingOperand * self.operand;
    }
    else if([@"/" isEqual:self.waitingOperation]){
        if(operand){
            operand = self.waitingOperand / self.operand;
        }
    }
}

-(double)performOperation:(NSString *)operation
{
    if([operation isEqual:@"sqrt"]){
        if (self.operand >= 0){
            operand = sqrt(self.operand);
        }
        else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Ошибка!" message:@"корень из отрицательного числа" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"я так больше не буду...", nil];
            [alertView show];
        }
    }
    else if ([@"+/-" isEqual:operation]){
        operand = - self.operand;
    }
    else if ([@"1/x" isEqual:operation]){
        if (self.operand != 0){
        operand = 1 / self.operand;
        }
        else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Ошибка!" message:@"деление на 0" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"я так больше не буду...", nil];
            [alertView show];
        }
    }
//    else if ([@"<-" isEqual:operation]){
//        operand = ;
//    }
    else if ([@"sin" isEqual:operation]){
        operand = sin(self.operand);
    }
    else if ([@"cos" isEqual:operation]){
        operand = cos(self.operand);
    }
    else if ([@"MC" isEqual:operation]){
        memory = 0;
    }
    else if ([@"MR" isEqual:operation]){
        operand = self.memory;
    }
    else if ([@"M+" isEqual:operation]){
        memory = self.memory + self.operand;
    }
    else if ([@"C" isEqual:operation]){
        self.operand = 0;
        self.memory = 0;
        self.waitingOperand = 0;
        self.waitingOperation = nil;
        [internalExpression removeAllObjects];
    }
    else{
        [self performWaitingOperation];
        self.waitingOperation = operation;
        self.waitingOperand = self.operand;
    }
    [internalExpression addObject:operation];
    return self.operand;
}

// this method if invoked when the user presses a variable on screen
// adds the variable name to the internal expression tracker
- (void) setVariableAsOperand: (NSString *) variableName {
    [internalExpression addObject:[NSString stringWithFormat:@"$%@", variableName]];
}

// given an expression and a dictionary containing values for variables,
// this method will evaluate the result of the expression
+ (double) evaluateExpression: (id) anExpression
          usingVariableValues: (NSDictionary *) variables {
    // create a local instance of calculator brain for class method
    ARCalculatorBrain *myBrain = [[ARCalculatorBrain alloc] init];
    
    for (id object in anExpression) {
        
        // check if current object in expression is a number
        if ([object isKindOfClass:[NSNumber class]]) {
            myBrain.operand = [object doubleValue];
        } else if ([object isKindOfClass:[NSString class]] && ([object length] == 2)) {
            // object must be variable
            myBrain.operand = [[variables objectForKey:object] doubleValue];
        } else {
            // object must be an operator
            [myBrain performOperation:object];
        }
    }
    
    double value = myBrain.operand;
    // release local instance of calculator brain
    //[myBrain release];
    return value;
}

+ (NSSet *) variablesInExpression: (id) anExpression {
    // declaring a set to store variables uniquely
    NSMutableSet *variableSet = [[NSMutableSet alloc] init];
    // memory management
    //[variableSet autorelease];
    // looping through the expression to search for string objects that start with a '$'
    for (id object in anExpression) {
        // check if current object in expression is a string
        if ([object isKindOfClass:[NSString class]]) {
            // if the string object is a variable that is marked by the sign '$'
            if ([object rangeOfString:@"$"].location != NSNotFound) {
                // add the variable to the set
                [variableSet addObject:[NSString stringWithFormat:@"%c",
                                        [object characterAtIndex:1]]];
            }
        }
    }
    // if the set is empty return nil
    if ([variableSet count] == 0) {
        variableSet = nil;
    }
    return variableSet;
}

// class method that returns the entire expression without evaluating
+ (NSString *) descriptionOfExpression: (id) anExpression {
    // creating an autorelease mutable string object
    NSMutableString *description = [[NSMutableString alloc] init];
    //[description autorelease];
    // enumerating through the expression array and appending to the mutable string
    for (id object in anExpression) {
        if (([object isKindOfClass:[NSString class]]) && ([object characterAtIndex:0] == '$')) {
            [description appendString:[NSString stringWithFormat:@"%c", [object characterAtIndex:1]]];
        } else {
            [description appendString:[object description]];
        }
    }
    return description;
}

+ (id) propertyListForExpression: (id) anExpression {
    // return a copy of the internal expression mutable array
    NSMutableArray *pl = [anExpression copy];
    //[pl autorelease];
    return pl;
}

+ (id) expressionForPropertyList: (id) propertyList {
    // return a copy of the internal expression mutable array
    NSMutableArray *exp = [propertyList copy];
    //[exp autorelease];
    return exp;
}

@end
