//
//  AMPRegionViewController.m
//  AccordionTest
//
//  Created by anoopm on 02/09/14.
//  Copyright (c) 2014 Anoop M. All rights reserved.
//

#import "AMPRegionViewController.h"
#import "AMPGenericObject.h"

@interface AMPRegionViewController ()

@end

@implementation AMPRegionViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    dataArray = [[NSMutableArray alloc] init];
    //childArray = [[NSMutableArray alloc] init];
    //filteredChildArray = [[NSArray alloc] init];
    indentationlevel = 0;
    indendationWidth = 20;
    // Create a sample array of parent objects
    for(int i=0;i<10;i++)
    {
        AMPGenericObject *prod = [[AMPGenericObject alloc] init];
        prod.name = [NSString stringWithFormat:@"Region%d",i];
        prod.parent = @"";
        prod.isExpanded = NO;
        prod.level = 0;
        prod.type  = OBJECT_TYPE_REGION;
        // Randomly assign canBeExpanded status
        if(i%2)
        {
            prod.canBeExpanded  = YES;
        }
        else
        {
            prod.canBeExpanded = NO;
        }
        [dataArray addObject:prod];
    }
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    AMPGenericObject *prod = [dataArray objectAtIndex:indexPath.row];
    cell.textLabel.text = prod.name;
    cell.detailTextLabel.text = prod.parent;
    cell.indentationLevel = prod.level;
    cell.indentationWidth = indendationWidth;
    // Show disclosure only if the cell can expand
    if(prod.canBeExpanded)
    {
        cell.accessoryView = [self viewForDisclosureForState:prod.isExpanded];
    }
    else
    {
        //cell.accessoryType = UITableViewCellAccessoryNone;
        cell.accessoryView = nil;
    }
    // Configure the cell...
    
    return cell;
}
-(UIView*) viewForDisclosureForState:(BOOL) isExpanded
{
    NSString *imageName;
    if(isExpanded)
    {
        imageName = @"ArrowD_blue.png";
    }
    else
    {
        imageName = @"ArrowR_blue.png";
    }
    UIView *myView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    [imgView setFrame:CGRectMake(0, 6, 24, 24)];
    [myView addSubview:imgView];
    return myView;
}
// Utility class to create childrens for a selected parent class
-(void) fetchChildrenforParent:(AMPGenericObject*) parentProduct
{
    // If canBeExpanded then only we need to create child
    if(parentProduct.canBeExpanded)
    {
        // If Children are already added then no need to add again
        if([parentProduct.children count]>0)
            return;
        // The children property of the parent will be filled with this objects
        // If the parent is of type region, then fetch the location.
        if (parentProduct.type == OBJECT_TYPE_REGION) {
            for(int i=0;i<10;i++)
            {
                AMPGenericObject *prod = [[AMPGenericObject alloc] init];
                prod.name = [NSString stringWithFormat:@"Location %d",i];
                prod.level  = parentProduct.level +1;
                //prod.parent = [NSString stringWithFormat:@"Child %d of Level %d",i,prod.level];
                // This is used for setting the indentation level so that it look like an accordion view
                prod.type = OBJECT_TYPE_LOCATION;
                prod.isExpanded = NO;
                
                if(i%2)
                {
                    prod.canBeExpanded = YES;
                }
                else
                {
                    prod.canBeExpanded = NO;
                }
                [parentProduct.children addObject:prod];
            }
        }
        // If tapping on Location, fetch the users
        else{
            
            for(int i=0;i<10;i++)
            {
                AMPGenericObject *prod = [[AMPGenericObject alloc] init];
                prod.name = [NSString stringWithFormat:@"User %d",i];
                prod.level  = parentProduct.level +1;
                //prod.parent = [NSString stringWithFormat:@"Child %d of Level %d",i,prod.level];
                // This is used for setting the indentation level so that it look like an accordion view
                prod.type = OBJECT_TYPE_LOCATION;
                prod.isExpanded = NO;
                // Users need not expand
                prod.canBeExpanded = NO;
//                if(i%2)
//                {
//                    prod.canBeExpanded = YES;
//                }
//                else
//                {
//                    prod.canBeExpanded = NO;
//                }
                [parentProduct.children addObject:prod];
            }
        }

    }
}


#pragma mark - Table view delegate
// Method to collapse the cell if it is already expanded
- (void)collapseCellsFromIndexOf:(AMPGenericObject *)prod indexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView
{
    // Find the number of childrens opened under the parent recursively as there can be expanded children also
    int collapseCol = [self numberOfCellsToBeCollapsed:prod];
    
    // Find the range from the parent index and the length to be removed.
    NSRange collapseRange = NSMakeRange(indexPath.row+1, collapseCol);
    // Remove all the objects in that range from the main array so that number of rows are maintained properly
    [dataArray removeObjectsInRange:collapseRange];
    prod.isExpanded = NO;
    // Create index paths for the number of rows to be removed
    NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
    for (int i = 0; i<collapseRange.length; i++) {
        [indexPaths addObject:[NSIndexPath indexPathForRow:collapseRange.location+i inSection:0]];
    }
    // Animate and delete
    [tableView deleteRowsAtIndexPaths:indexPaths
                     withRowAnimation:UITableViewRowAnimationLeft];
}

// Method to collapse the cell if it is already expanded
- (void)expandCellsFromIndexOf:(AMPGenericObject *)prod tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
{
    // Create dummy children
    [self fetchChildrenforParent:prod];
    // Expand only if children are available
    if([prod.children count]>0)
    {
        prod.isExpanded = YES;
        int i =0;
        // Insert all the child to the main array just after the parent
        for (AMPGenericObject *prod1 in prod.children) {
            [dataArray insertObject:prod1 atIndex:indexPath.row+i+1];
            i++;
        }
        // Find the range for insertion
        NSRange expandedRange = NSMakeRange(indexPath.row, i);
        NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
        // Create index paths for the range
        for (int i = 0; i<expandedRange.length; i++) {
            [indexPaths addObject:[NSIndexPath indexPathForRow:expandedRange.location+i+1 inSection:0]];
        }
        // Insert the rows
        [tableView insertRowsAtIndexPaths:indexPaths
                         withRowAnimation:UITableViewRowAnimationLeft];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AMPGenericObject *prod = [dataArray objectAtIndex:indexPath.row];
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    if(prod.canBeExpanded)
    {
        
        if(prod.isExpanded)
        {
            
            [self collapseCellsFromIndexOf:prod indexPath:indexPath tableView:tableView];
            selectedCell.accessoryView = [self viewForDisclosureForState:NO];
        }
        else{
            NSLog(@"Can be expanded");
            [self expandCellsFromIndexOf:prod tableView:tableView indexPath:indexPath];
            
            selectedCell.accessoryView = [self viewForDisclosureForState:YES];
            
        }
        
    }
    
}

// Find the number of cells to be collapsed
-(int) numberOfCellsToBeCollapsed:(AMPGenericObject*) products
{
    int total = 0;
    if(products.isExpanded)
    {
        // Set the expanded status to no
        products.isExpanded = NO;
        NSMutableArray *child = products.children;
        total = child.count;
        // traverse through all the children of the parent and get the count.
        for(AMPGenericObject *prod in child)
        {
            total += [self numberOfCellsToBeCollapsed:prod];
        }
    }
    return total;
}
@end
