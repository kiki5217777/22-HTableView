//
//  FileOps.m
//  TextView
//
//  Created by 范 丙林 on 12/7/15.
//  Copyright (c) 2012年 國立台北教育大學. All rights reserved.
//

#import "FileOps.h"
#define ASC CFStringConvertEncodingToNSStringEncoding(NSASCIIStringEncoding)

@implementation FileOps
@synthesize fileMgr;
@synthesize filename;
@synthesize filepath;
@synthesize fileOpened;
@synthesize stringImage, stringImageName, imageFilePath;
-(id) init
{
    if (self == [super init]) {
        if (fileMgr == Nil) {
            fileMgr = [NSFileManager defaultManager];
        }
        if ([fileMgr fileExistsAtPath:TRASH_PATH]) {
            [fileMgr createDirectoryAtPath:TRASH_PATH withIntermediateDirectories:YES attributes:Nil error:Nil];
        }
        if ([fileMgr fileExistsAtPath:WORK_PATH]) {
            [fileMgr createDirectoryAtPath:WORK_PATH withIntermediateDirectories:YES attributes:Nil error:Nil];
        }
        if ([fileMgr fileExistsAtPath:IMG_PATH]) {
            [fileMgr createDirectoryAtPath:IMG_PATH withIntermediateDirectories:YES attributes:Nil error:Nil];
        }
    }
    return self;
}

-(NSString *) setFilename{
    return [FILE_NAME stringByAppendingFormat:@"%@%@",[self getTime], FILE_TYPE];
}
/* 顯示資料夾底下所有檔案名稱*/
-(int) numOfWorkFiles {
    NSArray *workfileList = [self getWorkFileList];
    return [workfileList count];
}
-(int) numOfTrashFiles {
    NSArray *fileList = [self getTrashFileList];
    return [fileList count];
}

/* 檔案列表*/
-(NSArray*) getWorkFileList {
    NSError *error = nil;
    NSArray *fileList = [fileMgr contentsOfDirectoryAtPath:WORK_PATH error:&error];
    NSMutableArray *dirList = [[NSMutableArray alloc] init];
    for (NSString *file in fileList) {
        NSString  *path =[WORK_PATH stringByAppendingPathComponent:file];
        BOOL isDir;
        BOOL success = [fileMgr fileExistsAtPath:path isDirectory:&isDir];
        BOOL other = NO;
        //[file isEqualToString:@" .DS_Store"];
        other = [file isEqualToString:@".DS_Store"];
        if (success & !isDir & !other) {
            [dirList addObject:file];
            NSLog(@"%@",file);
        }
        NSLog(@"not in %@",file);
    }
    //降冪排列
    NSSortDescriptor *SortDescriptor=[NSSortDescriptor sortDescriptorWithKey:Nil ascending:NO selector:@selector(compare:)];
    dirList = [[dirList sortedArrayUsingDescriptors:[[NSArray arrayWithObject:SortDescriptor] mutableCopy]] mutableCopy];
    
    return dirList;
}

-(NSArray*) getTrashFileList {
    NSError *error = nil;
    NSArray *fileList = [fileMgr contentsOfDirectoryAtPath:TRASH_PATH error:&error];
    NSMutableArray *dirList = [[NSMutableArray alloc] init];
    for (NSString *file in fileList) {
        NSString  *path =[TRASH_PATH stringByAppendingPathComponent:file];
        BOOL isDir;
        BOOL success = [fileMgr fileExistsAtPath:path isDirectory:&isDir];
        if ( success & !isDir) {
            [dirList addObject:file];
        }
    }
    //降冪排列
    NSSortDescriptor *SortDescriptor=[NSSortDescriptor sortDescriptorWithKey:Nil ascending:NO selector:@selector(compare:)];
    dirList = [[dirList sortedArrayUsingDescriptors:[NSArray arrayWithObject:SortDescriptor]] mutableCopy];
    
    return dirList;
}

////////////////////////////////////////////////////////////
# pragma mark 檔案讀寫
////////////////////////////////////////////////////////////

