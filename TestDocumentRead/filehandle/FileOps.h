//
//  FileOps.h
//  TextView
//
//  Created by 范 丙林 on 12/7/15.
//  Copyright (c) 2012年 國立台北教育大學. All rights reserved.
//

#import <Foundation/Foundation.h>

#define FILE_NAME @"desk"
#define FILE_TYPE @".p"
#define IMG_TYPE @".png"

@interface FileOps : NSObject{
    NSFileManager *fileMgr;
    NSString *filename;
    NSString *filepath;
    NSString *fileOpened;
    UIImage  *stringImage;
    NSString *stringImageName;
    NSString *imageFilePath;

}

@property(nonatomic,retain) NSFileManager *fileMgr;
@property(nonatomic,retain)  NSString *filename;
@property(nonatomic,retain)  NSString *filepath;
@property(nonatomic,retain)  NSString *fileOpened;
@property(nonatomic,retain) UIImage  *stringImage;
@property(nonatomic,retain) NSString *stringImageName,*imageFilePath;
//stringimage name,path

-(void)WriteToStringFile:(NSMutableString *) textToWrite;
-(void)WriteToNewFile:(NSMutableString *)textToWrite;
-(NSString *) readFromFile;
-(NSString *) readFromFileWithName:(NSString*) name;
-(NSString *)readFromTrashWithName:(NSString*) name;
-(NSString *) setFilename;

-(int) numOfWorkFiles;
-(int) numOfTrashFiles;

-(NSArray*) getWorkFileList;
-(NSArray*) getTrashFileList;

-(NSString*) getNextFileName;
-(BOOL) moveToTrash:(NSString*) name;
-(BOOL) moveToWork:(NSString*) name;
-(BOOL) deleteFileWithName:(NSString*) name;

-(void) stringToimage:(NSMutableString*) textToImage;//string saved to image
-(void) WriteToImageFile; //save image
-(UIImage *) ReadFromImageFileWithName:(NSUInteger)index; //load image
-(UIImage *) loadImageWithName:(NSString*)imgName;
-(NSArray*) getImageFileList;//get imagefilelist
@end
