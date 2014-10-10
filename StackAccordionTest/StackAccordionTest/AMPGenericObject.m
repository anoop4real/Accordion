//
//  AMPGenericObject.m
//  AccordionTest
//
//  Created by anoopm on 02/09/14.
//  Copyright (c) 2014 Anoop M. All rights reserved.
//

#import "AMPGenericObject.h"

@implementation AMPGenericObject

-(NSMutableArray*)children
{
    if (!_children) {
        _children = [[NSMutableArray alloc] init];
    }
    return _children;
}
@end
