//
//  ViewController.h
//  TestDocumentRead
//
//  Created by gdlab on 12/7/17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/NSNotification.h>
#import "FileOps.h"
#import "FileListController.h"
#import "MenuContentController.h"
#import "EasyTableView.h"


@interface ViewController : UIViewController
<UIGestureRecognizerDelegate> 
{
    FileListController *fileListController;
    MenuContentController *menuController;
    FileOps *readFile;
    EasyTableView *horiznotal;
}

@property (weak, nonatomic) IBOutlet UITextView *writeSomethigView;
@property (nonatomic, retain) IBOutlet UITableView *fileListTable;
@property (nonatomic, retain) IBOutlet UITableView *menuTable;
@property (weak, nonatomic) IBOutlet UILabel *nowFileName;
@property (weak, nonatomic) IBOutlet UILabel *nowTime;
@property (weak, nonatomic) IBOutlet UILabel *totalNum;
@property (weak, nonatomic) IBOutlet UILabel *undoNum;
@property (weak, nonatomic) IBOutlet UILabel *doneNum;
@property (nonatomic) EasyTableView *horizontal;

- (IBAction)saveFile:(id)sender;
- (IBAction)saveChoice:(id)sender;
- (IBAction)saveNewFile:(id)sender;

- (void) showFileList;
- (void) showFileContentWithName:(NSString *)filename;
-(void) setMenuContent:(NSString*) content;
-(void) setFileListTableContent:(NSMutableArray*) content;
-(NSString*) getRealContent:(NSString*)content;

@end
