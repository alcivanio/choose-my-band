//
//  Crud.m
//  choose-my-band
//
//  Created by Bruno Lima on 01/12/14.
//  Copyright (c) 2014 Siara. All rights reserved.
//

#import "Crud.h"

@implementation Crud


- (instancetype)initCRUDWithScId:(NSString *)scId
{
    self = [super init];
    if (self) {
        PFQuery *query = [PFQuery queryWithClassName:@"User"];
        [query selectKeys:@[ @"objectId",@"updatedAt",@"scId"]];
        [query whereKey:@"scId" equalTo: scId];
        
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
            self.currentUser = [objects objectAtIndex: 0];
        }];
    }
    return self;
}

// metodo que retorna se uma nova versao do currentUser no banco
-(BOOL)existNewVersion{
	__block BOOL newVersion = NO;
	PFQuery *query = [PFQuery queryWithClassName:@"User"];
	[query selectKeys:@[ @"updatedAt"]];
	[query whereKey:@"scId" equalTo: self.currentUser[@"scId"]];
	[query   findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
        PFObject *object = [objects objectAtIndex:0];
        if(![self.currentUser[@"updatedAt"] isEqualToDate:object[@"updatedAt"]]){
			newVersion = YES;
		}
	}];
	return newVersion;
    
}

//adiciona um novo album
-(void)addAlbumWithTitle:(NSString *)nomeAlbum
                    type:(NSString *)albumType
                coverUrl:(NSString *)cover{

	PFObject *newAlbum = [PFObject objectWithClassName:@"Album"];
	
	newAlbum[@"title"] = nomeAlbum;
	newAlbum[@"albumType"]= albumType;
	newAlbum[@"coverUrl"]=cover;
	newAlbum[@"owner"]=self.currentUser;//so iguala um ao outro porque e uma relacao de um para um
	// parte que e para adicionar o album no user 	e atualizar o user
    
	[self  updateRelationUserAtColumnNamed:@"albuns" withObject:newAlbum];
	
    
}

//Supondo que um PFObject com o usuario corrente ja tem os dados do user guardado
//so funciona para as colunas que sao RELATION

-(void)updateRelationUserAtColumnNamed:(NSString *)name
                            withObject: (PFObject *)object{
	
	// FAZ A ATUALIZA«AO NO BANCO
	
    //__block PFObject *object1 = (PFObject *)object;
	   
	[object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            PFRelation  *relation=[self.currentUser relationForKey:name];
            [relation addObject:object];
            [self.currentUser saveInBackground];
        }
    }];
    
    
}

// aidmitindo que o user ja tem uma conta no nosso app
-(void) addFollowerWithscId:(NSString *)scId{
    
    PFQuery *query = [PFQuery queryWithClassName:@"User"];
    [query selectKeys:@[@"objectId"]];
    [query whereKey:@"scId" equalTo: scId];
    [self updateRelationUserAtColumnNamed:@"followers" withObject:[[query findObjects] objectAtIndex:0]];
    
}


-(void)addStatusWithStatusText:(NSString *)text music:(PFObject *)musicObject{
    
    PFObject *newStatus = [PFObject objectWithClassName:@"Status"];
    newStatus[@"statusText"]=text;
    newStatus[@"owner"]=self.currentUser;
    newStatus[@"music"]=musicObject;
    [self  updateRelationUserAtColumnNamed:@"status" withObject:newStatus];
}


-(void)addMusicWithImageUrl:(NSString *)imageUrl StreamUrl:(NSString *)streamUrl Title:(NSString *)title andAlbum:(PFObject *)album{
    __block PFObject *music = [PFObject objectWithClassName:@"Music"];
    music[@"imageUrl"] = imageUrl;
    music[@"streamUrl"] = streamUrl;
    music[@"title"] = title;
    music[@"album"] = album;

    [music saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            PFRelation  *relation=[album relationForKey:@"musics"];
            [relation addObject:music];
            [album saveInBackground];
            
            
        }
    }];
    
    
    
    
    
}


-(void)addCommentAtObject:(PFObject *)object andContent:(NSString *) content{
    PFObject *comment = [PFObject objectWithClassName:@"Comment"];
    comment[@"content"] = content;
    comment[@"owner"] = self.currentUser;
    
    [comment saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            PFRelation  *relation=[object relationForKey:@"comments"];
            [relation addObject: comment];
            [object saveInBackground];
        }
    }];
    
    
    
}


//calcula o numero de status que serao buscados em cada excecucao
-(int)numberOfStatusForFollower{
    __block int numberOfFollowers;
    
//    PFQuery *queryUser = [PFQuery queryWithClassName:@"User"];
//    [queryUser whereKey:@"scId" equalTo:@"112661768"];
//    [queryUser selectKeys:@[@"objectId",@"followers"]];
//    
//    PFObject *object = [queryUser getFirstObject];
    PFRelation *relationFollowers = [self.currentUser relationForKey:@"followers"];
    PFQuery *follower = [relationFollowers query];
    
    //[follower selectKeys:@[@"objectId"]];
    
    [follower countObjectsInBackgroundWithBlock:^(int count, NSError *error) {
        numberOfFollowers = count;
    }];
     
     
     return 5/numberOfFollowers  >=1 ? 5/numberOfFollowers : 1;
}
     
     
     //pega todos os feeds dos users que tu segue
     
-(NSMutableArray *)getAllStatus{
         
         __block NSMutableArray *allStatus = [NSMutableArray new];
         
         int amount = [self numberOfStatusForFollower];
//         PFQuery *queryUser = [PFQuery queryWithClassName:@"User"];
//         
//         [queryUser whereKey:@"scId" equalTo:@"112661768"];
//         
//         [queryUser selectKeys:@[@"objectId",@"followers"]];
    
//         PFObject *object = [queryUser getFirstObject];
    
         PFRelation *relationFollowers = [self.currentUser relationForKey:@"followers"];
         
         PFQuery *follower = [relationFollowers query];
         
         //[follower selectKeys:@[@"objectId"]];
         
         [follower findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
             for (PFObject *object in objects) {
                 
                 [allStatus addObjectsFromArray:[self getStatusFromUserWithObject:object amount:amount andSkip:0]];
             }
         }];
         
         return allStatus;
         
     }
     
     // esse skip pode ser imcrementado sempre que esse metodo e executado
     
-(NSMutableArray *)getStatusFromUserWithObject:(PFObject *)object amount:(int)amount  andSkip: (int)skip{
         __block NSMutableArray *lastStatus = [NSMutableArray new];
         
         PFRelation *relationStatus = [object relationForKey:@"status"];
         
         PFQuery *query = [relationStatus query];
         [query orderByDescending:@"createdAt"];//em ordem decrescente de postagem
         
        // query.limit = amount;
         query.skip = skip;
         [lastStatus addObjectsFromArray:[query findObjects]];
    
        return lastStatus;
    
}



-(void)addLikeAtObject:(PFObject *)object{
    PFRelation *relation = [object relationForKey:@"likes"];
    [relation addObject:self.currentUser];
    
    [object saveInBackground];
   
    
}



-(NSArray *)searchMusicsForTitle:(NSString *)title{
	__block NSMutableArray *searchResults = [NSMutableArray new];
	PFQuery  *search = [PFQuery queryWithClassName:@"Music"];
	[search whereKey:@"title" hasPrefix:title];
	[search orderByDescending:@"numberOfLikes"];
	search.limit = 50;
	[search findObjectsInBackgroundWithBlock:^(NSArray *musics, NSError *error){
		[searchResults addObjectsFromArray:musics];
	}];
	
	return searchResults;
}


@end
