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
    
    var movies = [[String:Any]]()
    
    init(genre type: String, genreIndex tag: Int) {
        self.genre = type
    }
    
    func assignMovies(listOfMovies m : [[String:Any]]) {
        self.movies = m
    }
    
    func getGenre() -> String {
        return genre
    }
    
    
    func getMovies() -> [[String:Any]] {
        return movies
    }
}
