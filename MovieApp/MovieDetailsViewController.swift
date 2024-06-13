import UIKit
import MovieAppData
import PureLayout

import Foundation

struct MovieDetailsModel: Decodable {
    let id: Int
    let name: String
    let year: Int
    let rating: Double
    let releaseDate: String
    let duration: Int
    let summary: String
    let imageUrl: String
    let categories: [MovieCategoryModel]
    let crewMembers: [MovieCrewMemberModel]

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case year
        case rating
        case releaseDate = "release_date"
        case duration
        case summary
        case imageUrl = "image_url"
        case categories
        case crewMembers = "crew_members"
    }
}

struct MovieCategoryModel: Decodable {
    let id: Int
    let localizedTitle: String

    enum CodingKeys: String, CodingKey {
        case id
        case localizedTitle = "localized_title"
    }
}

struct MovieCrewMemberModel: Decodable {
    let id: Int
    let name: String
    let role: String
}

class MovieDetailsViewController: UIViewController {
    
    // Varijabla za pohranu podataka o filmu
    private var movieDetails: MovieDetailsModel?
    
    private var ratingLabel: UILabel!
    private var nameLabel: UILabel!
    private var releaseDateLabel: UILabel!
    private var categoryLabel: UILabel!
    private var overviewLabel: UILabel!
    private var summaryLabel: UILabel!
    private var stackView: UIStackView!
    private var symbolImage: UIImage!
    private var symbolView: UIView!
    private var imageView: UIImageView!
    
    var labels: [UILabel] {
        [ratingLabel, nameLabel, releaseDateLabel, categoryLabel, summaryLabel]
    }

    // Inicijalizacija s ID-om filma
    init(movieId: Int) {
        super.init(nibName: nil, bundle: nil)
        fetchMovieDetails(movieId: movieId)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func fetchMovieDetails(movieId: Int) {
        MovieDetailsUseCase().getDetails(id: movieId) { [weak self] result in
            switch result {
            case .success(let details):
                self?.movieDetails = details
                DispatchQueue.main.async {
                    self?.buildViews(with: details)
                }
            case .failure(let error):
                print("Failed to fetch movie details: \(error)")
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let movieDetails = movieDetails else { return }
        buildViews(with: movieDetails)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupInitialAnimationState()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        animateLabels()
    }
    
    private func buildViews(with details: MovieDetailsModel) {
        createViews()
        styleViews(with: details)
        defineLayout()
        stackViewFunc(with: details.crewMembers)
    }
    
    // MovieDetailsFunctions
    
    func formatTime(minutes: Int) -> String {
        let hours = minutes / 60
        let remainingMinutes = minutes % 60
        
        var formattedTime = ""
        
        if hours > 0 {
            formattedTime += "\(hours)h "
        }
        
        if remainingMinutes > 0 || formattedTime.isEmpty {
            formattedTime += "\(remainingMinutes)m"
        }
        
        return formattedTime
    }
    
    func formatDate(dateString: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-M-d"
        
        guard let date = dateFormatter.date(from: dateString) else {
            return nil
        }
        
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let formattedDate = dateFormatter.string(from: date)
        
        return formattedDate
    }
    
    func processCategories(categories: [MovieCategoryModel]) -> String {
        categories.map { $0.localizedTitle }.joined(separator: ", ")
    }
    
    func processCrewMembers(crewMembers: [MovieCrewMemberModel]) -> [(name: String, role: String)] {
        var crew: [(name: String, role: String)] = []
        for member in crewMembers {
            crew.append((name: member.name, role: member.role))
        }
        return crew
    }
}

extension MovieDetailsViewController {
    
    func createViews() {
        imageView = UIImageView()
        view.addSubview(imageView)
        
        ratingLabel = UILabel()
        imageView.addSubview(ratingLabel)
        
        nameLabel = UILabel()
        imageView.addSubview(nameLabel)
        
        releaseDateLabel = UILabel()
        imageView.addSubview(releaseDateLabel)
        
        categoryLabel = UILabel()
        imageView.addSubview(categoryLabel)
        
        overviewLabel = UILabel()
        view.addSubview(overviewLabel)
        
        summaryLabel = UILabel()
        view.addSubview(summaryLabel)
        
        stackView = UIStackView()
        view.addSubview(stackView)
        
        symbolImage = UIImage(systemName: "star.circle.fill")
        symbolView = UIImageView(image: symbolImage)
        imageView.addSubview(symbolView)
    }
    
    func styleViews(with details: MovieDetailsModel) {
        view.backgroundColor = .white
        
        let ratingLabelText = NSMutableAttributedString(string: "\(details.rating) User score")
        ratingLabel.font = UIFont.preferredFont(forTextStyle: .body)
        ratingLabelText.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: CGFloat(18)), range: NSRange(location: 0, length: 3))
        ratingLabel.attributedText = ratingLabelText
        ratingLabel.textColor = .white
        
        let nameLabelText = NSMutableAttributedString(string: "\(details.name) (\(details.year))")
        nameLabel.font = UIFont.preferredFont(forTextStyle: .body)
        nameLabelText.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: CGFloat(22)), range: NSRange(location: 0, length: details.name.count))
        nameLabel.attributedText = nameLabelText
        nameLabel.textColor = .white
        
