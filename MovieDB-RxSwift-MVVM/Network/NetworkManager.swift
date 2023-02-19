//
//  NetworkManager.swift
//  MovieDB-RxSwift-MVVM
//
//  Created by Finn Christoffer Kurniawan on 18/02/23.
//


import Foundation
import RxSwift

class NetworkManager {
    func fetchMovieDataFromAPI<T: Codable>(url: String, expecting: T.Type) -> Observable<T> {
        guard let url = URL(string: url) else { return Observable.error(NetworkError.invalidURL) }

        return URLSession.shared.rx.data(request: URLRequest(url: url))
            .map { data -> T in
                let decodedData = try JSONDecoder().decode(expecting, from: data)
                return decodedData
            }
            .asObservable()
    }
}

enum NetworkError: Error {
    case invalidURL
}
