//
//  NetworkManager.swift
//  GoogleBook_jaeseung
//
//  Created by jaeseung lim on 2022/08/17.
//

import Foundation
import RxSwift
import RxCocoa

protocol NetworkingService {
    func searchBooks(withQuery query: String) -> Observable<[VolumeInfoModel]>
}

final class NetworkManager: NetworkingService {
    
    let TAG = "NetworkManager"
    
    
    func searchBooks(withQuery query: String) -> Observable<[VolumeInfoModel]> {
        let request = URLRequest(url: URL(string: "https://www.googleapis.com/books/v1/volumes?q=\(query)&filter=partial&key=AIzaSyCkcFgJTQObIULKG50UdsNo27PcXpZVKcs")!)

        return URLSession.shared.rx.data(request: request)
            .map { data -> [VolumeInfoModel] in

                guard let response = try? JSONDecoder().decode(SearchResponse.self, from: data) else { return [] }
                print(self.TAG," response.items.count : \(response.items.count)")
                print(self.TAG," response.totalItems : \(response.totalItems)")
                print(self.TAG," response : \(response)")

                return response.items
            }
    }
    
}

struct SearchResponse: Decodable {
    let totalItems : Int
    let items: [VolumeInfoModel]
}

//fileprivate struct SearchResponse: Decodable {
//    let totalItems : Int
//    let items: [VolumeInfoModel]
//}
