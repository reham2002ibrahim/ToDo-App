//
//  ViewController.m
//  xoxo
//
//  Created by MAC on 23/04/2025.
//

#import "ViewController.h"
#import <SDWebImage/SDWebImage.h>
#import "TodoViewController.h"
#import "TabBarController.h"



@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *myImage;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        TabBarController *todoVC =
        [self.storyboard instantiateViewControllerWithIdentifier:@"TabBarController"];
        [self.navigationController pushViewController:todoVC animated:YES] ;

      });
}



@end
