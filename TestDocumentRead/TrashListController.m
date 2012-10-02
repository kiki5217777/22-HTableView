//
//  TrashListController.m
//  TestDocumentRead
//
//  Created by Mac06 on 12/9/26.
//
//

#import "TrashListController.h"
#define kCellID @"cellID"

@interface TrashListController ()
{

}

@end

@implementation TrashListController
@synthesize listData;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        readFile = [[FileOps alloc] init];
        listData = [[readFile getTrashFileList] mutableCopy];
        printf("trash collection veiw init");
        
        _deleteAble = NO;
        _backeAble = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    printf("trash collection veiw load");

    listData = [[readFile getTrashFileList] mutableCopy];

	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [listData count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    // we're going to use a custom UICollectionViewCell, which will hold an image and its label
    //
    TrashCell *cell = [cv dequeueReusableCellWithReuseIdentifier:kCellID forIndexPath:indexPath];
    cell.label.text = [listData objectAtIndex:indexPath.row];
    
    return cell;
}

-(void) collectionView:(UICollectionView *)cv didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%d",indexPath.row);
    NSArray *cellArray = [cv visibleCells];
    TrashCell *oneCell = [cellArray objectAtIndex:indexPath.row];
    NSLog(@"%@",oneCell.label.text);
    NSString *fileName = oneCell.label.text;
    
    if (_deleteAble == _backeAble) {
        printf("list look\n");
    }
    else if(_backeAble){
        [readFile moveToWork:fileName];
        [listData removeObjectAtIndex:indexPath.row];
        [oneCell removeFromSuperview];
    }
    else if(_deleteAble){
        printf("list delete\n");
        [readFile deleteFileWithName:fileName];
        [listData removeObjectAtIndex:indexPath.row];
        [oneCell removeFromSuperview];
    }
}

@end
