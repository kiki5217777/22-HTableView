//
//  TrashListController.h
//  TestDocumentRead
//
//  Created by Mac06 on 12/9/26.
//
//

#import <UIKit/UIKit.h>
#import "TrashCell.h"
#import "FileOps.h"
#import "PopViewController.h"
#import "DetailViewController.h"

@interface TrashListController : UICollectionViewController
{
    NSMutableArray *listData;
    FileOps *readFile;
    UICollectionView *collectionView;
    TrashCell *oneCell;
}

@property (nonatomic, retain) NSMutableArray *listData;
@property (nonatomic, retain) NSString *selectFile;
@property (nonatomic) BOOL deleteAble;
@property (nonatomic) BOOL backeAble;
@end
