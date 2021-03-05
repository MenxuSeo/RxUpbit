//
//  UpbitAPI.swift
//  RxUpbit
//
//  Created by seo on 2021/03/06.
//

import Alamofire
import RxSwift

// https://www.netguru.com/codestories/networking-with-rxswift

protocol APIRequest {
  var metohd: HTTPMethod { get }
  var path: String { get }
  var parameters: [String: String] { get }
}

extension APIRequest {
  func request(with baseURL: URL) -> URLRequest {
    guard var components = URLComponents(url: baseURL.appendingPathComponent(path),
                                         resolvingAgainstBaseURL: false)
    else { fatalError("unable to create URL components") }
    
    components.queryItems = parameters.map { URLQueryItem(name: $0, value: $1) }
    
    guard let url = components.url else { fatalError("unable url") }
    
    let request: URLRequest = {
      var request = URLRequest(url: url)
      request.httpMethod = metohd.rawValue
      request.addValue("application/json", forHTTPHeaderField: "Accept")
      return request
    }()
    return request
  }
}

class UpbitAPI {
  // https://api.upbit.com/v1/market/all
  let baseURL = URL(string: "https://api.upbit.com/v1/")!
  
  func send<T: Codable>(apiRequest: APIRequest) -> Observable<T> {
    return Observable<T>.create { observer in
      let request = apiRequest.request(with: self.baseURL)
      let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
        do {
          let model: T = try JSONDecoder().decode(T.self, from: data ?? Data())
          observer.onNext(model)
        } catch let error {
          observer.onError(error)
        }
        observer.onCompleted()
      }
      task.resume()
      
      return Disposables.create { task.cancel() }
    }
  }
  
  func get<T: Codable>(apiRequest: APIRequest) -> Observable<T> {
    return Observable<T>.create { observer in
      let request = apiRequest.request(with: self.baseURL)
      let dataRequest = Alamofire.request(request).responseData { response in
        switch response.result {
        case .success(let data):
          do {
            let model: T = try JSONDecoder().decode(T.self, from: data)
            observer.onNext(model)
          } catch let error {
            observer.onError(error)
          }
        case .failure(let error):
          observer.onError(error)
        }
        observer.onCompleted()
      }
      return Disposables.create { dataRequest.cancel() }
    }
  }
}
