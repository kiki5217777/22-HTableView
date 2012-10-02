//
//  DetailViewController.m
//  TestDocumentRead
//
//  Created by Mac06 on 12/10/2.
//
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController
@synthesize recptName, openFileName;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (id) initWithFileName:(NSString *) name
{
    self = [super init];
    if (self) {
        printf("Detal init");
    }
    return self;
}

- (void)viewDidLoad
{
    //UILabel *lebel = [[UILabel alloc] init];
    //lebel.text = fileName;
    //NSLog(@"%@",recptName);
    openFileName.text = @"tttet";
    printf("load");
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) showData
{
    printf("\n---------showData");
}
@end
