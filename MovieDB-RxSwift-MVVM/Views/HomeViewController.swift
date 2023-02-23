//
//  ViewController.swift
//  MovieDB-RxSwift-MVVM
//
//  Created by Finn Christoffer Kurniawan on 18/02/23.
//

import UIKit
import RxSwift
import RxCocoa

class HomeViewController: UIViewController {
    
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
        view.spacing = 5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemBackground
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
        label.textColor = UIColor.init { (traitCollection: UITraitCollection) -> UIColor in
            if traitCollection.userInterfaceStyle == .dark {
                return UIColor.white
            } else {
                return UIColor.black
            }
        }
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    private func reuseableCollectionView(identifier: String) -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 150, height: 250)
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
        
        scrollView.anchor(top: safeArea.topAnchor, bottom: safeArea.bottomAnchor, leading: safeArea.leadingAnchor, trailing: safeArea.trailingAnchor, paddingLeft: 16)
        
        contentView.anchor(top: scrollView.topAnchor, bottom: scrollView.bottomAnchor, leading: scrollView.leadingAnchor, trailing: scrollView.trailingAnchor)
        contentView.setDimensions(width: scrollView.widthAnchor)
        
        nowPlayingLabel.anchor(top: contentView.topAnchor)
        
        collectionView1.anchor(top: nowPlayingLabel.bottomAnchor, paddingTop: 10)
        collectionView1.setDimensions(height: contentView.widthAnchor, heightMultiplier: 0.65)

        collectionView2.anchor(top: upcomingLabel.bottomAnchor, paddingTop: 10)
        collectionView2.setDimensions(height: contentView.widthAnchor, heightMultiplier: 0.65)

        collectionView3.anchor(top: topRatedLabel.bottomAnchor, paddingTop: 10)
        collectionView3.setDimensions(height: contentView.widthAnchor, heightMultiplier: 0.65)

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
