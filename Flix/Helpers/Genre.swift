//
//  Genre.swift
//  Flix
//
//  Created by Bahti on 2/21/19.
//  Copyright © 2019 Bahti. All rights reserved.
//

import Foundation

class Genre {
    
    var genre:String!
    var index:Int!
    var id:Int!
    
    var movies = [[String:Any]]()
    
    init(genre type: String, genreIndex tag: Int, genreID num: Int) {
        self.genre = type
        self.id = num
    }
    
    func assignMovies(listOfMovies m : [[String:Any]]) {
        self.movies = m
    }
    
    func getGenre() -> String {
        return genre
    }
    
    func getID() -> Int {
        return id
    }
    
    func getMovies() -> [[String:Any]] {
        return movies
    }
}
