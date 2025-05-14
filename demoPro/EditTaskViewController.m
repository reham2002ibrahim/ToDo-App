#import "EditTaskViewController.h"
#import "AllTasks.h"
#import "Task.h"
@interface EditTaskViewController ()


@property IBOutlet UITextField *titleText;

@property IBOutlet UITextView *descText;
@property IBOutlet UISegmentedControl *myStatus;
@property IBOutlet UIDatePicker *myDate;
@property IBOutlet UISegmentedControl *myPriority;


@end

@implementation EditTaskViewController
int pop = 0 ;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(self.page == 2 ) {
        [self.myStatus setEnabled:NO forSegmentAtIndex:0];
    }
    else if (self.page == 3 ) {
        [self.myStatus setEnabled:NO forSegmentAtIndex:0];
        [self.myStatus setEnabled:NO forSegmentAtIndex:1];

        
    }
    
        self.titleText.text = self.task.title;
        self.descText.text = self.task.desc;

        [self.myDate setDate:self.task.date];
        [self.myDate setMinimumDate: [NSDate date]];

        
        self.myPriority.selectedSegmentIndex = self.task.priority;
        self.myStatus.selectedSegmentIndex = self.task.status;
    
    self.descText.layer.borderWidth = 1.0f;

    self.descText.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    self.titleText.layer.borderWidth = 1.0f;

    self.titleText.layer.borderColor = [UIColor lightGrayColor].CGColor;

}

- (IBAction)editBtn:(id)sender {
    
    if (self.titleText.text .length <= 0 || self.descText.text.length <= 0 ) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Sorry"
                                                                     message:@"We can't add a task without title or description"
                                                              preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
        
        [OKAction setValue:[UIColor systemMintColor] forKey:@"titleTextColor"];
        [alert addAction:OKAction];
        [self presentViewController:alert animated:YES completion:nil];

        return;
    }
       
       
       NSMutableDictionary *oldDict = nil;
       NSString *oldKey = nil;
    
    if (self.page == 1 ) {oldDict = [AllTasks getInstance].todoDictionary;
        oldKey = @"todoDictionary";}
    else if (self.page == 2 )  {oldDict = [AllTasks getInstance].doingDictionary;
    oldKey = @"doingDictionary";}
    else {    oldDict = [AllTasks getInstance].doneDictionary;
        oldKey = @"doneDictionary";}


           NSString *priorityStr = @[@"High", @"Medium", @"Low"][self.task.priority];
           NSMutableArray *taskArray = oldDict[priorityStr];
           [taskArray removeObject:self.task];
           [[AllTasks getInstance] saveDataForKey:oldKey fromDictionary:oldDict];

       
       Task *editedTask = [[Task alloc] init];
       editedTask.title = self.titleText.text;
       editedTask.desc = self.descText.text;
       editedTask.date = self.myDate.date;
       editedTask.priority = self.myPriority.selectedSegmentIndex;
       editedTask.status = self.myStatus.selectedSegmentIndex;
       
       NSMutableDictionary *newDict = nil;
       NSString *newKey = nil;
    
    
       
       switch (editedTask.status) {
           case 0:
               newDict = [AllTasks getInstance].todoDictionary;
               newKey = @"todoDictionary";
               break;
           case 1:
               newDict = [AllTasks getInstance].doingDictionary;
               newKey = @"doingDictionary";
               break;
           case 2:
               newDict = [AllTasks getInstance].doneDictionary;
               newKey = @"doneDictionary";
               break;
       }

      
           NSString *newPstr = @[@"High", @"Medium", @"Low"][editedTask.priority];
           NSMutableArray *newArray = newDict[newPstr];
           
           if (!newArray) {
               newArray = [NSMutableArray array];
               newDict[newPstr] = newArray;
           }

           [newArray addObject:editedTask];
           [[AllTasks getInstance] saveDataForKey:newKey fromDictionary:newDict];
       

       [self.navigationController popViewControllerAnimated:YES];
    
    
    
    
}




@end