        let formattedDate: String = formatDate(dateString: details.releaseDate)!
        releaseDateLabel.text = "\(formattedDate)"
        releaseDateLabel.textColor = .white
        releaseDateLabel.font = UIFont.preferredFont(forTextStyle: .body)
        
        let movieCategories: String = processCategories(categories: details.categories)
        let movieDuration: String = formatTime(minutes: details.duration)
        categoryLabel.textColor = .white
        categoryLabel.font = UIFont.preferredFont(forTextStyle: .body)
        let categoryLabelText = NSMutableAttributedString(string: "\(movieCategories) \(movieDuration)")
        categoryLabelText.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: CGFloat(18)), range: NSRange(location: movieCategories.count + 1, length: movieDuration.count))
        categoryLabel.attributedText = categoryLabelText
        
        symbolView.tintColor = .gray
        
        let overviewLabelText = NSMutableAttributedString(string: "Overview")
        overviewLabelText.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: CGFloat(22)), range: NSRange(location: 0, length: 8))
        overviewLabel.attributedText = overviewLabelText
        overviewLabel.textColor = .black
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5
        let summaryLabelText = NSAttributedString(string: details.summary, attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
        summaryLabel.attributedText = summaryLabelText
        summaryLabel.textColor = .black
        
        stackView.axis = .vertical
        stackView.spacing = 10
        
        let imageURL = URL(string: details.imageUrl)!
        let session = URLSession(configuration: .default)
        
        let downloadPicTask = session.dataTask(with: imageURL) { (data, response, error) in
            if let e = error {
                print("Error downloading image: \(e)")
            } else {
                if let res = response as? HTTPURLResponse {
                    print("Downloaded image with response code \(res.statusCode)")
                    if let imageData = data {
                        let image = UIImage(data: imageData)
                        DispatchQueue.main.async {
                            self.imageView.image = image
                        }
                    } else {
                        print("Couldn't get image: Image data is nil")
                    }
                } else {
                    print("Couldn't get response code for some reason")
                }
            }
        }
        downloadPicTask.resume()
    }
    
    func defineLayout() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.autoPinEdge(toSuperviewEdge: .top)
        imageView.autoPinEdge(toSuperviewEdge: .leading)
        imageView.autoPinEdge(toSuperviewEdge: .trailing)
        imageView.autoMatch(.height, to: .height, of: view, withMultiplier: 0.4)
        
        ratingLabel.translatesAutoresizingMaskIntoConstraints = false
        ratingLabel.autoPinEdge(.leading, to: .leading, of: imageView, withOffset: CGFloat(20))
        ratingLabel.autoAlignAxis(.horizontal, toSameAxisOf: imageView, withOffset: CGFloat(-30))
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.autoPinEdge(.top, to: .bottom, of: ratingLabel, withOffset: CGFloat(20))
        nameLabel.autoPinEdge(.leading, to: .leading, of: ratingLabel)
        nameLabel.autoPinEdge(toSuperviewEdge: .trailing, withInset: CGFloat(20))
        nameLabel.numberOfLines = 0
        
        releaseDateLabel.translatesAutoresizingMaskIntoConstraints = false
        releaseDateLabel.autoPinEdge(.top, to: .bottom, of: nameLabel, withOffset: CGFloat(20))
        releaseDateLabel.autoPinEdge(.leading, to: .leading, of: nameLabel)
        
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        categoryLabel.autoPinEdge(.top, to: .bottom, of: releaseDateLabel, withOffset: CGFloat(6))
        categoryLabel.autoPinEdge(.leading, to: .leading, of: releaseDateLabel)
        categoryLabel.autoPinEdge(toSuperviewEdge: .trailing, withInset: CGFloat(20))
        categoryLabel.numberOfLines = 0
        
        symbolView.autoPinEdge(.top, to: .bottom, of: categoryLabel, withOffset: CGFloat(15))
        symbolView.autoPinEdge(.leading, to: .leading, of: categoryLabel)
        symbolView.autoSetDimensions(to: CGSize(width: 45, height: 45))

        overviewLabel.translatesAutoresizingMaskIntoConstraints = false
        overviewLabel.autoPinEdge(.top, to: .bottom, of: imageView, withOffset: CGFloat(25))
        overviewLabel.autoPinEdge(toSuperviewEdge: .leading, withInset: CGFloat(20))
        
        summaryLabel.translatesAutoresizingMaskIntoConstraints = false
        summaryLabel.autoPinEdge(.top, to: .bottom, of: overviewLabel, withOffset: CGFloat(15))
        summaryLabel.autoPinEdge(toSuperviewEdge: .leading, withInset: CGFloat(16))
        summaryLabel.autoPinEdge(toSuperviewEdge: .trailing, withInset: CGFloat(20))
        summaryLabel.numberOfLines = 0
        
        stackView.autoPinEdge(.top, to: .bottom, of: summaryLabel, withOffset: CGFloat(30))
        stackView.autoPinEdge(toSuperviewEdge: .leading, withInset: CGFloat(16))
        stackView.autoPinEdge(toSuperviewEdge: .trailing, withInset: CGFloat(16))
    }
    
    func stackViewFunc(with crewMembers: [MovieCrewMemberModel]) {
        let crew = processCrewMembers(crewMembers: crewMembers)
        
        var currentHorizontalStackView: UIStackView?
        var index: Int = 0
        
        for member in crew {
            index += 1
            if currentHorizontalStackView == nil || currentHorizontalStackView!.arrangedSubviews.count == 3 {
                currentHorizontalStackView = UIStackView()
                currentHorizontalStackView!.axis = .horizontal
                currentHorizontalStackView!.spacing = 10
                currentHorizontalStackView!.alignment = .fill
                currentHorizontalStackView!.distribution = .fillEqually
                stackView.addArrangedSubview(currentHorizontalStackView!)
            }
            
            let memberLabel = UILabel()
            let memberLabelText = NSMutableAttributedString(string: "\(member.name)\n\(member.role)")
            memberLabelText.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: CGFloat(16)), range: NSRange(location: 0, length: member.name.count))
            memberLabel.attributedText = memberLabelText
            memberLabel.textColor = .black
            memberLabel.numberOfLines = 0
            
            currentHorizontalStackView?.addArrangedSubview(memberLabel)
            
            // Dodavanje praznog labela za poravnanje svih labela
            if index == crew.count && index % 5 == 0 {
                let emptyLabel = UILabel()
                emptyLabel.text = ""
                currentHorizontalStackView?.addArrangedSubview(emptyLabel)
            }
        }
    }
    
    func setupInitialAnimationState(){
        for label in labels {
            label.transform = CGAffineTransform(translationX: -view.frame.width, y: 0)
        }
        stackView.alpha = 0
    }
    
    func animateLabels(){
        UIView.animate(withDuration: 0.2, delay: 0, options: [], animations: { [weak self] in
            self?.labels.forEach { $0.transform = .identity }
        }, completion: { [weak self] _ in
            self?.animateStackView()})
    }
    
    func animateStackView(){
        UIView.animate(withDuration: 0.3) {
            self.stackView.alpha = 1
        }
    }
}

//extension MovieCategoryModel {
//    var localizedTitle: String {
//        switch self {
//        case .action:
//            return "Action"
//        case .adventure:
//            return "Adventure"
//        case .comedy:
//            return "Comedy"
//        case .crime:
//            return "Crime"
//        case .drama:
//            return "Drama"
//        case .fantasy:
//            return "Fantasy"
//        case .romance:
//            return "Romance"
//        case .scienceFiction:
//            return "Science Fiction"
//        case .thriller:
//            return "Thriller"
//        case .western:
//            return "Western"
//        }
//    }
//}
