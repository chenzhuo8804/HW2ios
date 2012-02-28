//
//  CalculatorBrain.h
//  Calculator
//
//  Created by CS193p Instructor.
//  Copyright (c) 2011 Stanford University.
//  All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject


/* Push variable to the stack */
-(void) pushVariable:(NSString*)variable;

/* Push operand to the current stack */
- (void)pushOperand:(double)operand;

/* Clear the current opeand stack */
- (void)clearOperandStack;

/* Test if an object is varible */
+(BOOL)isVariable:(id)object;

/* Test if an object is operation */
+(BOOL)isOperation:(id)object;

/* undo the action */
-(void)undo;


/* Perform operation using the stack and variable dictionary */
-(double)performOperation:(NSString* ) operation usingVariables:(NSDictionary*)variableValue;

/* pop the program stack to be a string */
+ (NSString *)popDescriptionOffProgramStack:(id)program;

/* program stack */
@property (nonatomic, readonly) id program;

/* return the program to be a string */
+ (NSString *)descriptionOfProgram:(id)program;

/* get the value of the program stack */
+ (double)runProgram:(id)program usingVariableValues:(NSDictionary*)variableValues;

/* pop the program stack to be a double */
+ (double)popOperandOffProgramStack:(NSMutableArray *)stack usingVariableValues: (NSDictionary*)varriableValues;

/* get the list of a program stack */
+(NSSet *)variablesUsedInProgram:(id)program;
@end