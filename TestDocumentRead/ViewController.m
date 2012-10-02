//
//  ViewController.m
//  TestDocumentRead
//
//  Created by gdlab on 12/7/17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#define PORTRAIT_WIDTH				768
#define LANDSCAPE_HEIGHT			(1024-20)
#define HORIZONTAL_TABLEVIEW_HEIGHT	140
#define VERTICAL_TABLEVIEW_WIDTH	180
#define NUM_OF_CELLS			10
#define TABLE_BACKGROUND_COLOR		[UIColor clearColor]

@interface ViewController ()

@end

@implementation ViewController
@synthesize nowFileName;
@synthesize nowTime;
@synthesize totalNum;
@synthesize undoNum;
@synthesize doneNum;
@synthesize writeSomethigView;
@synthesize fileListTable;
@synthesize menuTable;
@synthesize horizontal;

- (void)viewDidLoad
{
    //初始化檔案管理
    readFile = [[FileOps alloc] init];
    
    //指定表格的控制方法
    if (fileListController == nil) {
		fileListController = [[FileListController alloc] init];
        fileListController.mainViewId = self;
	}
    if (menuController == nil) {
        menuController = [[MenuContentController alloc] init];
    }

    //[fileListTable setDelegate:fileListController];
	//[fileListTable setDataSource:fileListController];
    
    [menuTable setDelegate:menuController];
    [menuTable setDataSource:menuController];
    
    //設定下方滑動菜單列表
    [self setupHorizontalView];
    //接受訊息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showFileContentWithName:) name:@"show content" object:fileListController];
    
    //手勢辨識 down 關閉菜單 right開啓下一個
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    [swipe setDirection:UISwipeGestureRecognizerDirectionRight];
    [swipe setNumberOfTouchesRequired:1];
    [self.view addGestureRecognizer:swipe];
    
    swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    [swipe setDirection:UISwipeGestureRecognizerDirectionDown];
    [swipe setNumberOfTouchesRequired:1];
    [self.menuTable addGestureRecognizer:swipe];
    
    for (UIGestureRecognizer* gesture in menuTable.gestureRecognizers) {
        if ([gesture isKindOfClass:[UIPanGestureRecognizer class]] || [gesture isKindOfClass:[UITapGestureRecognizer class]]) {
            [gesture requireGestureRecognizerToFail:swipe];
        }
    }
    
    swipe = nil;
    
    //時間顯示
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(showDateTime) userInfo:nil repeats:YES];
    [self showDateTime];

    //顯示列表
    [self showFileList];
    
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    fileListController = nil;
    readFile = nil;
    [self setNowFileName:nil];
    [self setNowTime:nil];
    [self setTotalNum:nil];
    [self setUndoNum:nil];
    [self setDoneNum:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}
//是否自動旋轉
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationPortrait;
}
//下方滑動菜單列表初始化
- (void)setupHorizontalView{
	CGRect frameRect	= CGRectMake(0, LANDSCAPE_HEIGHT - HORIZONTAL_TABLEVIEW_HEIGHT, PORTRAIT_WIDTH, HORIZONTAL_TABLEVIEW_HEIGHT);
	EasyTableView *view	= [[EasyTableView alloc] initWithFrame:frameRect numberOfColumns:NUM_OF_CELLS ofWidth:VERTICAL_TABLEVIEW_WIDTH];
    
	self.horizontal = view;
    horizontal.delegate						= fileListController;
	horizontal.tableView.backgroundColor	= TABLE_BACKGROUND_COLOR;
	horizontal.tableView.allowsSelection	= YES;
	horizontal.tableView.separatorColor		= [UIColor darkGrayColor];
	horizontal.cellBackgroundColor			= [UIColor darkGrayColor];
	horizontal.autoresizingMask				= UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
	horizontal.tableView.separatorColor     = [UIColor clearColor];
	[self.view addSubview:horizontal];
    
}
////////////////////////////////////////////////////////////
# pragma mark 按鈕動作
////////////////////////////////////////////////////////////
- (IBAction)saveChoice:(id)sender {
    //NSLog(@"%@",[[readFile getWorkFileList] description]);
    [self menuDone];
}
//新建一個檔案，將資料寫入
- (IBAction)saveNewFile:(id)sender {
    FileOps *files = [[FileOps alloc]init];
    [files WriteToNewFile:[self.writeSomethigView.text mutableCopy]];
    [files stringToimage:[self.writeSomethigView.text mutableCopy]];
    [files WriteToImageFile];
    [self showFileList];
}
//新建一個檔案，修改現有檔案內容
- (IBAction)saveFile:(id)sender {
    //FileOps *files = [[FileOps alloc]init];
    [self setMenuContent:[self.writeSomethigView.text mutableCopy]];
    
    if ([menuController.listData count] != [menuController.selectedArray count]) {
        [menuController populateSelectedArray];
    }
    
    NSMutableString *stringToWrite = [[self getRealContent:self.writeSomethigView.text] mutableCopy];
    [stringToWrite appendFormat:@"%@%@", SPLITSTRING, [menuController.selectedArray componentsJoinedByString:@"\n"]];
    NSLog(@"-----save File choiceToWrite-----\n%@", [menuController.selectedArray componentsJoinedByString:@"\n"]);
    NSLog(@"-----save File stringToWrite-----\n%@", stringToWrite);
    
    writeSomethigView.text = [self getRealContent:stringToWrite];
    [readFile WriteToStringFile:stringToWrite];
    [readFile stringToimage:[writeSomethigView.text mutableCopy]];//turn string into image
    [readFile WriteToImageFile];//save image
    //顯示列表
    [self showFileList];
    stringToWrite = nil;
}
//紀錄selected 選項
-(void) saveMenuChoice
{
    NSMutableString *stringToWrite = [[self getRealContent:[readFile readFromFile]] mutableCopy];
    [stringToWrite appendFormat:@"%@%@", SPLITSTRING, [menuController.selectedArray componentsJoinedByString:@"\n"]];
    
    NSLog(@"-----save Choice choiceToWrite-----\n%@", [menuController.selectedArray componentsJoinedByString:@"\n"]);
    NSLog(@"-----save Choice stringToWrite-----\n%@", stringToWrite);
    
    [readFile WriteToStringFile:stringToWrite];
    [self setMenuContent:[self getRealContent:stringToWrite]];
    stringToWrite = nil;
}

