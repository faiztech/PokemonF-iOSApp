//
//  CoreDataHelper.swift
//  Pokemon F
//
//  Created by Mohammed Faizuddin on 10/3/17.
//  Copyright © 2017 Faiz Tech. All rights reserved.
//

import Foundation
import UIKit
import CoreData


func addAllPokemon() {
   
   createPokemon(name: "Mew", imageName: "mew")
   createPokemon(name: "Meowth", imageName: "meowth")
   createPokemon(name: "Mankey", imageName: "mankey")
   createPokemon(name: "Pidgey", imageName: "pidgey")
   createPokemon(name: "Pikachu", imageName: "pikachu")
   createPokemon(name: "Rattata", imageName: "rattata")
   createPokemon(name: "Eevee", imageName: "eevee")
   createPokemon(name: "Snorlax", imageName: "snorlax")
   createPokemon(name: "Weedle", imageName: "weedle")
   createPokemon(name: "Zubat", imageName: "zubat")
   
   (UIApplication.shared.delegate as! AppDelegate).saveContext()
}

func createPokemon(name: String, imageName: String) {
   
   let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
   
   
   let pokemon = Pokemon(context: context)
   
   pokemon.name = name
   pokemon.imageName = imageName
   
   
}


func getAllPokemon() -> [Pokemon]
{
   
   let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
   
   do{
      let pokemons = try context.fetch(Pokemon.fetchRequest())as! [Pokemon]
      
      if pokemons.count == 0
      {
         addAllPokemon()
         return getAllPokemon()
      }
      return pokemons
   } catch{}
   
   return []
}


//
func getAllCaught() -> [Pokemon]
{
   let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
   
   let fetchRequest = Pokemon.fetchRequest() as NSFetchRequest<Pokemon>
   
   //filtering pokemons using .predicate
   fetchRequest.predicate = NSPredicate(format: "caught == %@", true as CVarArg)
   
   do{
      
      let pokemons = try context.fetch(fetchRequest)
      return pokemons
      
   } catch{}
   
   return []
   
}


//
func getAllUncaught() -> [Pokemon] {
   let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
   
   let fetchRequest = Pokemon.fetchRequest() as NSFetchRequest<Pokemon>
   
   //filtering pokemons using .predicate
   fetchRequest.predicate = NSPredicate(format: "caught == %@", false as CVarArg)
   
   do{
      
      let pokemons = try context.fetch(fetchRequest)
      return pokemons
      
   } catch{}
   
   return []
   
}
