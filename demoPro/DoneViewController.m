

#import "DoneViewController.h"
#import "AddTaskViewController.h"
#import "AllTasks.h"
#import "Task.h"
#import "EditTaskViewController.h"

@interface DoneViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>


@property (weak, nonatomic) IBOutlet UITableView *doneTable;

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (weak, nonatomic) IBOutlet UISearchBar *searchtxt;
@property (weak, nonatomic) IBOutlet UIImageView *img;

@property NSMutableDictionary<NSString *, NSMutableArray<Task *> *> *doneDictionary;
@property NSMutableArray<Task *> *allTasksArray;
@property NSMutableArray<Task *> *filteredTasks;
@property BOOL filterFlag;






@end

@implementation DoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.doneTable.delegate = self;
    self.doneTable.dataSource = self;
    self.searchtxt.delegate = self;
    
    
    self.doneTable.layer.cornerRadius = 15.0;
    
    self.filterFlag = NO;
    self.filteredTasks = [NSMutableArray array];
    
    [self.segmentControl addTarget:self action:@selector(segmentValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    [self loadTodoData];
    [self updateUIBasedOnData];

}

- (void)loadTodoData {
    self.doneDictionary = [[AllTasks getInstance] loadDataForKey:@"doneDictionary"];
    self.allTasksArray = [NSMutableArray array];
    
    for (NSString *priority in @[@"High", @"Medium", @"Low"]) {
        NSArray<Task *> *tasks = self.doneDictionary[priority];
        [self.allTasksArray addObjectsFromArray:tasks];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.doneDictionary = [AllTasks getInstance].doneDictionary;
    self.allTasksArray = [NSMutableArray array];
    
    for (NSString *priority in @[@"High", @"Medium", @"Low"]) {
        NSArray<Task *> *tasks = self.doneDictionary[priority];
        [self.allTasksArray addObjectsFromArray:tasks];
    }
    
    [self.doneTable reloadData];
    [self updateUIBasedOnData];

}

- (void)updateUIBasedOnData {
    if (self.allTasksArray.count == 0) {
        self.img.hidden = NO;
        self.doneTable.hidden = YES;
        self.segmentControl.hidden = YES;
        self.searchtxt.hidden = YES;
    } else {
        self.img.hidden = YES;
        self.doneTable.hidden = NO;
        self.segmentControl.hidden = NO;
        self.searchtxt.hidden = NO;
    }
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.filterFlag && self.searchtxt.text.length > 0) {
        return 1;
    }
    return (self.segmentControl.selectedSegmentIndex == 1) ? 3 : 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.filterFlag && self.searchtxt.text.length > 0) {
        return self.filteredTasks.count;
    } else if (self.segmentControl.selectedSegmentIndex == 1) {
        NSArray *priorityLevels = @[@"High", @"Medium", @"Low"];
        NSString *priority = priorityLevels[section];
        return [self.doneDictionary[priority] count];
    } else {
        return self.allTasksArray.count;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"donegcell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"donegcell"];
    }

    Task *task;
    
    if (self.filterFlag && self.searchtxt.text.length > 0) {
        task = self.filteredTasks[indexPath.row];
    } else if (self.segmentControl.selectedSegmentIndex == 1) {
        NSArray *priorityLevels = @[@"High", @"Medium", @"Low"];
        NSString *priority = priorityLevels[indexPath.section];
        task = self.doneDictionary[priority][indexPath.row];
    } else {
        task = self.allTasksArray[indexPath.row];
    }

    cell.textLabel.text = task.title;
    cell.detailTextLabel.text = task.desc;
  //  cell.detailTextLabel.text = task.desc;
    cell.layer.cornerRadius = 25.0;
    cell.clipsToBounds = YES;


    NSString *imageName;
    switch (task.priority) {
        case 0:
            imageName = @"r";
            cell.backgroundColor = [UIColor colorWithRed:1.0 green:0.8 blue:0.8 alpha:0.3];
            break;
        case 1:
            imageName = @"m";
            cell.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:0.8 alpha:0.3];
            break;
        case 2:
            imageName = @"g";
            cell.backgroundColor = [UIColor colorWithRed:0.8 green:1.0 blue:0.8 alpha:0.3];
            break;
    }

    cell.imageView.image = [UIImage imageNamed:imageName];

    return cell;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (self.filterFlag && self.searchtxt.text.length > 0) {
        return @"Search Results";
    } else if (self.segmentControl.selectedSegmentIndex == 1) {
        NSArray *curPriority = @[@"High", @"Medium", @"Low"];
        return curPriority[section];
    }
    else return @"All Tasks" ;
    return nil;
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length == 0) {
        self.filterFlag = NO;
        [self.filteredTasks removeAllObjects];
    } else {
        self.filterFlag = YES;
        [self.filteredTasks removeAllObjects];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title CONTAINS[cd] %@ OR desc CONTAINS[cd] %@", searchText, searchText];
        self.filteredTasks = [[self.allTasksArray filteredArrayUsingPredicate:predicate] mutableCopy];
    }
    
    [self.doneTable reloadData];
}


