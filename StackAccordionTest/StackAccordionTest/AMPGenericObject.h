//
//  AMPGenericObject.h
//  AccordionTest
//
//  Created by anoopm on 02/09/14.
//  Copyright (c) 2014 Anoop M. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    
    OBJECT_TYPE_REGION =0,
    OBJECT_TYPE_LOCATION,
    OBJECT_TYPE_USERS
    
    
} ObjectType;

@interface AMPGenericObject : NSObject
{
}
@property(nonatomic,strong) NSString *name;
@property(nonatomic,strong) NSString *parent;
@property(nonatomic) BOOL canBeExpanded;
@property(nonatomic) BOOL isExpanded;
@property(nonatomic) NSInteger level;
@property(nonatomic) int type;
@property(nonatomic, strong) NSMutableArray *children;
@end
