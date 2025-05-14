#import "DoingViewController.h"
#import "AddTaskViewController.h"
#import "AllTasks.h"
#import "Task.h"
#import "EditTaskViewController.h"

@interface DoingViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property IBOutlet UITableView *doingTable;
@property IBOutlet UISegmentedControl *segmentControl;
@property IBOutlet UISearchBar *searchtxt;
@property (strong, nonatomic) IBOutlet UIImageView *img;

@property NSMutableDictionary<NSString *, NSMutableArray<Task *> *> *doingDictionary;
@property NSMutableArray<Task *> *allTasksArray;
@property NSMutableArray<Task *> *filteredTasks;
@property BOOL filterFlag;

@end

@implementation DoingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.img.hidden = YES;

    
    self.doingTable.delegate = self;
    self.doingTable.dataSource = self;
    self.searchtxt.delegate = self;
    
    
    self.doingTable.layer.cornerRadius = 15.0;
    
    self.filterFlag = NO;
    self.filteredTasks = [NSMutableArray array];
    
    [self.segmentControl addTarget:self action:@selector(segmentValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    [self loadTodoData];
    [self updateUIBasedOnData];

}

- (void)loadTodoData {
    self.doingDictionary = [[AllTasks getInstance] loadDataForKey:@"doingDictionary"];
    self.allTasksArray = [NSMutableArray array];
    
    for (NSString *priority in @[@"High", @"Medium", @"Low"]) {
        NSArray<Task *> *tasks = self.doingDictionary[priority];
        [self.allTasksArray addObjectsFromArray:tasks];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.doingDictionary = [AllTasks getInstance].doingDictionary;
    self.allTasksArray = [NSMutableArray array];
    
    for (NSString *priority in @[@"High", @"Medium", @"Low"]) {
        NSArray<Task *> *tasks = self.doingDictionary[priority];
        [self.allTasksArray addObjectsFromArray:tasks];
    }
    
    [self.doingTable reloadData];
    [self updateUIBasedOnData];

}
- (void)updateUIBasedOnData {
    if (self.allTasksArray.count == 0) {
        self.img.hidden = NO;
        self.doingTable.hidden = YES;
        self.segmentControl.hidden = YES;
        self.searchtxt.hidden = YES;
    } else {
        self.img.hidden = YES;
        self.doingTable.hidden = NO;
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
        return [self.doingDictionary[priority] count];
    } else {
        return self.allTasksArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"doingcell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"doingcell"];
    }

    Task *task;
    
    if (self.filterFlag && self.searchtxt.text.length > 0) {
        task = self.filteredTasks[indexPath.row];
    } else if (self.segmentControl.selectedSegmentIndex == 1) {
        NSArray *priorityLevels = @[@"High", @"Medium", @"Low"];
        NSString *priority = priorityLevels[indexPath.section];
        task = self.doingDictionary[priority][indexPath.row];
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
    
    [self.doingTable reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}


- (void)segmentValueChanged:(UISegmentedControl *)sender {
    [self.doingTable reloadData];
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
                
                [self.doingDictionary[priority] removeObject:delTask];
                [self.allTasksArray removeObject:delTask];
                
            } else if (self.segmentControl.selectedSegmentIndex == 1) {
                NSArray *priorityLevels = @[@"High", @"Medium", @"Low"];
                NSString *priority = priorityLevels[indexPath.section];
                delTask = self.doingDictionary[priority][indexPath.row];
                
                [self.doingDictionary[priority] removeObjectAtIndex:indexPath.row];
                [self.allTasksArray removeObject:delTask];
                
            } else {
                delTask = self.allTasksArray[indexPath.row];
                
                NSString *priority;
                switch (delTask.priority) {
                    case 0: priority = @"High"; break;
                    case 1: priority = @"Medium"; break;
                    case 2: priority = @"Low"; break;
                }
                
                [self.doingDictionary[priority] removeObject:delTask];
                [self.allTasksArray removeObjectAtIndex:indexPath.row];
            }
            
            [[AllTasks getInstance] saveDataForKey:@"doingDictionary" fromDictionary:self.doingDictionary];
            
            [self.doingTable deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
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
        selectedTask = self.doingDictionary[priority][indexPath.row];
    } else {
        selectedTask = self.allTasksArray[indexPath.row];
    }

    EditTaskViewController *editVC = [self.storyboard instantiateViewControllerWithIdentifier:@"EditTaskViewController"];
    editVC.task = selectedTask;
    editVC.page = 2 ;
    
    [self.navigationController pushViewController:editVC animated:YES];
}

@end
