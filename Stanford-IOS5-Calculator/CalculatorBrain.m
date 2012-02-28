//
//  CalculatorBrain.m
//  Calculator
//
//  Created by CS193p Instructor.
//  Copyright (c) 2011 Stanford University.
//  All rights reserved.
//

#import "CalculatorBrain.h"

@interface CalculatorBrain()
@property (nonatomic, strong) NSMutableArray *programStack;
@end

@implementation CalculatorBrain

@synthesize programStack = _programStack;

- (NSMutableArray *)programStack
{
    if (_programStack == nil) _programStack = [[NSMutableArray alloc] init];
    return _programStack;
}

- (id)program
{
    return [self.programStack mutableCopy];
}


/* Return the string discription of the program, 
 * i.e. 3,4,+ would return (" 3+ 4 ") 
 * a,sin would make it "sin(a)" 
 */
+ (NSString *)descriptionOfProgram:(id)program
{
    NSMutableString* result = [CalculatorBrain popDescriptionOffProgramStack:program].mutableCopy;
    while([program count] != 0){
        [result appendFormat:@"%@%@",
         @",",
         [CalculatorBrain popDescriptionOffProgramStack:program]
         ];
    }
    return result;    
}






+(BOOL)isOperation:(id)object{
    return ([object isKindOfClass:[NSString class]] && [@"+-*/sincossqrt" rangeOfString:object].location != NSNotFound);
}


+(BOOL)isVariable:(id)object{
    return ([object isKindOfClass:[NSString class]] && [@"abc" rangeOfString:object].location != NSNotFound);
}


/* get the description (NSString format) of the program stack */
+ (NSString *)popDescriptionOffProgramStack:(id)program {
    id topOfTheStack = [program lastObject];
    if(topOfTheStack) [program removeLastObject];
    if([topOfTheStack isKindOfClass:[NSNumber class]]){
        return [NSString stringWithFormat:@"%g", [topOfTheStack doubleValue]];        
    } else if([self isVariable:topOfTheStack]){
        return topOfTheStack;
    } else if([self isOperation:topOfTheStack]){
        if([@"sin" isEqualToString:topOfTheStack] ||
           [@"cos" isEqualToString:topOfTheStack] ||
           [@"sqrt" isEqualToString:topOfTheStack]){
            //    NSLog([NSString stringWithFormat:@"%i",[program count]]);
            if([@"(" isEqual:[program objectAtIndex:0]] && 
               [@")" isEqual:[program lastObject]])
                return [NSString stringWithFormat:@"%@%@",
                        topOfTheStack,
                        [self popDescriptionOffProgramStack:program]
                        ];
            else
                return [NSString stringWithFormat:@"%@%@%@%@",
                        topOfTheStack,
                        @"(",
                        [self popDescriptionOffProgramStack:program],
                        @")"
                        ];         
            
            
        } else if([@"+-" rangeOfString:topOfTheStack].location != NSNotFound){
            return [NSString stringWithFormat:@"%@%@%@%@%@",                    
                    @"(",
                    [self popDescriptionOffProgramStack:program],                    
                    topOfTheStack,                    
                    [self popDescriptionOffProgramStack:program],
                    @")"   
                    ];
        } else if([@"*" rangeOfString:topOfTheStack].location != NSNotFound) {
            return [NSString stringWithFormat:@"%@%@%@",     
                    [self popDescriptionOffProgramStack:program],                    
                    topOfTheStack,                    
                    [self popDescriptionOffProgramStack:program]                        
                    ];
        } else if([@"/" isEqualToString:topOfTheStack]){
            NSString* divisor = [self popDescriptionOffProgramStack:program];
            return [NSString stringWithFormat:@"%@%@%@", 
                    [self popDescriptionOffProgramStack:program],
                    @"/",
                    divisor];
        } else {return  nil;} 
        
    } else {return nil;}
    if(!program){
        return nil;}
    
    
    return nil;
    
}



- (void)pushOperand:(double)operand
{
    [self.programStack addObject:[NSNumber numberWithDouble:operand]];
}


- (void)clearOperandStack{
    [self.programStack removeAllObjects];
}







+(void)testStack:(id)program{
    NSLog(@"Testing");
    for(id object in program){
        if([object isKindOfClass:[NSString class]]){
            
        //    NSLog([NSString stringWithFormat:@"%@%@",@"String",object]);
        } else if([object isKindOfClass:[NSNumber class]]){
         //   NSLog([NSString stringWithFormat:@"%@%g",@"Number",[object doubleValue]]);
        }
    }   
}

