// The Swift Programming Language
// https://docs.swift.org/swift-book


import Alamofire
import ObjectMapper
import Foundation

public class NetworkManager {
    public static let shared = NetworkManager()

    private init() {}

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
}

