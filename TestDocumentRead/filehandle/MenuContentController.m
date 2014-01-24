//
//  MenuContenController.m
//  TestDocumentRead
//
//  Created by  on 2012/8/15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MenuContentController.h"
#define COLOR_SECLETED  RGBA( 0, 0, 50, 0.2)
#define COLOR_UNSECLETED  RGBA(0, 0, 0, 1)
#define TIME_LABEL_TAG 2

@implementation MenuContentController
@synthesize listData, selectedArray;
//@synthesize selectedImage, unselectedImage;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        //listData = [NSMutableArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"6",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",nil];
    }
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [self setSelectedArray:Nil];
    [self setListData:Nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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
    return [listData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    printf("\n set cells");
    static NSString *CellIdentifier = @"menuCell";
    
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    menuCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        
        cell = [[menuCell alloc] init];
        //UINib *nib = [UINib nibWithNibName:@"CustomCell" bundle:nil];
        //[tableView registerNib:nib forCellReuseIdentifier:CellIdentifier];
        //cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        //cell = [[menuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        /*
        UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(380, 0, 90, 20)];
        [timeLabel setTextAlignment:NSTextAlignmentRight];
        timeLabel.font = [UIFont fontWithName:@"Courier" size:15];
        timeLabel.backgroundColor = [UIColor clearColor];
        [timeLabel setTag:TIME_LABEL_TAG];
        [cell.contentView addSubview:timeLabel];
        timeLabel = nil;
        */
        [cell.textLabel setFont:[UIFont fontWithName:@"Courier" size:18]];
        [cell.textLabel setBackgroundColor:[UIColor clearColor]];
    }
    //設定cell type

    NSString *temp = (NSString*)[selectedArray objectAtIndex:[indexPath row]];
    NSLog(@"selected array:%d",temp.intValue);

    //NSLog(@"selected array:%@",[selectedArray description]);
    
    if (temp.intValue) {
        //cell.accessoryType = UITableViewCellAccessoryNone;
        
        //UILabel *timeLabel = (UILabel*) [cell viewWithTag:TIME_LABEL_TAG];
        //timeLabel.text = Nil;
        [cell.textLabel setTextColor:COLOR_SECLETED];
        //UILabel *timeLabel = (UILabel*) [cell viewWithTag:TIME_LABEL_TAG];
        //timeLabel.text = [selectedArray objectAtIndex:[indexPath row]];
        cell.timeLabel.text = [selectedArray objectAtIndex:indexPath.row];
    }
    else
    {
        //cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [cell.textLabel setTextColor:COLOR_UNSECLETED];
        cell.timeLabel.text = Nil;
        //cell.timeLabel.text = [selectedArray objectAtIndex:[indexPath row]];
        
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@" ,[listData objectAtIndex:indexPath.row]];
    return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
    //return UITableViewCellEditingStyleDelete;
}

#pragma mark - Table view delegate
#pragma mark 選取後的處理動作
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    menuCell *oneCell = (menuCell*)[tableView cellForRowAtIndexPath:indexPath];
    
    NSString *temp = (NSString*)[selectedArray objectAtIndex:[indexPath row]];
    //NSLog(@"selected array:%d",temp.intValue);
    //if (oneCell.accessoryType == UITableViewCellAccessoryNone)
    if(temp.intValue)
    {
        //oneCell.accessoryType = UITableViewCellAccessoryNone;
        [selectedArray replaceObjectAtIndex:[indexPath row] withObject:[NSNumber numberWithBool:NO]];
        //NSLog(@"----selectedArray-----\n%@",[selectedArray description]);
        [oneCell.textLabel setTextColor:COLOR_UNSECLETED];
        /*
        UILabel *timeLabel = (UILabel*) [oneCell viewWithTag:TIME_LABEL_TAG];
        timeLabel.text = nil;
        timeLabel = Nil;
         */
        oneCell.timeLabel.text = nil;
    }
    else  
    {
        //oneCell.accessoryType = UITableViewCellAccessoryCheckmark;
        //NSLog(@"----selectedArray-----\n%@",[selectedArray description]);
        [oneCell.textLabel setTextColor:COLOR_SECLETED];
        
        UILabel *timeLabel = (UILabel*) [oneCell viewWithTag:TIME_LABEL_TAG];
        timeLabel.text = [self getTime];
        [selectedArray replaceObjectAtIndex:[indexPath row] withObject:timeLabel.text];
        timeLabel = Nil;
        
    }
    //NSLog(@"---------selected array-------\n%@",self.selectedArray);
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    //return UITableViewCellEditingStyleDelete;
    return NO;
}

-(NSString*) getTime
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateFormat:@"HH:mm:ss"];
    return [dateFormatter stringFromDate:[NSDate date]];
}

- (void)populateSelectedArray
{
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:[listData count]];
    for (int i=0; i < [listData count]; i++)
        [array addObject:[NSNumber numberWithBool:NO]];
    self.selectedArray = array;
    array = nil;
}



@end
