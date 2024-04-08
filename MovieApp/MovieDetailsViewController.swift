import UIKit
import MovieAppData
import PureLayout

class MovieDetailsViewController: UIViewController {
    
    //Screen data:
    
    let id: Int = 111161
    
    let name: String = MovieUseCase().getDetails(id: 111161)!.name
    let summary: String = MovieUseCase().getDetails(id: 111161)!.summary
    let imageURLString: String = MovieUseCase().getDetails(id: 111161)!.imageUrl
    let releaseDate: String = MovieUseCase().getDetails(id: 111161)!.releaseDate
    let year: Int = MovieUseCase().getDetails(id: 111161)!.year
    let duration: Int = MovieUseCase().getDetails(id: 111161)!.duration
    let rating: Double = MovieUseCase().getDetails(id: 111161)!.rating
    let categories: [MovieCategoryModel] = MovieUseCase().getDetails(id: 111161)!.categories
    let crewMembers: [MovieCrewMemberModel] = MovieUseCase().getDetails(id: 111161)!.crewMembers
    
    private var ratingLabel: UILabel!
    private var nameLabel: UILabel!
    private var releaseDateLabel: UILabel!
    private var categoryLabel: UILabel!
    private var overviewLabel: UILabel!
    private var summaryLabel: UILabel!
    private var stackView: UIStackView!
    private var symbolImage: UIImage!

    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buildViews()
    }
    
    private func buildViews() {
        
        //create views
        
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
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
        let symbolView = UIImageView(image: symbolImage)
        imageView.addSubview(symbolView)

        //styleViews
        
        view.backgroundColor = .white
        
        let ratingLabelText = NSMutableAttributedString(string: "\(rating) User score")
        ratingLabel.font = UIFont.preferredFont(forTextStyle: .body)
        ratingLabelText.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: CGFloat(18)), range: NSRange(location: 0, length: 3))
        ratingLabel.attributedText = ratingLabelText
        ratingLabel.textColor = .white
        
        let nameLabelText = NSMutableAttributedString(string: "\(name) (\(year))")
        nameLabel.font = UIFont.preferredFont(forTextStyle: .body)
        nameLabelText.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: CGFloat(22)), range: NSRange(location: 0, length: name.count))
        nameLabel.attributedText = nameLabelText
        nameLabel.textColor = .white
        
        let formattedDate: String = formatDate(dateString: releaseDate)!
        releaseDateLabel.text = "\(formattedDate)"
        releaseDateLabel.textColor = .white
        releaseDateLabel.font = UIFont.preferredFont(forTextStyle: .body)
        
        let movieCategories: String = processCategories(categories: categories)
        let movieDuration: String = formatTime(minutes: duration)
        categoryLabel.textColor = .white
        categoryLabel.font = UIFont.preferredFont(forTextStyle: .body)
        let categoryLabelText = NSMutableAttributedString(string: "\(movieCategories) \(movieDuration)")
        categoryLabelText.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: CGFloat(18)), range: NSRange(location: movieCategories.count + 1, length: movieDuration.count))
        categoryLabel.attributedText = categoryLabelText
        
        symbolView.tintColor = .gray
        symbolView.frame.size = CGSize(width: 50, height: 50)
        
        let overviewLabelText = NSMutableAttributedString(string: "Overview")
        overviewLabelText.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: CGFloat(22)), range: NSRange(location: 0, length: 8))
        overviewLabel.attributedText = overviewLabelText
        overviewLabel.textColor = .black
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5
        let summaryLabelText = NSAttributedString(string: summary, attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
        summaryLabel.attributedText = summaryLabelText
        summaryLabel.textColor = .black
        
        stackView.axis = .vertical
        stackView.spacing = 10
            
        
        //defineLayoutForViews

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

        //implementing stackView data
        var crew: [(name: String, role: String)] = []
        crew = processCrewMembers(crewMembers: crewMembers)
        
        var currentHorizontalStackView: UIStackView?
        var index: Int = 0
        
        for member in crew{
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
            
            //add empty label to align all labels
            if index == crew.count && index%5 == 0{
                let emptyLabel = UILabel()
                emptyLabel.text = ""
                currentHorizontalStackView?.addArrangedSubview(emptyLabel)
            }
        }
        
        // creating image
        
        let imageURL = URL(string: imageURLString)!
        let session = URLSession(configuration: .default)
        
        let downloadPicTask = session.dataTask(with: imageURL) { (data, response, error) in
            // The download has finished.
            if let e = error {
                print("Error downloading image: \(e)")
            } else {
                // No errors found.
                if let res = response as? HTTPURLResponse {
                    print("Downloaded image with response code \(res.statusCode)")
                    if let imageData = data {
                        let image = UIImage(data: imageData)
                        DispatchQueue.main.async {
                            imageView.image = image
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
    
    //MovieDetailsFunctions
    
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
        var movieCategories: String = ""

        for category in categories {
            let categoryName: String
            switch category {
            case .action:
                categoryName = "Action"
            case .adventure:
                categoryName = "Adventure"
            case .comedy:
                categoryName = "Comedy"
            case .crime:
                categoryName = "Crime"
            case .drama:
                categoryName = "Drama"
            case .fantasy:
                categoryName = "Fantasy"
            case .romance:
                categoryName = "Romance"
            case .scienceFiction:
                categoryName = "Science Fiction"
            case .thriller:
                categoryName = "Thriller"
            case .western:
                categoryName = "Western"
            }
            if movieCategories.isEmpty{
                movieCategories.append(categoryName)
            }
            else{
                movieCategories.append(", \(categoryName)")
            }
        }

        return movieCategories
    }
    
    func processCrewMembers(crewMembers: [MovieCrewMemberModel]) -> [(name: String, role: String)] {
        var crew: [(name: String, role: String)] = []

        for member in crewMembers {
            crew.append((name: member.name, role: member.role))
        }

        return crew
    }
       
}
