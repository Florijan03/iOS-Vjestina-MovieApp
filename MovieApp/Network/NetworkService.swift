import Foundation

enum RequestError: Error {
    case clientError
    case serverError
    case noDataError
    case decodingError
}

class NetworkService {
    func executeUrlRequest<T: Decodable>(_ request: URLRequest, completionHandler: @escaping (Result<T, RequestError>) -> Void) {
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, err in
            guard err == nil else {
                DispatchQueue.main.async {
                    completionHandler(.failure(.clientError))
                }
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                DispatchQueue.main.async {
                    completionHandler(.failure(.serverError))
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async{
                    completionHandler(.failure(.noDataError))
                }
                return
            }
            
            guard let value = try? JSONDecoder().decode(T.self, from: data) else {
                DispatchQueue.main.async{
                    completionHandler(.failure(.decodingError))
                }
                return
            }
            
            DispatchQueue.main.async{
                completionHandler(.success(value))
            }

        }
        dataTask.resume()
    }
}

