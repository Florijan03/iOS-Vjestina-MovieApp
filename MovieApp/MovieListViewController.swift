import UIKit
import PureLayout
import MovieAppData

class MovieListViewController: UIViewController {

    private var tableView: UITableView!
    private var allMovies: [MovieModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        allMovies = MovieUseCase().allMovies

        buildViews()
    }

    private func buildViews() {
        createViews()
        styleViews()
        defineLayout()
    }
}

extension MovieListViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return allMovies.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieTableViewCell

        let movie = allMovies[indexPath.section]
        cell.configure(with: movie)

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10 // Ne radi
    }

}

extension MovieListViewController {
    func createViews() {
        tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(MovieTableViewCell.self, forCellReuseIdentifier: "MovieCell")
        view.addSubview(tableView)
    }

    func styleViews() {
        view.backgroundColor = .white
    }

    func defineLayout() {
        tableView.autoPinEdge(toSuperviewEdge: .top)
        tableView.autoPinEdge(toSuperviewEdge: .bottom)
        tableView.autoPinEdge(toSuperviewEdge: .left, withInset: 15)
        tableView.autoPinEdge(toSuperviewEdge: .right, withInset: 15)
    }

}

class MovieTableViewCell: UITableViewCell {

    private var movieImageView: UIImageView!
    private var nameLabel: UILabel!
    private var summaryLabel: UILabel!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        createViews()
        styleViews()
        defineLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")  //obj
    }

    func configure(with movie: MovieModel) {
        let attributedString = NSMutableAttributedString(string: movie.name)
        attributedString.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: CGFloat(18)), range: NSRange(location: 0, length: attributedString.length))
        nameLabel.attributedText = attributedString

        summaryLabel.textColor = .gray
        summaryLabel.text = movie.summary

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

        nameLabel = UILabel()
        nameLabel.numberOfLines = 0
        contentView.addSubview(nameLabel)

        summaryLabel = UILabel()
        summaryLabel.numberOfLines = 0
        contentView.addSubview(summaryLabel)
    }

    private func styleViews() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 15
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
        contentView.layer.shadowOpacity = 0.4
        contentView.layer.shadowRadius = 4
        
        movieImageView.layer.cornerRadius = 15
    }

    private func defineLayout() {
        
        movieImageView.autoPinEdge(toSuperviewEdge: .top)
        movieImageView.autoPinEdge(toSuperviewEdge: .leading)
        movieImageView.autoPinEdge(toSuperviewEdge: .bottom)
        movieImageView.autoMatch(.width, to: .height, of: movieImageView)
        movieImageView.autoSetDimension(.width, toSize: 100)

        nameLabel.autoPinEdge(.leading, to: .trailing, of: movieImageView, withOffset: 8)
        nameLabel.autoPinEdge(toSuperviewEdge: .top, withInset: 8)
        nameLabel.autoPinEdge(toSuperviewEdge: .trailing, withInset: 8)

        summaryLabel.autoPinEdge(.leading, to: .trailing, of: movieImageView, withOffset: 8)
        summaryLabel.autoPinEdge(.top, to: .bottom, of: nameLabel, withOffset: 4)
        summaryLabel.autoPinEdge(toSuperviewEdge: .trailing, withInset: 8)
        summaryLabel.autoPinEdge(toSuperviewEdge: .bottom, withInset: 8)
    }
}


//compositional layout
//king fischer