////////////////////////////////////////////////////////////
# pragma mark 時間顯示
////////////////////////////////////////////////////////////
-(void)showDateTime{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateFormat:@"MM-dd HH:mm:ss"];
    //dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss.SSSSSS";
    //NSLog(@"Date%@", [dateFormatter stringFromDate:[NSDate date]]);
    [nowTime setText:[dateFormatter stringFromDate:[NSDate date]]];
}

////////////////////////////////////////////////////////////
# pragma mark menuTable手勢控制
////////////////////////////////////////////////////////////
- (void)handleSwipe:(UISwipeGestureRecognizer *)recognizer {
    if (recognizer.direction == UISwipeGestureRecognizerDirectionDown) {
        //NSLog(@"down");
        //down 關閉菜單
        [self menuDone];
    }
    else if (recognizer.direction == UISwipeGestureRecognizerDirectionRight)
    {
        //right開啓下一個
        //NSLog(@"right");
        [self menuNext];
    }
}
////////////////////////////////////////////////////////////
# pragma mark list 點擊之後處理動作 將檔案打開顯示在menuTable上
////////////////////////////////////////////////////////////

- (void) showFileContentWithName:(NSNotification *)note {
    //NSLog(@"NOTIFICATION: %s\n", [[note name] UTF8String]);
    //當之前有開啓檔案的時候..要先儲存選擇情況在打開新的檔案
    if (readFile.fileOpened)
    {
        //[readFile WriteToStringFile:[self.writeSomethigView.text mutableCopy]];
        [self saveMenuChoice];
    }
    //取出通知中的資料
    NSDictionary *theData = [note userInfo];
    if (theData != nil) {
        NSString *n = [theData objectForKey:@"fileName"];
        NSString *txtFileContent = [readFile readFromFileWithName:n];
        //NSLog(@"-----txtFileContent-----\n%@", txtFileContent);
        
        [writeSomethigView setText:[self getRealContent:txtFileContent]];
        [self setMenuContent:[self getRealContent:txtFileContent]];
        [menuController populateSelectedArray];
        
        NSMutableArray *choice = [self getSelectedRows:txtFileContent];
        [menuController setSelectedArray:choice];
        //NSLog(@"-----choice-----\n%@", choice);
        
        [fileListTable reloadData];
        //[horizontal reloadData];
        nowFileName.text = n;
        //NSLog(@"%@",[[self getSelectedRows:txtFileContent] description]);
    }
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

//顯示menu內容於list view
-(void) setMenuContent:(NSString*) content{
    
    content = [self getRealContent:content];
    NSLog(@"-----content-----\n%@", content);
    NSArray *arrayFileContent = [content componentsSeparatedByString:@"\n"];
    NSMutableArray *mArrayData = [[NSMutableArray alloc] initWithArray:arrayFileContent];
    
    [menuController setListData:mArrayData];
    NSLog(@"-----listData-----\n%@", mArrayData);
    
    //[menuController setSelectedArray:choice];
    [menuTable reloadData];
}

//設定檔案列表內容
-(void) setFileListTableContent:(NSMutableArray*) content{
    [fileListController setListData:content];
    //[fileListTable reloadData];
    [horizontal reloadData];
}

////////////////////////////////////////////////////////////
# pragma mark 檔案顯示設定
////////////////////////////////////////////////////////////
-(void) menuDone
{
    [readFile moveToTrash:nowFileName.text];
    [self showFileList];
    [readFile setFileOpened:nil];
    [nowFileName setText:nil];
    [menuController setListData:nil];
    [menuTable reloadData];
}

-(void) menuNext
{
    NSString *name = [readFile getNextFileName];
    NSLog(@"file name %@",name);
    if (name) {
        NSString *txtFileContent = [readFile readFromFileWithName:name];
        //NSLog(@"-----txtFileContent-----\n%@", txtFileContent);
        
        [writeSomethigView setText:[self getRealContent:txtFileContent]];
        [self setMenuContent:[self getRealContent:txtFileContent]];
        [menuController populateSelectedArray];
        
        NSMutableArray *choice = [self getSelectedRows:txtFileContent];
        [menuController setSelectedArray:choice];
        //NSLog(@"-----choice-----\n%@", choice);
        
        [fileListTable reloadData];
        //[horizontal reloadData];
        nowFileName.text = name;
    }
}

//顯示檔案列表，更新檔案列表
- (void) showFileList
{
    int work = [readFile numOfWorkFiles];
    int trash = [readFile numOfTrashFiles];
    
    [self.totalNum setText:[NSString stringWithFormat:@"%d",work+trash]];
    [self.undoNum setText:[NSString stringWithFormat:@"%d",work]];
    [self.doneNum setText:[NSString stringWithFormat:@"%d",trash]];
    [self setFileListTableContent:[NSMutableArray arrayWithArray:[readFile getWorkFileList]]];
     NSLog(@"%@",[[readFile getWorkFileList] description]);
     
}

@end
