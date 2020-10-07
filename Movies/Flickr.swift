
import Foundation
import UIKit
import Moya

public enum Flickr {
    static private let apiKey = "69fb6e610d30f068e020c8319acfbae4"
    static private let apiSecret = "556acc3d22af9f0c"
    case search(String)
}

extension Flickr: TargetType {
  public var baseURL: URL {
    return URL(string: "https://api.flickr.com/services")!
  }
  public var path: String {
    switch self {
        case .search:
        return "/rest"
    }
  }
  public var method: Moya.Method {
    switch self {
        case .search:
        return .get
    }
  }
  public var sampleData: Data {
    return Data()
  }
  public var task: Task {
    switch self {
    case .search(let title):
        return  .requestParameters(
          parameters: [
            "method": "flickr.photos.search",
            "api_key": Flickr.apiKey,
            "tags": title,
            "format": "json",
            "nojsoncallback": 1,
            "per_page": 6,
            "page": 1
            
            ], encoding: URLEncoding.default
        )
    }
  }
  
  public var headers: [String: String]? {
    return [
      "Content-Type": "application/json"
    ]
  }
  
  public var validationType: ValidationType {
    return .successCodes
  }
  
}
