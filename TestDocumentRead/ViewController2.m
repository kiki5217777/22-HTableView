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
@synthesize done;

- (void)viewDidLoad
{
    NSLog(@"test---%d",done);
    [super viewDidLoad];
    
    if (trashListController == nil)
    {
        trashListController = [[TrashListController alloc] init];
        readFile = [[FileOps alloc] init];
    }
    [trashList setDataSource:trashListController];
    [trashList setDelegate:trashListController];
    //trashListController.collectionView = trashList;
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    [self.trashList addGestureRecognizer:longPress];
    
    /*
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
     */
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
/*
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
*/

-(void)handleLongPress:(UILongPressGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateBegan) {
        
        CGPoint touchLocation = [gesture locationInView:gesture.view];
        NSIndexPath *indexPath = [self.trashList indexPathForItemAtPoint:touchLocation];
        
        selectFile = [trashListController.listData objectAtIndex:indexPath.row];
        [self showDetail:selectFile]; //點擊的檔案名稱
    }
}

-(void) showDetail:(NSString*)sName
{
    
    //初始化AlertView
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:sName
                                                   message:nil
                                                  delegate:self
                                         cancelButtonTitle:@"取消"
                                         otherButtonTitles:@"叫回",nil];
    
    //这个属性继承自UIView，当一个视图中有多个AlertView时，可以用这个属性来区分
    alert.tag = 0;
    
    //只读属性，看AlertView是否可见
    NSLog(@"alert2:%d",alert.visible);
    
    //通过给定标题添加按钮
    [alert addButtonWithTitle:@"刪除"];
    
    //显示AlertView
    [alert show];
    alert = Nil;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSLog(@"单击第:%d",buttonIndex);
    switch (buttonIndex) {
        case 1:
            NSLog(@"叫回");
            [readFile moveToWork:selectFile];
            [trashListController.listData removeObject:selectFile];
            [trashList reloadData];
            break;
        case 2:
            NSLog(@"刪除");
            [readFile deleteFileWithName:selectFile];
            [trashListController.listData removeObject:selectFile];
            [trashList reloadData];
            break;
        default:
            break;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [[self.trashList indexPathsForSelectedItems] objectAtIndex:0];
        DetailViewController *destViewController = segue.destinationViewController;
        destViewController.recptName = [trashListController.listData objectAtIndex:indexPath.row];
        selectFile = [trashListController.listData objectAtIndex:indexPath.row];
    }
}

- (IBAction)backToTrash:(UIStoryboardSegue*)segue
{
    NSLog(@"fileName: %@", selectFile);
    NSLog(@"segueName: %@", segue.identifier);
    if ([segue.identifier isEqualToString:@"CallBack"]) {
        NSLog(@"backToTrash CallBack");
        [readFile moveToWork:selectFile];
        [trashListController.listData removeObject:selectFile];
        [trashList reloadData];
    }
    else if ([segue.identifier isEqualToString:@"Delete"])
    {
        NSLog(@"backToTrash Delete");
        [readFile deleteFileWithName:selectFile];
        [trashListController.listData removeObject:selectFile];
        [trashList reloadData];
    }
}
@end
