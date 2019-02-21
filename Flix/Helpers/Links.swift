//
//  Links.swift
//  Flix
//
//  Created by Bahti on 2/21/19.
//  Copyright © 2019 Bahti. All rights reserved.
//

import Foundation

class Links {
    
    
    //https://api.themoviedb.org/3/genre/movie/list?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed&language=en-US
    
    private let allGenre = "https://api.themoviedb.org/3/genre/movie/list?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed&language=en-US"
    
    private let specificGenre = "https://api.themoviedb.org/3/discover/movie?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed&language=en-US&page=1&with_genres="
    
    private let upcoming = "https://api.themoviedb.org/3/movie/upcoming?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed&language=en-US&page=1"
    
    private let popular = "https://api.themoviedb.org/3/movie/popular?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed&language=en-US&page=1"
    
    private let baseUrl = "https://image.tmdb.org/t/p/w185"

    
    
    
    
    init() {
        
    }
    
    func getAllGenreURL() -> String {
        return allGenre
    }
    
    func getSpecificGenreURL() -> String {
        return specificGenre
    }
    
    func getUpComingURL() -> String {
        return upcoming
    }
    
    
    func getPopularURL() -> String {
        return popular
    }
    
    func getBaseURL() -> String {
        return baseUrl
    }
}
