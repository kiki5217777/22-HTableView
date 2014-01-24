//
//  DetailViewController.m
//  TestDocumentRead
//
//  Created by Mac06 on 12/10/2.
//
//

#import "DetailViewController.h"
#define BARBUTTON(TITLE, SELECTOR) [[UIBarButtonItem alloc] \
initWithTitle:TITLE style:UIBarButtonItemStylePlain \
target:self action:SELECTOR]
#define BAR_HIGHT 44
#define TITLE_BACK @"叫回"
#define TITLE_DELE @"刪除"

#import "ViewController2.h"

@interface DetailViewController ()

@end

@implementation DetailViewController
@synthesize recptName, menuTable;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (id) initWithFileName:(NSString *) name
{
    self = [super init];
    if (self) {
        printf("Detal init");
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (menuController == nil) {
        menuController = [[MenuContentController alloc] init];
    }
    [menuTable setDelegate:menuController];
    [menuTable setDataSource:menuController];
    
    //下方toolbar顯示設定
    /*
    UIToolbar *tb = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 960, 768, BAR_HIGHT)];
    NSMutableArray *tbItems = [NSMutableArray array];
    
    UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [tbItems addObject:bbi];
    [tbItems addObject:BARBUTTON(TITLE_BACK, @selector(toolButton:))];
    [tbItems addObject:bbi];
    [tbItems addObject:BARBUTTON(TITLE_DELE, @selector(toolButton:))];
    [tbItems addObject:bbi];
    tb.items = tbItems;
    [self.view addSubview:tb];
    tb = Nil;
    */
    //初始化檔案管理
    fileMng = [[FileOps alloc] init];
    NSString *txtFileContent = [fileMng readFromTrashWithName:recptName];
    
    [self setMenuContent:[self getRealContent:txtFileContent.mutableCopy]];
    [menuController populateSelectedArray];
    
    NSMutableArray *choice = [self getSelectedRows:txtFileContent];
    [menuController setSelectedArray:choice];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) toolButton:(UIBarButtonItem*) object
{
    //NSLog(@"%@",[object description]);
    //NSLog(@"%@",object.title);
    NSString *name = object.title;
    if (name == TITLE_BACK)
    {
        [fileMng moveToWork:recptName];
        
        
    }
    else if (name == TITLE_DELE)
    {
        [fileMng deleteFileWithName:recptName];
    }
}

//顯示menu內容於list view
-(void) setMenuContent:(NSString*) content{
    
    content = [self getRealContent:content.mutableCopy];
    NSLog(@"-----content-----\n%@", content);
    NSArray *arrayFileContent = [content componentsSeparatedByString:@"\n"];
    NSMutableArray *mArrayData = [[NSMutableArray alloc] initWithArray:arrayFileContent];
    
    [menuController setListData:mArrayData];
    NSLog(@"-----listData-----\n%@", mArrayData);
    
    //[menuController setSelectedArray:choice];
    [menuTable reloadData];
}

//取出真正的菜單內容
-(NSString*) getRealContent:(NSMutableString*)content
{
    NSArray *tempContent = [content componentsSeparatedByString:SPLITSTRING];
    return [tempContent objectAtIndex:0];
}

//取出選擇記錄檔
-(NSMutableArray*) getSelectedRows:(NSString*)content
{
    NSArray *tempContent = [content componentsSeparatedByString:SPLITSTRING];
    if ([tempContent count] > 1) {
        NSMutableArray *tempArray = [[[tempContent objectAtIndex:1] componentsSeparatedByString:@"\n"] mutableCopy];
        return tempArray;
    }
    else
    {
        NSLog(@"讀不到檔案中的choice");
        [menuController populateSelectedArray];
        return menuController.selectedArray;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"detailCallBack"]) {
        [fileMng moveToWork:recptName];
    }
    else if ([segue.identifier isEqualToString:@"detailDelete"]) {
        [fileMng deleteFileWithName:recptName];
    }
}

-(IBAction)detailDone:(UIStoryboardSegue*)seque{
    if ([seque.identifier isEqualToString:@"showDetail"]) {
        //NSIndexPath *indexPath = [[self.trashList indexPathsForSelectedItems] objectAtIndex:0];
        ViewController2 *desView = seque.destinationViewController;
        //DetailViewController *destViewController = segue.destinationViewController;
        desView.done = 100;
    }
}
@end