-(void)WriteToStringFile:(NSMutableString *)textToWrite{
    filepath = [[NSString alloc] init];
    NSError *err;
    //filepath = [self.GetDocumentDirectory stringByAppendingPathComponent:self.setFilename];
    filepath = [WORK_PATH stringByAppendingPathComponent:fileOpened];
    NSLog(@"%@",filepath);
    NSData *data = [textToWrite dataUsingEncoding:ASC];
    NSLog(@"write %@",data);
    //NSString *txtInFile = [[NSString alloc] initWithData:data encoding:ASC];
    //BOOL ok = [textToWrite writeToFile:filepath atomically:YES encoding:ASC error:&err];
    BOOL ok = [data writeToFile:filepath atomically:YES];
    if(!ok){
        NSLog(@"Error writing file at %@\n%@",filepath, [err localizedFailureReason]);
    }
}

-(void)WriteToNewFile:(NSMutableString *)textToWrite{
    NSError *err;
    filepath = [WORK_PATH stringByAppendingPathComponent:self.setFilename];
    //BOOL ok = [textToWrite writeToFile:filepath atomically:YES encoding:ASC error:&err];
    NSData *data = [textToWrite dataUsingEncoding:ASC];
    NSLog(@"write %@",data);
    BOOL ok = [data writeToFile:filepath atomically:YES];
    if(!ok){
        NSLog(@"Error writing file at %@\n%@",filepath, [err localizedFailureReason]);
        //NSLog(@"Error writing file at %@\n%@",filepath, [err description]);
        [fileMgr createDirectoryAtPath:WORK_PATH withIntermediateDirectories:YES attributes:Nil error:Nil];
        [textToWrite writeToFile:filepath atomically:YES encoding:NSUnicodeStringEncoding error:&err];
    }
}

