import MovieAppData
import Foundation
import Combine

class MovieDetailsUseCase {
    private let networkService = NetworkService()
    
    func getDetails(id: Int, completion: @escaping (Result<MovieDetailsModel, RequestError>) -> Void) {
        guard let url = URL(string: "https://five-ios-api.herokuapp.com/api/v1/movie/\(id)") else {
            completion(.failure(.clientError))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer Zpu7bOQYLNiCkT32V3c9BPoxDMfxisPAfevLW6ps", forHTTPHeaderField: "Authorization")
        
        networkService.executeUrlRequest(request, completionHandler: completion)
    }
}
