//
//  ARCalculatorBrain.h
//  calculator
//
//  Created by Aleksey Rygin on 28.05.13.
//  Copyright (c) 2013 Aleksey Rygin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ARCalculatorBrain : NSObject
{ 
    double operand;
    double memory;
    NSString *waitingOperation;
    double waitingOperand;
    NSMutableArray *internalExpression;
    id expression;
}
@property (nonatomic) double operand;
@property double memory;
@property double waitingOperand;
@property (copy) NSString *waitingOperation;
@property (readonly) id expression;

-(double)performOperation:(NSString *)operation;

-(void)setVariableAsOperand:(NSString *)variableName;

+ (double)evaluateExpression:(id)anExpression usingVariableValues:(NSDictionary *)variables;
+ (NSSet *)variablesInExpression:(id)anExpression;
+ (NSString *)descriptionOfExpression:(id)anExpression;
+ (id)propertyListForExpression:(id)anExpression;
+ (id)expressionForPropertyList:(id)propertyList;

@end