-(NSString *)readFromFile{
    //filepath = [[NSString alloc]init];
    //NSError *error;
    NSString *title;
    //filepath = [self.GetDocumentDirectory stringByAppendingPathComponent:self.setFilename];
    filepath = [WORK_PATH stringByAppendingPathComponent:self.fileOpened];
    
    NSData *data = [[NSData alloc] initWithContentsOfFile:filepath];
    NSLog(@"nsdata %@",data);
    NSString *txtInFile = [[NSString alloc] initWithData:data encoding:ASC];
    //NSString *txtInFile = [[NSString alloc] initWithContentsOfFile:filepath encoding:ASC error:&error];
    if(!txtInFile){
        UIAlertView *tellErr = [[UIAlertView alloc] initWithTitle:title message:@"Unable to get text from file" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
        [tellErr show];
    }
    return txtInFile;
}

-(NSString *)readFromFileWithName:(NSString*) name {
    fileOpened = name;
    filepath = [[NSString alloc]init];
    NSError *error;
    NSString *title;
    filepath = [WORK_PATH stringByAppendingPathComponent:name];
    //NSString *txtInFile = [[NSString alloc] initWithContentsOfFile:filepath encoding:ASC error:&error];
    NSData *data = [[NSData alloc] initWithContentsOfFile:filepath];
    NSLog(@"nsdata %@",data);
    NSString *txtInFile = [[NSString alloc] initWithData:data encoding:ASC];
    if(!txtInFile){
         NSLog(@"Error reading file at %@\n%@",filepath, [error localizedFailureReason]);
        UIAlertView *tellErr = [[UIAlertView alloc] initWithTitle:title message:@"Unable to get text from file" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
        [tellErr show];
    }
    filepath = nil;
    return txtInFile;
}
///---------------
-(NSString *)readFromTrashWithName:(NSString*) name {
    fileOpened = name;
    filepath = [[NSString alloc]init];
    NSError *error;
    NSString *title;
    filepath = [TRASH_PATH stringByAppendingPathComponent:name];
    //NSString *txtInFile = [[NSString alloc] initWithContentsOfFile:filepath encoding:ASC error:&error];
    NSData *data = [[NSData alloc] initWithContentsOfFile:filepath];
    NSLog(@"nsdata %@",data);
    NSString *txtInFile = [[NSString alloc] initWithData:data encoding:ASC];
    if(!txtInFile){
        NSLog(@"Error reading file at %@\n%@",filepath, [error localizedFailureReason]);
        UIAlertView *tellErr = [[UIAlertView alloc] initWithTitle:title message:@"Unable to get text from file" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
        [tellErr show];
    }
    filepath = nil;
    return txtInFile;
}
////////////////////////////////////////////////////////////
# pragma mark 移動檔案
////////////////////////////////////////////////////////////

-(BOOL) moveToTrash:(NSString*) name {
    NSError *error;
    BOOL moveSuccess;
    if (name) {
        if ([fileMgr moveItemAtPath:[WORK_PATH stringByAppendingPathComponent:name] toPath:[TRASH_PATH stringByAppendingPathComponent:name] error:&error]) {
            printf("移動成功!!\n");
            moveSuccess = YES;
        }
        else
        {
            NSLog(@"移動不成功，錯誤訊息：%@",error);
            [fileMgr createDirectoryAtPath:TRASH_PATH withIntermediateDirectories:YES attributes:Nil error:Nil];
            [fileMgr removeItemAtPath:[TRASH_PATH stringByAppendingPathComponent:name] error:&error];
            [fileMgr moveItemAtPath:[WORK_PATH stringByAppendingPathComponent:name] toPath:[TRASH_PATH stringByAppendingPathComponent:name] error:&error];
            moveSuccess = NO;
        }
    }
    return moveSuccess;
}

-(BOOL) moveToWork:(NSString*) name {
    NSError *error;
    BOOL moveSuccess;
    if (name) {
        if ([fileMgr moveItemAtPath:[TRASH_PATH stringByAppendingPathComponent:name] toPath:[WORK_PATH stringByAppendingPathComponent:name] error:&error]) {
            printf("移動成功!!\n");
            moveSuccess = YES;
        }
        else
        {
            NSLog(@"移動不成功，錯誤訊息：%@",error);
            [fileMgr createDirectoryAtPath:WORK_PATH withIntermediateDirectories:YES attributes:Nil error:Nil];
            [fileMgr moveItemAtPath:[TRASH_PATH stringByAppendingPathComponent:name] toPath:[WORK_PATH stringByAppendingPathComponent:name] error:&error];
            moveSuccess = NO;
        }
    }
    return moveSuccess;
}

-(BOOL) deleteFileWithName:(NSString*) name {
    NSError *error;
    BOOL deleteSuccess;
    if (name) {
        NSLog(@"刪除檔案：%@", name);
        
        deleteSuccess = [fileMgr removeItemAtPath:[TRASH_PATH stringByAppendingPathComponent:name] error:&error];
        
        NSArray *temp = [name componentsSeparatedByString:@"."];
        name = temp[0];
        name = [name stringByAppendingString:IMG_TYPE];
        NSLog(@"刪除檔案：%@", name);
        deleteSuccess = [fileMgr removeItemAtPath:[IMG_PATH stringByAppendingPathComponent:name] error:&error];
    }
    if (!deleteSuccess) {
        NSLog(@"Error writing file at %@\n%@",IMG_PATH, [error localizedFailureReason]);
    }
    return deleteSuccess;
}

-(NSString*) getNextFileName {
    if (fileOpened) {
        NSArray* list = [self getWorkFileList];
        int index = [list indexOfObject:fileOpened]+1;
        if ( index < [list count]) {
            fileOpened = [list objectAtIndex:index];
        }
        else
        {
            fileOpened = [list objectAtIndex:0];
        }
    }
    return fileOpened;
}

-(NSString*) getTime
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateFormat:@"MM-dd HH:mm:ss"];
    //dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss.SSSSSS";
    //NSLog(@"Date%@", [dateFormatter stringFromDate:[NSDate date]]);
    return [dateFormatter stringFromDate:[NSDate date]];
}

////////////////////////////////////////////////////////////
# pragma mark 儲存圖片檔案
////////////////////////////////////////////////////////////
//set image name
-(NSString *) setImageFilename{
    //stringImageName = @"myorderimagefile";
    return [FILE_NAME stringByAppendingFormat:@"%@%@",[self getTime],IMG_TYPE];
}

//string save into image
-(void)stringToimage:(NSMutableString *)textToImage{
    CGRect rect = CGRectMake(0, 0,200,200);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0);
    [RGBA(255, 0, 0, 1) set];
    [textToImage drawInRect:rect withFont:[UIFont fontWithName:@"STHeitiTC-Medium" size:15.0f]];
    stringImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

//save image
-(void) WriteToImageFile{
    imageFilePath = [[NSString alloc]init];
    //NSError *err;
    imageFilePath = [IMG_PATH stringByAppendingPathComponent:self.setImageFilename];
    NSLog(@"%@",imageFilePath);
    //BOOL ok =[UIImagePNGRepresentation(stringImage) writeToFile:imagefilepath error:&err];
    /*if (!ok) {
     NSLog(@"Error writing file at %@\n%@",imagefilepath,[err localizedFailureReason]);
     }*/
    BOOL ok=[UIImagePNGRepresentation(stringImage) writeToFile:imageFilePath atomically:YES];
    if (!ok) {
        [fileMgr createDirectoryAtPath:IMG_PATH withIntermediateDirectories:YES attributes:Nil error:Nil];
        imageFilePath = [IMG_PATH stringByAppendingPathComponent:self.setImageFilename];
        NSLog(@"%@",imageFilePath);
        NSLog(@"Error writing file at %@\n",imageFilePath);
    }
    
}

//load image
-(UIImage *) ReadFromImageFileWithName:(NSUInteger)index{
    
    imageFilePath = [[NSString alloc]init];
    UIImage *image;
    //NSError *error=nil;
    NSArray *imagefileList =[self getImageFileList];
    if ([imagefileList count] > 0) {
        NSString *imageFileName =[imagefileList objectAtIndex:index];
        NSString *title;
        
        imageFilePath = [IMG_PATH stringByAppendingPathComponent:imageFileName];
        //NSString *txtInFile = [[NSString alloc] initWithContentsOfFile:imagefilepath encoding:NSUnicodeStringEncoding error:&err];
        NSLog(@"\n image fath ------------%@",imageFilePath);
        image =[UIImage imageWithContentsOfFile:imageFilePath];
        if(!image){
            UIAlertView *tellErr = [[UIAlertView alloc] initWithTitle:title message:@"Unable to get image from file" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
            [tellErr show];
        }
    }
    return image;
}

//load image
-(UIImage *) loadImageWithName:(NSString*)imgName{
    
    imageFilePath = [[NSString alloc]init];
    UIImage *image;
    NSArray *temp = [imgName componentsSeparatedByString:@"."];
    imgName = temp[0];
    imgName = [imgName stringByAppendingString:IMG_TYPE];
    
    NSArray *imagefileList =[self getImageFileList];
    int index = [imagefileList indexOfObject:imgName];

    NSLog(@"圖片列表%@",[imagefileList debugDescription]);
    NSLog(@"圖片檔名%@ index %d",imgName, index);
    
    image = [self ReadFromImageFileWithName:index];
    return image;
}

//get Image FileList
-(NSArray*) getImageFileList {
    NSError *error = nil;
    NSArray *fileList = [fileMgr contentsOfDirectoryAtPath:IMG_PATH error:&error];
    NSMutableArray *dirList = [[NSMutableArray alloc] init];
    for (NSString *file in fileList) {
        NSString  *path =[IMG_PATH stringByAppendingPathComponent:file];
        //UIImage *image = [UIImage imageWithContentsOfFile:path];//uiimage
        BOOL isDir;
        BOOL success = [fileMgr fileExistsAtPath:path isDirectory:&isDir];
        if ( success & !isDir) {
            [dirList addObject:file];
        }
    }
    //降冪排列
    NSSortDescriptor *SortDescriptor=[NSSortDescriptor sortDescriptorWithKey:Nil ascending:NO selector:@selector(compare:)];
    dirList = [[dirList sortedArrayUsingDescriptors:[NSArray arrayWithObject:SortDescriptor]] mutableCopy];
    
    return dirList;
}

@end
