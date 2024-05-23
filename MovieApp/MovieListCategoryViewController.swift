import UIKit
import PureLayout
import MovieAppData


class MovieListCategoryViewController: UIViewController {

    private var tableView: UITableView!
    private let movieUseCase = MovieUseCase()
    public var router: AppRouterProtocol!
    
    private var titleLabel: UILabel!
    private var titleContainer: UIView!

    // Inicijalizacija s Routerom
    init(router: AppRouterProtocol) {
        super.init(nibName: nil, bundle: nil)
        self.router = router
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildViews()        
    }

    private func buildViews() {
        createViews()
        styleViews()
        defineLayout()
    }
    
    @objc func handleGoToMovieDetailsController(movieId: Int) {
        router.navigateToMovieDetails(movieId: movieId)
    }
    
}

extension MovieListCategoryViewController: UITableViewDataSource {

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3 // Tri sekcije
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 // Jedan redak po sekciji
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SectionCell", for: indexPath) as! SectionTableViewCell
        var movies: [MovieModel] = []

        switch indexPath.section {
        case 0:
            cell.titleLabel.text = "What's Popular"
            movies = movieUseCase.popularMovies
        case 1:
            cell.titleLabel.text = "Free To Watch"
            movies = movieUseCase.freeToWatchMovies
        case 2:
            cell.titleLabel.text = "Trending"
            movies = movieUseCase.trendingMovies
        default:
            break
        }

        cell.configure(with: movies)
        
        cell.onMovieSelected = { [weak self] movieId in
            self?.handleGoToMovieDetailsController(movieId: movieId)
        }
        
        return cell
    }
    
}

extension MovieListCategoryViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
}

extension MovieListCategoryViewController {

    func createViews() {
        tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(SectionTableViewCell.self, forCellReuseIdentifier: "SectionCell")
        view.addSubview(tableView)
        
        titleLabel = UILabel()
        titleLabel.text = "Movie List"
        
        titleContainer = UIView()
        titleContainer.addSubview(titleLabel)
    }

    func styleViews() {
        view.backgroundColor = .white
        
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.textAlignment = .center
    }

    func defineLayout() {
        tableView.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), excludingEdge: .leading)
        tableView.autoPinEdge(toSuperviewEdge: .leading, withInset: 15)
        
        titleLabel.autoPinEdge(toSuperviewEdge: .bottom, withInset: 20)
        titleLabel.autoPinEdge(toSuperviewEdge: .leading, withInset: 140)
        
        self.navigationItem.titleView = titleContainer
        
    }
    

}

class SectionTableViewCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {

    var titleLabel: UILabel!
    private var collectionView: UICollectionView!
    private var movies: [MovieModel] = []
    
    var onMovieSelected: ((Int) -> Void)?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        styleViews()
        defineLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupViews() {
        titleLabel = UILabel()

        contentView.addSubview(titleLabel)

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: "MovieCell")
        contentView.addSubview(collectionView)
        

    }
    

    func styleViews() {
        titleLabel.textColor = .black
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
    }

    func defineLayout() {
        titleLabel.autoPinEdge(toSuperviewEdge: .top, withInset: 8)

        collectionView.autoPinEdge(.top, to: .bottom, of: titleLabel, withOffset: 8)
        collectionView.autoPinEdge(toSuperviewEdge: .leading)
        collectionView.autoPinEdge(toSuperviewEdge: .trailing)
        collectionView.autoPinEdge(toSuperviewEdge: .bottom)
    }

    func configure(with movies: [MovieModel]) {
        self.movies = movies
        collectionView.reloadData()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as! MovieCollectionViewCell
        let movie = movies[indexPath.item]
    
        cell.configure(with: movie)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth: CGFloat = 125
        return CGSize(width: itemWidth, height: itemWidth * 1.5) // Omjer 3:2
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedMovieId = movies[indexPath.item].id
        print("Cell \(indexPath.row + 1) with movieId \(selectedMovieId) is clicked")
        onMovieSelected?(selectedMovieId)
      }
    
}

class MovieCollectionViewCell: UICollectionViewCell {

    private var movieImageView: UIImageView!
    private var likeButton: UIButton!
    private var buttonBackground: UIView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        createViews()
        styleViews()
        defineLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with movie: MovieModel) {
        DispatchQueue.global().async {
            if let url = URL(string: movie.imageUrl), let data = try? Data(contentsOf: url) {
                DispatchQueue.main.async {
                    self.movieImageView.image = UIImage(data: data)
                }
            }
        }
    }

    private func createViews() {
        movieImageView = UIImageView()
        movieImageView.contentMode = .scaleAspectFill
        movieImageView.clipsToBounds = true
        contentView.addSubview(movieImageView)

        likeButton = UIButton()
        likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
        contentView.addSubview(likeButton)
        
        buttonBackground = UIView()

        likeButton.addSubview(buttonBackground)
        likeButton.sendSubviewToBack(buttonBackground)
    }

    private func styleViews() {
        likeButton.tintColor = .white
        
        movieImageView.layer.cornerRadius = 15
        
        buttonBackground.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        buttonBackground.layer.cornerRadius = 15
    }

    private func defineLayout() {
        movieImageView.autoPinEdgesToSuperviewEdges()

        likeButton.autoPinEdge(toSuperviewEdge: .top, withInset: 15)
        likeButton.autoPinEdge(toSuperviewEdge: .leading, withInset: 13)
        likeButton.autoSetDimensions(to: CGSize(width: 25, height: 25))
        
        buttonBackground.autoSetDimensions(to: CGSize(width: 30, height: 30))
        buttonBackground.autoAlignAxis(toSuperviewAxis: .horizontal)
        buttonBackground.autoAlignAxis(toSuperviewAxis: .vertical)
    }
}


