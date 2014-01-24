//
//  DetailViewController.h
//  TestDocumentRead
//
//  Created by Mac06 on 12/10/2.
//
//

#import <UIKit/UIKit.h>
#import "MenuContentController.h"
#import "FileOps.h"

@interface DetailViewController : UIViewController
{
    NSString *recptName;
    MenuContentController *menuController;
    FileOps *fileMng;
}
@property (nonatomic, retain) NSString *recptName;
@property (weak, nonatomic) IBOutlet UITableView *menuTable;
-(IBAction) detailDone:(UIStoryboardSegue*)seque;

-(void) showData;
@end
