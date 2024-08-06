// The Swift Programming Language
// https://docs.swift.org/swift-book


import Alamofire
import ObjectMapper
import Foundation

public class NetworkManager {
    public static let shared = NetworkManager()

    private init() {}

    //MARK: - ALAMOFIRE -
    
    //MARK: - OBJECT MAPPER SECTION
    
    public func request<T: Mappable>(_ url: URLConvertible, method: HTTPMethod = .get, parameters: Parameters? = nil, encoding: ParameterEncoding = URLEncoding.default, headers: HTTPHeaders? = nil, completion: @escaping (Result<T, Error>) -> Void) {
        AF.request(url, method: method, parameters: parameters, encoding: encoding, headers: headers).responseJSON { response in
            switch response.result {
            case .success(let value):
                if let mappedObject = Mapper<T>().map(JSONObject: value) {
                    completion(.success(mappedObject))
                } else {
                    let error = NSError(domain: "com.yourdomain.network", code: -1, userInfo: [NSLocalizedDescriptionKey: "Mapping Error"])
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    public func requestArray<T: Mappable>(_ url: URLConvertible, method: HTTPMethod = .get, parameters: Parameters? = nil, encoding: ParameterEncoding = URLEncoding.default, headers: HTTPHeaders? = nil, completion: @escaping (Result<[T], Error>) -> Void) {
        AF.request(url, method: method, parameters: parameters, encoding: encoding, headers: headers).responseJSON { response in
            switch response.result {
            case .success(let value):
                if let mappedArray = Mapper<T>().mapArray(JSONObject: value) {
                    completion(.success(mappedArray))
                } else {
                    let error = NSError(domain: "com.cinqtech.vault", code: -1, userInfo: [NSLocalizedDescriptionKey: "Mapping Error"])
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
    //MARK: - DECODABLE
    
    public func requestDecodable<T: Decodable>(_ url: URLConvertible, method: HTTPMethod = .get, parameters: Parameters? = nil, encoding: ParameterEncoding = URLEncoding.default, headers: HTTPHeaders? = nil, completion: @escaping (Result<T, Error>) -> Void) {
           AF.request(url, method: method, parameters: parameters, encoding: encoding, headers: headers)
               .validate()
               .responseDecodable(of: T.self) { response in
                   switch response.result {
                   case .success(let value):
                       completion(.success(value))
                   case .failure(let error):
                       completion(.failure(error))
                   }
               }
       }

       public func requestArrayDecodable<T: Decodable>(_ url: URLConvertible, method: HTTPMethod = .get, parameters: Parameters? = nil, encoding: ParameterEncoding = URLEncoding.default, headers: HTTPHeaders? = nil, completion: @escaping (Result<[T], Error>) -> Void) {
           AF.request(url, method: method, parameters: parameters, encoding: encoding, headers: headers)
               .validate()
               .responseDecodable(of: [T].self) { response in
                   switch response.result {
                   case .success(let value):
                       completion(.success(value))
                   case .failure(let error):
                       completion(.failure(error))
                   }
               }
       }
    
    //MARK: -URL SESSION-
    
    func requestUrlSession<T: Decodable>(_ url: URL, completion: @escaping (Result<T, Error>) -> Void) {
           let task = URLSession.shared.dataTask(with: url) { data, response, error in
               if let error = error {
                   completion(.failure(error))
                   return
               }

               guard let data = data else {
                   completion(.failure(NSError(domain: "com.yourdomain.network", code: -1, userInfo: [NSLocalizedDescriptionKey: "No Data"])))
                   return
               }

               do {
                   let decodedObject = try JSONDecoder().decode(T.self, from: data)
                   DispatchQueue.main.async {
                       completion(.success(decodedObject))
                   }
               } catch {
                   completion(.failure(error))
               }
           }
           task.resume()
       }
    
    func requestArrayUrlSession<T: Decodable>(_ url: URL, completion: @escaping (Result<[T], Error>) -> Void) {
           let task = URLSession.shared.dataTask(with: url) { data, response, error in
               if let error = error {
                   completion(.failure(error))
                   return
               }

               guard let data = data else {
                   completion(.failure(NSError(domain: "com.yourdomain.network", code: -1, userInfo: [NSLocalizedDescriptionKey: "No Data"])))
                   return
               }

               do {
                   let decodedArray = try JSONDecoder().decode([T].self, from: data)
                   DispatchQueue.main.async {
                       completion(.success(decodedArray))
                   }
               } catch {
                   completion(.failure(error))
               }
           }
           task.resume()
       }
}

