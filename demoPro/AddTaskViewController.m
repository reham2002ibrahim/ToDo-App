

#import "AddTaskViewController.h"
#import "Task.h"
#import "AllTasks.h"



@interface AddTaskViewController ()

@property (weak, nonatomic) IBOutlet UITextField *titleText;

@property (weak, nonatomic) IBOutlet UITextView *descText;
@property (weak, nonatomic) IBOutlet UISegmentedControl *myStatus;
@property (weak, nonatomic) IBOutlet UIDatePicker *myDate;
@property  IBOutlet UISegmentedControl *myPriority;


@end

@implementation AddTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.myDate setMinimumDate: [NSDate date]];
    self.descText.layer.borderWidth = 1.0f;

    self.descText.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    self.titleText.layer.borderWidth = 1.0f;

    self.titleText.layer.borderColor = [UIColor lightGrayColor].CGColor;
}
- (IBAction)prioritySelect:(UISegmentedControl *)sender {
}

- (IBAction)statusSelect:(UISegmentedControl *)sender {
}
- (IBAction)dateSelect:(UIDatePicker *)sender {
//    [self.myDate setMinimumDate: [NSDate date]];

    
}

- (IBAction)addTaskBtn:(UIButton *)sender {
    
    if (self.titleText.text .length <= 0 || self.descText.text.length <= 0 ) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Sorry"
                                                                     message:@"We can't add a task without title or Description"
                                                              preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
        
        [OKAction setValue:[UIColor systemMintColor] forKey:@"titleTextColor"];
        [alert addAction:OKAction];
        [self presentViewController:alert animated:YES completion:nil];

        
    }else {
        
        
        
        Task *newTask = [[Task alloc] init];
        
        newTask.title = self.titleText.text;
        newTask.desc = self.descText.text;
        newTask.date = self.myDate.date;
        
        

        newTask.priority = self.myPriority.selectedSegmentIndex;
        
        NSMutableDictionary *targetDictionary = [AllTasks getInstance].todoDictionary;
        NSString *key = @"todoDictionary";
  
        if (targetDictionary && key) {
            NSMutableArray *priorityArray = nil;
            NSString *priorityKey = nil;
            
            switch (newTask.priority) {
                case 0:
                    priorityKey = @"High";
                    break;
                case 1:
                    priorityKey = @"Medium";
                    break;
                case 2:
                    priorityKey = @"Low";
                    break;
            }
            
            
            priorityArray = targetDictionary[priorityKey];
            
            if (!priorityArray) {
                priorityArray = [NSMutableArray array];
                targetDictionary[priorityKey] = priorityArray;  }
            
            [priorityArray addObject:newTask];
            [[AllTasks getInstance] saveDataForKey:key fromDictionary:targetDictionary];
            
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }
}

@end