-(void) pushVariable:(NSString*)variable{
  //  NSLog([NSString stringWithFormat:@"%@ %@",   @"Pushing Varaible",variable]);
    [self.programStack addObject:variable];
    [[self class] testStack:[self program]];
        
}


/* Get the double value of the program stack */
+ (double)popOperandOffProgramStack:(NSMutableArray *)stack usingVariableValues: (NSDictionary*)varriableValues
{
    
   // NSLog([NSString stringWithFormat:@"%b",[self isVariable:@"x"]]);
  //  NSLog([n]);
    NSLog(@"PopOperandOffProgramStack");
    [self testStack:stack];
    double result = 0;    
    id topOfStack = [stack lastObject];
    
    if (topOfStack) [stack removeLastObject];
    
    //NSLog(str);
    if([topOfStack isKindOfClass:[NSString class]]){
     //   NSLog(topOfStack);
    } else if([topOfStack isKindOfClass:[NSNumber class]]){
      //  NSLog([NSString stringWithFormat:@"%g",[topOfStack doubleValue]]);
    }
    
    if ([topOfStack isKindOfClass:[NSNumber class]])
    {
        result = [topOfStack doubleValue];
    } 
    else if([self isVariable:topOfStack]){
        result = [[varriableValues valueForKey:topOfStack] doubleValue];
        NSLog(@"I'm here");
    //    NSLog([NSString stringWithFormat:@"%g",result]);
    } 
    else if ([self isOperation:topOfStack]) {
        NSString *operation = topOfStack;
        if ([operation isEqualToString:@"+"]) {
            result = [self popOperandOffProgramStack:stack usingVariableValues:varriableValues] +
            [self popOperandOffProgramStack:stack usingVariableValues:varriableValues];
        } else if ([@"*" isEqualToString:operation]) {
            result = [self popOperandOffProgramStack:stack usingVariableValues:varriableValues] *
            [self popOperandOffProgramStack:stack usingVariableValues:varriableValues];
        } else if ([operation isEqualToString:@"-"]) {
            double subtrahend = [self popOperandOffProgramStack:stack usingVariableValues:varriableValues];
            result = [self popOperandOffProgramStack:stack usingVariableValues:varriableValues] - subtrahend;
        } else if ([operation isEqualToString:@"/"]) {
            double divisor = [self popOperandOffProgramStack:stack usingVariableValues:varriableValues];
            if (divisor) result = [self popOperandOffProgramStack:stack usingVariableValues:varriableValues] / divisor;
        } else if([operation isEqualToString:@"sqrt"]){
            result = sqrt([self popOperandOffProgramStack:stack usingVariableValues:varriableValues]);
        } else if([operation isEqualToString:@"sin"]){
            result = sin([self popOperandOffProgramStack:stack usingVariableValues:varriableValues]);
        } else if([operation isEqualToString:@"cos"]){
            result = cos([self popOperandOffProgramStack:stack usingVariableValues:varriableValues]);
        }
    }
    
    return result;
}



- (double)performOperation:(NSString *)operation usingVariables:(NSDictionary*)
variableValues
{
    [self.programStack addObject:operation];
    return [[self class] runProgram:self.program usingVariableValues:variableValues];
}

/* get the varaibles used in program */
+(NSSet *)variablesUsedInProgram:(id)program{
    NSMutableSet* set = [[NSMutableSet alloc] init];
    for(id object in program){
        if([object isKindOfClass:[NSString class]]){
            if([@"abc" rangeOfString:object].location!=NSNotFound && ![set containsObject:object]){
                [set addObject:object];
            }
        }
    }
    return set.mutableCopy;    
}

/* undo the lastest action */
-(void)undo{
    if([[self programStack] count])
        [[self programStack] removeLastObject];
}


+ (double)runProgram:(id)program usingVariableValues:(NSDictionary *)variableValues
{
    NSMutableArray *stack;
    //NSLog(@"RunProgram1");
    [self testStack:program];                     
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }    
    //NSLog(@"RunProgram2");
    [self testStack:program];
  /*  for(int i=0;i<stack.count;i++){
        if([[stack objectAtIndex:i] isKindOfClass:[NSString class]]){
            if([@"abc" rangeOfString: [stack objectAtIndex:i]].location != NSNotFound){
                NSNumber* number = [variableValues objectForKey:[stack objectAtIndex:i]];
                if(!number) [stack replaceObjectAtIndex:i withObject:number];
                else [stack replaceObjectAtIndex:i withObject:[NSNumber numberWithDouble:0]];
            }
        }
    } */
    return [self popOperandOffProgramStack:stack usingVariableValues:variableValues];
}
@end
