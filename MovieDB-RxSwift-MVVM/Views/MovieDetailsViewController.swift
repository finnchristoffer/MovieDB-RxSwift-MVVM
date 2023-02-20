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
    
    lazy var topStackView = reusableStackView(spacing: 5)
    lazy var middleStackView = reusableStackView(spacing: 0)
    lazy var bottomStackView = reusableStackView(spacing: 0)
    
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
        return tableView
    }()
    
    private lazy var movieTitle: UILabel = {
        let title = UILabel()
        title.font = UIFont.systemFont(ofSize: 22, weight: .bold)
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
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var movieGenre: UILabel = {
        let label = UILabel()
        label.text = "Genre: Romance, Animation, Drama"
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var movieOverview: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
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
        view.backgroundColor = UIColor.white
        
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
        
        NSLayoutConstraint.activate([
            scrollView.widthAnchor.constraint(equalTo: safeArea.widthAnchor),
            scrollView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            scrollView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 1),
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            
            movieTitle.topAnchor.constraint(equalTo: topStackView.topAnchor),
            movieBackdrop.heightAnchor.constraint(equalTo: topStackView.widthAnchor, multiplier: 0.57),
            movieReleaseDate.topAnchor.constraint(equalTo: middleStackView.topAnchor),
            movieRuntime.topAnchor.constraint(equalTo: movieReleaseDate.bottomAnchor),
            movieGenre.topAnchor.constraint(equalTo: movieRuntime.bottomAnchor),
            tableView.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: getTableViewHeightMultiplier()),
        ])
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
                self?.movieGenre.text = genres
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
