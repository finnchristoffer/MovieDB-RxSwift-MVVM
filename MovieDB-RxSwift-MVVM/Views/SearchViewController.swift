//
//  SearchViewController.swift
//  MovieDB-RxSwift-MVVM
//
//  Created by Finn Christoffer Kurniawan on 18/02/23.
//

import UIKit
import RxSwift
import RxCocoa

class SearchViewController: UIViewController {
    
    // MARK: - Properties
    
    private let vm = MovieViewModel()
    private let disposeBag = DisposeBag()
    
    private lazy var searchController: UISearchController = {
       let search = UISearchController(searchResultsController: nil)
        definesPresentationContext = true
        return search
    }()
    
    private lazy var tableView: UITableView = {
       let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(UITableViewCell.self, forCellReuseIdentifier: "searchCell")
        return table
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        setupConstraints()
        setupBindings()
    }
    // MARK: - Helpers
    
    private func setupViews() {
        navigationItem.searchController = searchController
        title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        view.addSubview(tableView)
    }
    
    private func setupConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            tableView.heightAnchor.constraint(equalTo: safeArea.heightAnchor),
        ])
    }
    
    private func setupBindings() {
            searchController.searchBar.rx.text.orEmpty
                .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
                .distinctUntilChanged()
                .subscribe(onNext: { [weak self] searchText in
                    if !searchText.isEmpty {
                        self?.vm.getMovieDataFromSearch(searchText: searchText)
                    } else {
                        self?.vm.searchedMovies.accept([])
                    }
                })
                .disposed(by: disposeBag)
            
            vm.searchedMovies
            .observe(on: MainScheduler.instance)
                .bind(to: tableView.rx.items(cellIdentifier: "searchCell", cellType: UITableViewCell.self)) { index, movie, cell in
                    cell.textLabel?.text = movie.title
                }
                .disposed(by: disposeBag)
            
            tableView.rx.modelSelected(Movie.self)
                .subscribe(onNext: { [weak self] movie in
                    let movieDetailsView = MovieDetailsViewController()
                    movieDetailsView.movieID = movie.id
                    movieDetailsView.hidesBottomBarWhenPushed = true
                    self?.navigationController?.pushViewController(movieDetailsView, animated: true)
                })
                .disposed(by: disposeBag)
        }
}
