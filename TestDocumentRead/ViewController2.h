//
//  ViewController2.h
//  TestDocumentRead
//
//  Created by gdlab on 12/9/12.
//
//

#import <UIKit/UIKit.h>
#import "FileOps.h"
#import "TrashListController.h"

@interface ViewController2 : UIViewController
{
    TrashListController *trashListController;
    FileOps *readFile;
    NSString *selectFile;
    
    int done;
}

@property (weak, nonatomic) IBOutlet UICollectionView *trashList;
@property (nonatomic) int done;
@end
