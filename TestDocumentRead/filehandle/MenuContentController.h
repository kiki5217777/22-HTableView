//
//  MenuContenController.h
//  TestDocumentRead
//
//  Created by  on 2012/8/15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "menuCell.h"

@interface MenuContentController : UITableViewController

{
    NSMutableArray *listData;
    NSMutableArray *selectedArray;
    BOOL inPseudoEditMode;
}

@property (nonatomic, retain) NSMutableArray *listData;
@property (nonatomic, retain) NSMutableArray *selectedArray;
- (void)populateSelectedArray;
@end
