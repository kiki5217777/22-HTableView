//
//  FileList.m
//  TestDocumentRead
//
//  Created by gdlab on 12/7/29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "FileListController.h"
#define SHOW_MULTIPLE_SECTIONS		1		// If commented out, multiple sections with header and footer views are not shown

#define PORTRAIT_WIDTH				768
#define LANDSCAPE_HEIGHT			(1024-20)
#define HORIZONTAL_TABLEVIEW_HEIGHT	140
#define VERTICAL_TABLEVIEW_WIDTH	180
#define TABLE_BACKGROUND_COLOR		[UIColor clearColor]

#define BORDER_VIEW_TAG				10
#define IMAGE_TAG					101
#define LABEL_TAG					100

#ifdef SHOW_MULTIPLE_SECTIONS
#define NUM_OF_CELLS			10
#define NUM_OF_SECTIONS			1
#else
#define NUM_OF_CELLS			21
#endif
@interface FileListController ()

@end

@implementation FileListController
@synthesize listData,horizontalView,imageList;
@synthesize mainViewId;
/*
-(void) setMainView:(id) main{
    self->mainView = main;
}
*/
-(void) loadView
{
	if (listData == nil) {
		//listData = [NSMutableArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"6",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",nil];
	}
}


- (void)viewDidUnload
{
    self.listData = nil;
    self.mainViewId = nil;
}


#pragma mark -
#pragma mark Optional EasyTableView delegate methods for section headers and footers

#ifdef SHOW_MULTIPLE_SECTIONS

// Delivers the number of sections in the TableView
- (NSUInteger)numberOfSectionsInEasyTableView:(EasyTableView*)easyTableView{
    return 1;
}

// Delivers the number of cells in each section, this must be implemented if numberOfSectionsInEasyTableView is implemented
-(NSUInteger)numberOfCellsForEasyTableView:(EasyTableView *)view inSection:(NSInteger)section {
    return [listData count];
    //return 1;
}
#endif
#pragma mark -
#pragma mark EasyTableViewDelegate

// These delegate methods support both example views - first delegate method creates the necessary views

- (UIView *)easyTableView:(EasyTableView *)easyTableView viewForRect:(CGRect)rect {
	UIView *container = [[UIView alloc] initWithFrame:rect];
    UIImageView *imageView =[[UIImageView alloc]initWithFrame:CGRectMake(1, 0, rect.size.width-2, rect.size.height)];
    imageView.tag = IMAGE_TAG;
    //imageView.backgroundColor =[[UIColor redColor] colorWithAlphaComponent:0.3];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [container addSubview:imageView];
    
    CGRect labelRect		= CGRectMake(10, rect.size.width-100,rect.size.height-20 , 50);
	UILabel *label			= [[UILabel alloc] initWithFrame:labelRect];
	[label setTextAlignment:NSTextAlignmentCenter];
	label.textColor			= [UIColor whiteColor];
	label.font				= [UIFont boldSystemFontOfSize:60];
	label.tag=LABEL_TAG;
	// Use a different color for the two different examples
    
	if (easyTableView == horizontalView)
		label.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.3];
	else
		label.backgroundColor = [[UIColor orangeColor] colorWithAlphaComponent:0.3];
	
    //選取動畫
	//UIImageView *borderView		= [[UIImageView alloc] initWithFrame:label.bounds];
    
	//borderView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
	//borderView.tag				= BORDER_VIEW_TAG;
	
	//[label addSubview:borderView];
    [container addSubview:label];
    
	return container;
}
#pragma mark -
#pragma mark Utility Methods

- (void)borderIsSelected:(BOOL)selected forView:(UIView *)view {
	UIImageView *borderView		= (UIImageView *)[view viewWithTag:BORDER_VIEW_TAG];
	NSString *borderImageName	= (selected) ? @"selected_border.png" : @"image_border.png";
	borderView.image			= [UIImage imageNamed:borderImageName];
}

// Second delegate populates the views with data from a data source
- (void)easyTableView:(EasyTableView *)easyTableView setDataForView:(UIView *)view forIndexPath:(NSIndexPath *)indexPath {
    
    readimage = [[FileOps alloc] init];
    
    UILabel *label	= (UILabel *)[view viewWithTag:LABEL_TAG];
	label.text		= [NSString stringWithFormat:@"%@", [listData objectAtIndex:indexPath.row]];
    label.backgroundColor = [UIColor clearColor];
    label.adjustsFontSizeToFitWidth=YES;
	
    UIImageView *imageView =(UIImageView *)[view viewWithTag:IMAGE_TAG];
    //UIImage *image =[readimage ReadFromImageFileWithName:indexPath.row];
    UIImage *image = [readimage loadImageWithName:label.text];
    imageView.image = image;
    imageView.frame = CGRectMake(50, 10, 160, 230);
    
	// selectedIndexPath can be nil so we need to test for that condition
	BOOL isSelected = (easyTableView.selectedIndexPath) ? ([easyTableView.selectedIndexPath compare:indexPath] == NSOrderedSame) : NO;
	[self borderIsSelected:isSelected forView:view];
}

// Optional delegate to track the selection of a particular cell
- (void)easyTableView:(EasyTableView *)easyTableView selectedView:(UIView *)selectedView atIndexPath:(NSIndexPath *)indexPath deselectedView:(UIView *)deselectedView {
	[self borderIsSelected:YES forView:selectedView];
	
	if (deselectedView)
		[self borderIsSelected:NO forView:deselectedView];
	
	//UILabel *label	= (UILabel *)selectedView;
	//bigLabel.text	= label.text;
    NSUInteger row = [indexPath row];
    //傳送訊息
    NSDictionary *dataDict = [NSDictionary dictionaryWithObject:[listData objectAtIndex:row]
                                                         forKey:@"fileName"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"show content" object:self userInfo:dataDict];
}
 
@end
