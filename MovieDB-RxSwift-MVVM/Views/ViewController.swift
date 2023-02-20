//
//  ViewController.swift
//  MovieDB-RxSwift-MVVM
//
//  Created by Finn Christoffer Kurniawan on 18/02/23.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    
    // MARK: - Properties
    
    let vm = MovieViewModel()
    private let disposeBag = DisposeBag()
    
    lazy var nowPlayingLabel = reuseableTitleLabel(text: "Now Playing")
    lazy var upcomingLabel = reuseableTitleLabel(text: "Upcoming")
    lazy var topRatedLabel = reuseableTitleLabel(text: "Top Rated")
    
    lazy var collectionView1 = reuseableCollectionView(identifier: "cell1")
    lazy var collectionView2 = reuseableCollectionView(identifier: "cell2")
    lazy var collectionView3 = reuseableCollectionView(identifier: "cell3")
    
    private lazy var text: UITextView = {
        let text = UITextView()
        text.text = "Hello"
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.isScrollEnabled = true
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()
    
    private lazy var contentView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        setupViews()
        setupConstraints()
        vm.getNowPlayingMovie()
        vm.getUpcomingMovie()
        vm.getTopRatedMovie()
        bindVM()
        selectedItem()
        title = "Movie"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
    }
    // MARK: - Helpers
    
    private func reuseableTitleLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    private func reuseableCollectionView(identifier: String) -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 150, height: 220)
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.showsHorizontalScrollIndicator = false
        cv.register(CustomCell.self, forCellWithReuseIdentifier: identifier)
        return cv
    }
    
    private func navigateToAnotherViewController(movieID: Int) {
        let movieDetailsView = MovieDetailsViewController()
        movieDetailsView.movieID = movieID
        movieDetailsView.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(movieDetailsView, animated: true)
    }
    
    private func setupViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addArrangedSubview(text)
        contentView.addArrangedSubview(nowPlayingLabel)
        contentView.addArrangedSubview(collectionView1)
        contentView.addArrangedSubview(upcomingLabel)
        contentView.addArrangedSubview(collectionView2)
        contentView.addArrangedSubview(topRatedLabel)
        contentView.addArrangedSubview(collectionView3)
    }
    
    private func setupConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
            scrollView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            nowPlayingLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            
            collectionView1.topAnchor.constraint(equalTo: nowPlayingLabel.bottomAnchor),
            collectionView1.heightAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.65),
            
            collectionView2.topAnchor.constraint(equalTo: upcomingLabel.bottomAnchor),
            collectionView2.heightAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.65),
            
            collectionView3.topAnchor.constraint(equalTo: topRatedLabel.bottomAnchor),
            collectionView3.heightAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.65),
        ])
    }
    
    private func bindVM() {
        vm.nowPlaying
            .bind(to: collectionView1.rx.items(cellIdentifier: "cell1", cellType: CustomCell.self)) { _, movie, cell in
                let stringURL = "https://image.tmdb.org/t/p/w1280/\(movie.poster ?? "")"
                if let url = URL(string: stringURL) {
                    cell.moviePoster.downloadImage(from: url)
                }
                cell.movieTitle.text = movie.title
            }
            .disposed(by: disposeBag)
        
        vm.upcoming
            .bind(to: collectionView2.rx.items(cellIdentifier: "cell2", cellType: CustomCell.self)) { _, movie, cell in
                let stringURL = "https://image.tmdb.org/t/p/w1280/\(movie.poster ?? "")"
                if let url = URL(string: stringURL) {
                    cell.moviePoster.downloadImage(from: url)
                }
                cell.movieTitle.text = movie.title
            }
            .disposed(by: disposeBag)
        
        vm.topRated
            .bind(to: collectionView3.rx.items(cellIdentifier: "cell3", cellType: CustomCell.self)) { _, movie, cell in
                let stringURL = "https://image.tmdb.org/t/p/w1280/\(movie.poster ?? "")"
                if let url = URL(string: stringURL) {
                    cell.moviePoster.downloadImage(from: url)
                }
                cell.movieTitle.text = movie.title
            }
            .disposed(by: disposeBag)
        
    }
    
    private func selectedItem() {
        
        collectionView1.rx.itemSelected
            .map{ [weak self] indexPath in
                return self?.vm.nowPlaying.value[indexPath.row].id ?? 0
            }
            .subscribe(onNext: {[weak self] movieID in
                self?.navigateToAnotherViewController(movieID:movieID)
            })
            .disposed(by: disposeBag)
        
        collectionView2.rx.itemSelected
            .map{ [weak self] indexPath in
                return self?.vm.upcoming.value[indexPath.row].id ?? 0
            }
            .subscribe(onNext: {[weak self] movieID in
                self?.navigateToAnotherViewController(movieID:movieID)
            })
            .disposed(by: disposeBag)
        
        collectionView3.rx.itemSelected
            .map{ [weak self] indexPath in
                return self?.vm.topRated.value[indexPath.row].id ?? 0
            }
            .subscribe(onNext: {[weak self] movieID in
                self?.navigateToAnotherViewController(movieID:movieID)
            })
            .disposed(by: disposeBag)
        
    }
    
    
}
