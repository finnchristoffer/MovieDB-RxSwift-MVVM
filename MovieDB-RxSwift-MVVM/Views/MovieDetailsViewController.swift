//
//  MovieDetailsViewController.swift
//  MovieDB-RxSwift-MVVM
//
//  Created by Finn Christoffer Kurniawan on 19/02/23.
//

import UIKit
import RxSwift
import RxCocoa

class MovieDetailsViewController: UIViewController {
    
    // MARK: - Properties
    
    var movieID: Int = 0
    private var vm = MovieViewModel()
    private let disposeBag = DisposeBag()
    
    private lazy var topStackView = reusableStackView(spacing: 25)
    private lazy var middleStackView = reusableStackView(spacing: 10)
    private lazy var bottomStackView = reusableStackView(spacing: 10)
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.spacing = 16
        stack.axis = .vertical
        stack.isLayoutMarginsRelativeArrangement = true
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
        return stack
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.isScrollEnabled = true
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "videoCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.isScrollEnabled = false
        return tableView
    }()
    
    private lazy var movieTitle: UILabel = {
        let title = UILabel()
        title.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        title.textColor = UIColor.primaryColor
        title.textAlignment = .center
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    private lazy var movieBackdrop: UIImageView = {
        let image = UIImageView()
        image.layer.masksToBounds = true
        image.layer.cornerRadius = 10
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private lazy var movieReleaseDate: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var movieRuntime: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var movieGenre: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var movieOverview: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .label
        label.textAlignment = .justified
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var videosTitleText: UILabel = {
        let label = UILabel()
        label.text = "Videos"
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemBackground
        
        setupViews()
        setupConstraints()
        bindVM()
        bindTableView()
        vm.getMovieDetails(movieID: self.movieID)
        vm.getMovieVideos(movieID: self.movieID)
        
        navigationItem.largeTitleDisplayMode = .never
    }
    // MARK: - Helpers
    
    private func setupViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        stackView.addArrangedSubview(topStackView)
        topStackView.addArrangedSubview(movieTitle)
        topStackView.addArrangedSubview(movieBackdrop)
        stackView.addArrangedSubview(middleStackView)
        middleStackView.addArrangedSubview(movieReleaseDate)
        middleStackView.addArrangedSubview(movieRuntime)
        middleStackView.addArrangedSubview(movieGenre)
        stackView.addArrangedSubview(movieOverview)
        stackView.addArrangedSubview(bottomStackView)
        bottomStackView.addArrangedSubview(videosTitleText)
        bottomStackView.addArrangedSubview(tableView)
    }
    
    private func getTableViewHeightMultiplier() -> CGFloat {
        if vm.videos.value.count > 2 && vm.videos.value.count < 5 {
            return 0.3
        } else if vm.videos.value.count == 5 {
            return 0.6
        } else {
            return 0.5
        }
    }
    
    private func reusableStackView(spacing: CGFloat) -> UIStackView {
        let stack = UIStackView()
        stack.spacing = spacing
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }
    
    private func setupConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        
        scrollView.anchor(top: safeArea.topAnchor, bottom: safeArea.bottomAnchor, leading: safeArea.leadingAnchor, trailing: safeArea.trailingAnchor)
        scrollView.centerX(inView: safeArea)
        scrollView.setDimensions(width: safeArea.widthAnchor)
        
        
        stackView.anchor(top: scrollView.topAnchor, bottom: scrollView.bottomAnchor, leading: scrollView.leadingAnchor, trailing: scrollView.trailingAnchor)
        stackView.setDimensions(width: safeArea.widthAnchor)
        
        movieTitle.anchor(top: topStackView.topAnchor)
        movieBackdrop.setDimensions(height: topStackView.widthAnchor, heightMultiplier: 0.57)
        movieReleaseDate.anchor(top: middleStackView.topAnchor)
        movieRuntime.anchor(top: movieReleaseDate.bottomAnchor)
        movieGenre.anchor(top: movieRuntime.bottomAnchor)
        tableView.setDimensions(height: stackView.heightAnchor, heightMultiplier: getTableViewHeightMultiplier())
        
    }
    
    private func bindVM() {
        vm.movieDetails
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] movieDetails in
                self?.movieTitle.text = movieDetails?.title
                self?.movieBackdrop.downloadImage(from: URL(string: "https://image.tmdb.org/t/p/w1000_and_h563_face/\(movieDetails?.backdrop ?? "")")!)
                self?.movieReleaseDate.text = movieDetails?.releaseDate
                self?.movieRuntime.text = "Runtime: \(movieDetails?.runtime ?? 0) minutes"
                self?.movieOverview.text = movieDetails?.overview
            })
            .disposed(by: disposeBag)
        
        vm.arrangeMovieGenresInHorizontalText()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] genres in
                self?.movieGenre.text = "Genre: \(genres)"
            })
            .disposed(by: disposeBag)
    }
    
    
    private func bindTableView() {
        vm.videos
            .asObservable()
            .bind(to: tableView.rx.items(cellIdentifier: "videoCell", cellType: UITableViewCell.self)) { row, element, cell in
                cell.textLabel?.text = element.name
                cell.accessoryView = UIImageView(image: UIImage(systemName: "play.rectangle.fill"))
            }
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .flatMapLatest { indexPath -> Observable<URL?> in
                self.vm.videos.map { $0[indexPath.row] }
                    .flatMap { video in
                        let videoURL = URL(string: "https://www.youtube.com/watch?v=\(video.key)")
                        return Observable.just(videoURL)
                    }
            }
            .subscribe(onNext: { url in
                if let url = url {
                    UIApplication.shared.open(url)
                }
            })
            .disposed(by: disposeBag)
    }
    
    
    
}
