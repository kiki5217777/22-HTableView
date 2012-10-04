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
    NSArray *recipes;
}

@end

@implementation TrashListController
@synthesize listData, selectFile;

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
    oneCell = [cellArray objectAtIndex:indexPath.row];
    NSLog(@"%@",oneCell.label.text);
    NSString *fileName = oneCell.label.text;
    
    if (_deleteAble == _backeAble) {
        printf("list look\n");
        selectFile = oneCell.label.text;
        NSLog(@"垃圾桶點到的檔案%@",selectFile);
        
        [self showDetail:selectFile];
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

-(void) showDetail:(NSString*)sName
{

    //初始化AlertView
    //NSString *str = [readFile readFromFileWithName:sName];
    //NSLog(@"%@",str);
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:sName
                                                   message:@"\n"
                          @"\n"
                          @"\n"
                          @"\n"
                          @"\n"
                          @"\n"

                                                  delegate:self
                                         cancelButtonTitle:@"取消"
                                         otherButtonTitles:@"叫回",nil];
    
    //这个属性继承自UIView，当一个视图中有多个AlertView时，可以用这个属性来区分
    alert.tag = 0;
    
    //只读属性，看AlertView是否可见
    NSLog(@"alert2:%d",alert.visible);
    
    //通过给定标题添加按钮
    [alert addButtonWithTitle:@"刪除"];
    
    UIImageView *imgView = [[UIImageView alloc]initWithImage:[readFile loadImageWithName:sName]];
    imgView.center = CGPointMake(110, 110);
    
    UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 250, 130)];
    //scroll.backgroundColor = [UIColor blackColor];
    scroll.center = CGPointMake(140, 100);
    scroll.contentSize = imgView.frame.size;
    [scroll setScrollEnabled:YES];
    [scroll addSubview:imgView];
    [alert addSubview:scroll];
    
    [alert setFrame:CGRectMake(0, 0, 400, 400)];
    //按钮总数
    NSLog(@"numberOfButtons:%d",alert.numberOfButtons);
    
    //获取指定索引的按钮的标题
    NSLog(@"buttonTitleAtIndex:%@",[alert buttonTitleAtIndex:2]);
    
    //获得取消按钮的索引
    NSLog(@"cancelButtonIndex:%d",alert.cancelButtonIndex);
    
    //获得第一个其他按钮的索引
    NSLog(@"firstOtherButtonIndex:%d",alert.firstOtherButtonIndex);
    
    //显示AlertView
    [alert show];
    alert = Nil;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSLog(@"单击第:%d",buttonIndex);
    int index;
    switch (buttonIndex) {
        case 1:
            NSLog(@"叫回");
            [readFile moveToWork:selectFile];
            index = [listData indexOfObject:selectFile];
            [listData removeObjectAtIndex:index];
            [oneCell removeFromSuperview];
            break;
        case 2:
            NSLog(@"刪除");
            [readFile deleteFileWithName:selectFile];
            index = [listData indexOfObject:selectFile];
            [listData removeObjectAtIndex:index];
            [oneCell removeFromSuperview];
            break;
        default:
            break;
    }
}

@end
