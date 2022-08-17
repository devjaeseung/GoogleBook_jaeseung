//
//  SearchListViewModel.swift
//  GoogleBook_jaeseung
//
//  Created by jaeseung lim on 2022/08/17.
//

import RxSwift
import RxCocoa

protocol SearchListViewModelInputs {
    func viewWillAppear()
    func didSelect(indexPath: IndexPath)
    func didSearch(query: String)
}

protocol SearchListViewModelOutputs {
    var loading: Driver<Bool> { get }
    var items: Driver<[VolumeInfoViewModel]> { get }
    var selectedVolume: Driver<String> { get }
}

protocol SearchListViewModelType {
    var inputs: SearchListViewModelInputs { get }
    var ouputs: SearchListViewModelOutputs { get }
}

final class SearchListViewModel: SearchListViewModelType,SearchListViewModelInputs,SearchListViewModelOutputs {
    
    let TAG = "SearchListViewModel"
    
    init () {
        print(TAG," init () ")
        let loading = ActivityIndicator()
        self.loading = loading.asDriver()
        
        let initialVolumes = self.viewWillAppearSubject
            .asObservable()
            .flatMap { result in
                AppEnvironment.current.networkingService
                    .searchBooks(withQuery: "swift")
                    .trackActivity(loading)
            }
            .asDriver(onErrorJustReturn: [])
        
        let searchVolumes = self.didSearchSubject
            .asObservable()
            .filter { $0.count > 2 }
            .throttle(RxTimeInterval.seconds(1), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .flatMapLatest { query in
                AppEnvironment.current.networkingService
                    .searchBooks(withQuery: query)
                    .trackActivity(loading)
            }
            .asDriver(onErrorJustReturn: [])
        
        let volumes = Driver.merge(initialVolumes,searchVolumes)
        
        print(TAG," volumes : \(volumes)")
        
        self.items = volumes.map { $0.map { VolumeInfoViewModel(volueInfoModel: $0)} }
        
        self.selectedVolume = self.didSelectSubject
            .asObservable()
            .withLatestFrom(volumes) { (indexPath, volumes) in
                return volumes[indexPath.item]
            }
            .map{ $0.infoLink }
            .asDriver(onErrorJustReturn: "없음!")
    }
    
    var inputs: SearchListViewModelInputs { return self }
    var ouputs: SearchListViewModelOutputs { return self }
    
    private let viewWillAppearSubject = PublishSubject<Void>()
    func viewWillAppear() {
        viewWillAppearSubject.onNext(())
    }
    
    private let didSelectSubject = PublishSubject<IndexPath>()
    func didSelect(indexPath: IndexPath) {
        didSelectSubject.onNext(indexPath)
    }
    
    private let didSearchSubject = PublishSubject<String>()
    func didSearch(query: String) {
        didSearchSubject.onNext(query)
    }
    
    var loading: Driver<Bool>
    var items: Driver<[VolumeInfoViewModel]>
    var selectedVolume: Driver<String>
    
    
}

struct VolumeInfoViewModel {
    
    let TAG = "VolumeInfoViewModel"
    
    let title: String
    let authors: [String]
    let date: String
    let smalltumbnail: String
    
    init(volueInfoModel: VolumeInfoModel) {
        
        self.title = volueInfoModel.title
        self.authors = volueInfoModel.authors
        self.date = volueInfoModel.publishedDate
        self.smalltumbnail = volueInfoModel.smallThumbnail
        
    }
    
}
