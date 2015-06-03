//
//  ProfileFollowersCollectionController.m
//  choose-my-band
//
//  Created by Alcivanio on 29/11/14.
//  Copyright (c) 2014 Siara. All rights reserved.
//

#import "ProfileViewController.h"

#import "ProfileFollowersCollectionController.h"

@interface ProfileFollowersCollectionController ()

@end

@implementation ProfileFollowersCollectionController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (instancetype)initWithProfileView:(UIViewController *)prof
{
    self = [super init];
    if (self) {
        self.controllerDados = prof;
        }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.collectionFollowers = [NSMutableArray new];
   // self.bottomBar = ((ProfileViewController *) self.controllerDados).bottomBar;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark Data source of collection view
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    //new way
    /*NSInteger numberOfItems = [self.collectionFollowers count];
    ProfileViewController *profile = (ProfileViewController *)self.controllerDados;
    if ([profile.generalSingletonReference.dataClass.scID isEqualToString:profile.user.scId]) {
        numberOfItems++;
    }
    
    return numberOfItems;*/
    
    return [self.collectionFollowers count];
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"celulaFollowers" forIndexPath:indexPath];
    CGRect frameOfImage = CGRectMake(0, 0, 64, 64);
    UIImageView *profileImageOnCell = [[UIImageView alloc] initWithFrame:frameOfImage];
    [profileImageOnCell setContentMode:UIViewContentModeScaleAspectFill];
    [profileImageOnCell.layer setCornerRadius:5];
    [profileImageOnCell setClipsToBounds:YES];
    [profileImageOnCell setBackgroundColor:[UIColor blackColor]];
    
    //old way
    User  *userFollower = [self.collectionFollowers objectAtIndex:indexPath.row];
    [profileImageOnCell setImageWithURL:[NSURL URLWithString:userFollower.profilePictureUrl]];
    [cell.contentView addSubview:profileImageOnCell];
    
    
    //new way
    /*
    ProfileViewController *profile = (ProfileViewController *)self.controllerDados;
    
    if ([profile.generalSingletonReference.dataClass.scID isEqualToString:profile.user.scId]) {
        if (indexPath.row == 0) {
            [profileImageOnCell setImage:[UIImage imageNamed:@"plus-album"]];
        }
        else if([profile.user.followers count] > 0){
            User  *userFollower = [self.collectionFollowers objectAtIndex:indexPath.row-1];
            [profileImageOnCell setImageWithURL:[NSURL URLWithString:userFollower.profilePictureUrl]];
        }
    }else{
        User  *userFollower = [self.collectionFollowers objectAtIndex:indexPath.row];
        [profileImageOnCell setImageWithURL:[NSURL URLWithString:userFollower.profilePictureUrl]];
    }
    [cell.contentView addSubview:profileImageOnCell];
    */
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    User *followerSelected = [self.collectionFollowers objectAtIndex:indexPath.row];
    
    ProfileViewController *profile = (ProfileViewController *)self.controllerDados;
    
    UIStoryboard *stBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ProfileViewController *rvc = (ProfileViewController *)[stBoard instantiateViewControllerWithIdentifier:@"ProfileStoryboard"];
    rvc.userId = followerSelected.scId;
    rvc.bottomBar = self.bottomBar;
    [profile.navigationController pushViewController:rvc animated:YES];
    
    
    
    //new way
    /*
    ProfileViewController *profile = (ProfileViewController *)self.controllerDados;

    User *followerSelected;
    if ([profile.generalSingletonReference.dataClass.scID isEqualToString:profile.user.scId]) {
        if (indexPath.row == 0) {
            //executa a tela de buscar novo amigo
        }
        else{
            followerSelected = [self.collectionFollowers objectAtIndex:indexPath.row-1];
        }
        
    }else{
        followerSelected = [self.collectionFollowers objectAtIndex:indexPath.row];
    }
    UIStoryboard *stBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ProfileViewController *rvc = (ProfileViewController *)[stBoard instantiateViewControllerWithIdentifier:@"ProfileStoryboard"];
    rvc.userId = followerSelected.scId;
    rvc.bottomBar = self.bottomBar;
    [profile.navigationController pushViewController:rvc animated:YES];
    */

}

@end
































