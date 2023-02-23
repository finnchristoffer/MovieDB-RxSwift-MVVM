//
//  MovieViewModel.swift
//  MovieDB-RxSwift-MVVM
//
//  Created by Finn Christoffer Kurniawan on 19/02/23.
//

import Foundation
import RxSwift
import RxCocoa

class MovieViewModel {
    
    private let network = NetworkManager()
    private let disposeBag = DisposeBag()
    
    let nowPlaying = BehaviorRelay<[Movie]>(value: [])
    let upcoming = BehaviorRelay<[Movie]>(value: [])
    let topRated = BehaviorRelay<[Movie]>(value: [])
    let movieDetails = BehaviorRelay<Movie?>(value: nil)
    let videos = BehaviorRelay<[Video]>(value: [])
    let searchedMovies = BehaviorRelay<[Movie]>(value: [])


    let nowPlayingURL = "\(ConstantString.baseURL)/now_playing?api_key=\(ConstantString.apiKey)"
    private let upcomingURL = "\(ConstantString.baseURL)/upcoming?api_key=\(ConstantString.apiKey)"
    private let topRatedURL = "\(ConstantString.baseURL)/top_rated?api_key=\(ConstantString.apiKey)"
    
    func getNowPlayingMovie() {
        network.fetchMovieDataFromAPI(url: nowPlayingURL, expecting: MovieResponse.self)
            .map { $0.results }
            .bind(to: nowPlaying)
            .disposed(by: disposeBag)
    }
    
    func getUpcomingMovie() {
        network.fetchMovieDataFromAPI(url: upcomingURL, expecting: MovieResponse.self)
            .map { $0.results}
            .bind(to: upcoming)
            .disposed(by: disposeBag)
    }
    
    func getTopRatedMovie() {
        network.fetchMovieDataFromAPI(url: topRatedURL, expecting: MovieResponse.self)
            .map { $0.results }
            .bind(to: topRated)
            .disposed(by: disposeBag)
    }
    
    func getMovieDetails(movieID: Int) {
        let url = "\(ConstantString.baseURL)\(movieID)?api_key=\(ConstantString.apiKey)"
        network.fetchMovieDataFromAPI(url: url, expecting: Movie.self)
            .bind(to: movieDetails)
            .disposed(by: disposeBag)
    }
    
    func getMovieVideos(movieID: Int) {
        let url = "\(ConstantString.baseURL)\(movieID)/videos?api_key=\(ConstantString.apiKey)"
        network.fetchMovieDataFromAPI(url: url, expecting: VideoResponse.self)
            .map { $0.results }
            .bind(to: videos)
            .disposed(by: disposeBag)
    }
    
    func getMovieDataFromSearch(searchText: String) {
        let url = "https://api.themoviedb.org/3/search/movie?api_key=d8bf466e0e794e7f8499748928d9f491&language=en-US&query=\(searchText)"
        network.fetchMovieDataFromAPI(url: url, expecting: MovieResponse.self)
            .map { $0.results }
            .bind(to: searchedMovies)
            .disposed(by: disposeBag)
    }
    
    func arrangeMovieGenresInHorizontalText() -> Observable<String> {
        return movieDetails
            .map { movie in
                guard let genres = movie?.genres else {
                    return ""
                }
                return genres.map { $0.name }.joined(separator: ", ")
            }
    }
    
}

