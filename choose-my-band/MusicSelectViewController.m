//
//  MusicSelectViewController.m
//  Choose-My-Band
//
//  Created by bepid on 10/12/14.
//  Copyright (c) 2014 Siara. All rights reserved.
//

#import "MusicSelectViewController.h"

@interface MusicSelectViewController ()

@end

@implementation MusicSelectViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //_selectedMusics = [NSMutableArray new];
    _scMusics = [NSMutableDictionary new];
    self.table = [[UITableView alloc] initWithFrame:CGRectMake(10, 10, self.view.frame.size.width, self.view.frame.size.height - 101)];
    [_table setDelegate:self];
    [_table setDataSource:self];
    self.table.allowsMultipleSelection = YES;
    
    _buttonDone = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 90 , self.table.frame.size.height + 12, 80, 40)];
    [_buttonDone setTitle:@"Done" forState:UIControlStateNormal];// = @"Done";
    [_buttonDone setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //_buttonDone.titleLabel.textColor = [UIColor whiteColor];
    _buttonDone.backgroundColor = [UIColor grayColor];
    [_buttonDone addTarget:self action:@selector(buttonDoneAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.table];
    [self.view addSubview:self.buttonDone];
    [self loadScMusics];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/




-(void)loadScMusics{
    __block NSMutableArray *aux = [NSMutableArray new];
 
     
    
    SCAccount *account = [SCSoundCloud account];
    if (account == nil) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Not Logged In"
                              message:@"You must login first"
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    SCRequestResponseHandler handler;
    handler = ^(NSURLResponse *response, NSData *data, NSError *error) {
        NSError *jsonError = nil;
        NSJSONSerialization *jsonResponse = [NSJSONSerialization
                                             JSONObjectWithData:data
                                             options:0
                                             error:&jsonError];
        if (!jsonError && [jsonResponse isKindOfClass:[NSArray class]]) {
            
            for (NSDictionary *music in(NSArray *) jsonResponse) {
                Music *musicObject = [[Music alloc] init];
                
                
                //NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                // this is imporant - we set our input date format to match our input string
                // if format doesn't match you'll get nil from your string, so be careful
                /*[dateFormatter setDateFormat:@"dd-MM-yyyy"];
                NSDate *dateFromString = [[NSDate alloc] init];
                // voila!
                dateFromString = [dateFormatter dateFromString:[music objectForKey:@"created_at"]];

                [musicObject setCreatedAt:dateFromString];*/
                [musicObject setCreatedAt:(NSDate *) [music objectForKey:@"created_at"]];
                [musicObject setTitle:[music objectForKey:@"title"]];
                
                [musicObject setDuration:[music objectForKey:@"duration"]];
                [musicObject setStreamUrl:[music objectForKey:@"stream_url"]];
                [musicObject setCategory:[music objectForKey:@"genre"]];
                [musicObject setImageUrl:[music objectForKey:@"artwork_url"]];
                //adiciona no objeto musica  seu tempo ja em minutos
                [musicObject setDuration:[NSNumber numberWithFloat:([[music objectForKey:@"duration"] floatValue]/60000)]];
                [aux addObject:musicObject];
                
            }
            aux =[[NSMutableArray alloc] initWithArray:[self ordenaMusicasWithArray:aux]];
            
            [self separateInSections:aux];
            //self.scMusics = (NSMutableArray *)jsonResponse;
            //NSDictionary *j = (NSDictionary *) jsonResponse;
            //NSLog(@"%@",[j objectForKey:@"title"]);
            [self.table reloadData];
            
        
        }
    };
    
    NSString *resourceURL = @"https://api.soundcloud.com/me/tracks.json";
    [SCRequest performMethod:SCRequestMethodGET
                  onResource:[NSURL URLWithString:resourceURL]
             usingParameters:nil
                 withAccount:account
      sendingProgressHandler:nil
             responseHandler:handler];
    
    
    

}




-(NSArray *) ordenaMusicasWithArray:(NSMutableArray *)array{
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"createdAt"
                                                 ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    NSArray *sortedArray;
    sortedArray = [array sortedArrayUsingDescriptors:sortDescriptors];
    return sortedArray;
    
    
}


-(void)separateInSections:(NSMutableArray *)array{
    int numberOfSections = 0;
    //NSDate *createdAt;
    NSString *createdAt;
    NSMutableArray *aux2 = [NSMutableArray new];
    if(array.count == 1){
        Music *music = [array objectAtIndex:0];
        
        createdAt = (NSString *) music.createdAt;
        //createdAt = music.createdAt;
        [aux2 addObject:music];
        [self.scMusics setObject:aux2 forKey:createdAt];
    }
    else{
        for (int i = 0; i < array.count; i++) {
            Music *music = [array objectAtIndex:i];
            NSString *newOne = (NSString *) music.createdAt;
            
            NSString *newOneYear = [newOne substringToIndex:4];
            NSString *newOneMonth = [newOne substringWithRange:NSMakeRange(5, 2)];
            
            NSString *createdAtMonth = [createdAt substringWithRange:NSMakeRange(5, 2)];
            NSString *createdAtYear = [createdAt substringToIndex:4];
            
            if(!createdAt){
                createdAt =(NSString *) music.createdAt;
                [aux2 addObject:music];
                
            }
            
            else if(![createdAtMonth isEqual:newOneMonth] || ![createdAtYear isEqual:newOneYear]){
                
                
                [self.scMusics setObject:aux2 forKey:createdAt];
                createdAt =(NSString *) music.createdAt;
                numberOfSections++;
                aux2 = [NSMutableArray new];
                [aux2 addObject:music];
                
            }
            else{
                [aux2 addObject:music];
            }
        }
        [self.scMusics setObject:aux2 forKey:createdAt];
        
    }
    
}


#pragma mark - UITableView Delagate e DataSource

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell ;//= [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    if(cell == nil){
        
            
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            
        
    }
    
    NSArray *allKeys = [self.scMusics allKeys];
    NSMutableArray *musicsOfSection = [self.scMusics objectForKey:[allKeys objectAtIndex:indexPath.section]];
    Music *auxMusic = [musicsOfSection objectAtIndex:indexPath.row];
    
    UIImageView *albumCover = [[UIImageView alloc]initWithFrame:CGRectMake(5, 10, 80, 80)];
    [albumCover setTag:1];
    if(auxMusic.imageUrl != (NSString *) [NSNull null]){
        [albumCover setImageWithURL:[NSURL URLWithString:auxMusic.imageUrl]];
    }else{
        albumCover.image = [UIImage imageNamed:@"album-cover"];
    }
    
    
    UILabel *titleMusic = [[UILabel alloc]initWithFrame:CGRectMake(90, 10, cell.contentView.frame.size.width-95, 25)];
    
    titleMusic.text = auxMusic.title;
    
    UILabel *genreMusic = [[UILabel alloc]initWithFrame:CGRectMake(90, 10, cell.contentView.frame.size.width-95, titleMusic.frame.origin.y+titleMusic.frame.size.height + 20)];
    
    if(auxMusic.category != (NSString *) [NSNull null])
        genreMusic.text = auxMusic.category;

    
    [cell.contentView addSubview: albumCover];
    [cell.contentView addSubview:titleMusic];
    [cell.contentView addSubview:genreMusic];
    
    for (Music *selectedMusic in self.selectedMusics) {
        if([selectedMusic.title isEqualToString:auxMusic.title]){
            [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
            
        }
    }
    
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 101;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return [[self.scMusics allKeys] count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *allKeys = [self.scMusics allKeys];
    
    NSMutableArray *musicsOfSection = [self.scMusics objectForKey:[allKeys objectAtIndex: section]];
    
    return musicsOfSection.count;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSArray *allkeys = [self.scMusics allKeys];
    NSString *dateString =[NSString stringWithString: [allkeys objectAtIndex:section]];
   
    NSString *year = [dateString substringToIndex:4];
    NSString *month = [dateString substringWithRange:NSMakeRange(5, 2)];
   
    // this is imporant - we set our input date format to match our input string
    // if format doesn't match you'll get nil from your string, so be careful
    return [NSString stringWithFormat:@"%@ - %@",month,year];
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // trecho para mostrar a foto que indica que esta selecionado
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UIImageView *image =(UIImageView *) [cell viewWithTag:1];
    [image setBackgroundColor:[UIColor whiteColor]];
    
    NSArray *allKeys = [self.scMusics allKeys];
    
    Music *music = [[self.scMusics objectForKey:[allKeys objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    
    
    [self.selectedMusics addObject:music];
    
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *allKeys = [self.scMusics allKeys];
    Music *music = [[self.scMusics objectForKey:[allKeys objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    
    [self.selectedMusics removeObject:music];
}


#pragma mark - Methods for buttonDone

-(void)buttonDoneAction{
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
}





@end