-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
   [searchBar resignFirstResponder];
}


- (void)segmentValueChanged:(UISegmentedControl *)sender {
   [self.doneTable reloadData];
}


// fo delete

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
   return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Delete"
                                                                     message:@"Are you sure you want to delete this task?"
                                                              preferredStyle:UIAlertControllerStyleAlert];

        UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            
            Task *delTask;
            
            if (self.filterFlag && self.searchtxt.text.length > 0) {
                delTask = self.filteredTasks[indexPath.row];
                [self.filteredTasks removeObjectAtIndex:indexPath.row];
                
                NSString *priority;
                switch (delTask.priority) {
                    case 0: priority = @"High"; break;
                    case 1: priority = @"Medium"; break;
                    case 2: priority = @"Low"; break;
                }
                
                [self.doneDictionary[priority] removeObject:delTask];
                [self.allTasksArray removeObject:delTask];
                
            } else if (self.segmentControl.selectedSegmentIndex == 1) {
                NSArray *priorityLevels = @[@"High", @"Medium", @"Low"];
                NSString *priority = priorityLevels[indexPath.section];
                delTask = self.doneDictionary[priority][indexPath.row];
                
                [self.doneDictionary[priority] removeObjectAtIndex:indexPath.row];
                [self.allTasksArray removeObject:delTask];
                
            } else {
                delTask = self.allTasksArray[indexPath.row];
                
                NSString *priority;
                switch (delTask.priority) {
                    case 0: priority = @"High"; break;
                    case 1: priority = @"Medium"; break;
                    case 2: priority = @"Low"; break;
                }
                
                [self.doneDictionary[priority] removeObject:delTask];
                [self.allTasksArray removeObjectAtIndex:indexPath.row];
            }
            
            [[AllTasks getInstance] saveDataForKey:@"doneDictionary" fromDictionary:self.doneDictionary];
            
            [self.doneTable deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }];

        UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"Cancel"
                                   
                                                           
                                                           style:UIAlertActionStyleCancel handler:nil];

        [alert addAction:yesAction];
        [alert addAction:noAction];

        [self presentViewController:alert animated:YES completion:nil];
    }
}

// to edit

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Task *selectedTask;
    
    if (self.filterFlag && self.searchtxt.text.length > 0) {
        selectedTask = self.filteredTasks[indexPath.row];
    } else if (self.segmentControl.selectedSegmentIndex == 1) {
        NSArray *priorityStr = @[@"High", @"Medium", @"Low"];
        NSString *priority = priorityStr[indexPath.section];
        selectedTask = self.doneDictionary[priority][indexPath.row];
    } else {
        selectedTask = self.allTasksArray[indexPath.row];
    }

    EditTaskViewController *editVC = [self.storyboard instantiateViewControllerWithIdentifier:@"EditTaskViewController"];
    editVC.task = selectedTask;
    editVC.page = 3 ;
    
    [self.navigationController pushViewController:editVC animated:YES];
}






@end
