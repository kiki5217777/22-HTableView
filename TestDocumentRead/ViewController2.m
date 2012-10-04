//
//  ViewController2.m
//  TestDocumentRead
//
//  Created by gdlab on 12/9/12.
//
//

#import "ViewController2.h"
#define BARBUTTON(TITLE, SELECTOR) [[UIBarButtonItem alloc] \
    initWithTitle:TITLE style:UIBarButtonItemStylePlain \
    target:self action:SELECTOR]
#define BAR_HIGHT 44
#define TITLE_LOOK @"檢視"
#define TITLE_BACK @"叫回"
#define TITLE_DELE @"刪除"

@interface ViewController2 ()


@end

@implementation ViewController2
@synthesize trashList;

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    if (trashListController == nil)
    {
        trashListController = [[TrashListController alloc] init];
        readFile = [[FileOps alloc] init];
    }
    [trashList setDataSource:trashListController];
    [trashList setDelegate:trashListController];
    //trashListController.collectionView = trashList;
    
    UIToolbar *tb = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 960, 768, BAR_HIGHT)];
    NSMutableArray *tbItems = [NSMutableArray array];
    
    UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [tbItems addObject:bbi];
    [tbItems addObject:BARBUTTON(TITLE_LOOK, @selector(toolButton:))];
    [tbItems addObject:bbi];
    [tbItems addObject:BARBUTTON(TITLE_BACK, @selector(toolButton:))];
    [tbItems addObject:bbi];
    [tbItems addObject:BARBUTTON(TITLE_DELE, @selector(toolButton:))];
    [tbItems addObject:bbi];
    tb.items = tbItems;
    [self.view addSubview:tb];
    tb = Nil;
}

- (void)viewDidUnload
{
    [self setTrashList:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return UIInterfaceOrientationPortrait;
}

-(void) toolButton:(UIBarButtonItem*) object
{
    //NSLog(@"%@",[object description]);
    //NSLog(@"%@",object.title);
    NSString *name = object.title;
    if (name == TITLE_LOOK) {
        printf("\n LOOK!!!");
        trashListController.deleteAble = NO;
        trashListController.backeAble = NO;
        
        [trashList setBackgroundColor:[UIColor whiteColor]];
    }
    else if (name == TITLE_BACK)
    {
        printf("\n BACK!!!");
        trashListController.deleteAble = NO;
        trashListController.backeAble = YES;
        
        [trashList setBackgroundColor:[UIColor grayColor]];
    }
    else if (name == TITLE_DELE)
    {
        printf("\n DELE!!!");
        trashListController.deleteAble = YES;
        trashListController.backeAble = NO;
        
        [trashList setBackgroundColor:RGBA(100, 0, 50, 0.5)];
    }
}
/*
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showDetail"]) {
        //NSIndexPath *indexPath = [[self.collectionView indexPathsForSelectedItems] objectAtIndex:0];
        DetailViewController *destViewController = segue.destinationViewController;
        //TrashCell *oneCell = [recipes objectAtIndex:indexPath.row];

        destViewController.recptName = trashListController.selectFile;
        NSLog(@"第二頁 %@",trashListController.selectFile);
        [destViewController showData];
        printf("preparSetgue View2");
    }
}
*/
@end
