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

@end

@implementation TrashListController
@synthesize listData, selectFile, oneCell;

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

    TrashCell *cell = [cv dequeueReusableCellWithReuseIdentifier:kCellID forIndexPath:indexPath];
    cell.label.text = [listData objectAtIndex:indexPath.row];
    
    return cell;
}

-(void) collectionView:(UICollectionView *)cv didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%d",indexPath.row);
    NSArray *cellArray = [cv visibleCells];
    oneCell = [cellArray objectAtIndex:indexPath.row];
    NSLog(@"%@",oneCell.label.text);
    NSString *fileName = oneCell.label.text;
    
    /*
    if (_deleteAble == _backeAble) {
        printf("list look\n");
        selectFile = oneCell.label.text;
        NSLog(@"垃圾桶點到的檔案%@",selectFile);
        
        //[self showDetail:selectFile];
    }
    else if(_backeAble){
        [readFile moveToWork:fileName];
        [listData removeObjectAtIndex:indexPath.row];
        [oneCell removeFromSuperview];
    }
    else if(_deleteAble){
        NSLog(@"list delete\n");
        [readFile deleteFileWithName:fileName];
        [listData removeObjectAtIndex:indexPath.row];
        [oneCell removeFromSuperview];
    }
     */
}

@end
