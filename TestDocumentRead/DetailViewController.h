//
//  DetailViewController.h
//  TestDocumentRead
//
//  Created by Mac06 on 12/10/2.
//
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController
{
    NSString *recptName;
}
@property (nonatomic, retain) NSString *recptName;
@property (weak, nonatomic) IBOutlet UILabel *openFileName;

-(void) showData;
@end
