//
//  FileList.h
//  TestDocumentRead
//
//  Created by gdlab on 12/7/29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/NSNotification.h>
#import "EasyTableView.h"
#import "FileOps.h"

@interface FileListController:UITableViewController<EasyTableViewDelegate,UITableViewDelegate,UITableViewDataSource>
{
    EasyTableView *horizontalView;
    NSMutableArray *listData,*imageList;
    FileOps *readimage;
    id mainViewId;
}

@property (nonatomic, retain) NSMutableArray *listData,*imageList;
@property (nonatomic, retain) id mainViewId;
@property (nonatomic) EasyTableView *horizontalView;
@end

