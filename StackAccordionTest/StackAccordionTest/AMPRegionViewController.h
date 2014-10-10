//
//  AMPRegionViewController.h
//  AccordionTest
//
//  Created by anoopm on 02/09/14.
//  Copyright (c) 2014 Anoop M. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AMPRegionViewController : UITableViewController
{
    NSMutableArray *dataArray;
    NSMutableArray *childArray;
    NSArray *filteredChildArray;
    NSInteger indentationlevel;
    CGFloat indendationWidth;
}
@end
