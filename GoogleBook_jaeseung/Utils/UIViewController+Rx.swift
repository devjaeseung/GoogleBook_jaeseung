//
//  UIViewController+Rx.swift
//  GoogleBook_jaeseung
//
//  Created by jaeseung lim on 2022/08/17.
//

import RxSwift
import RxCocoa

extension Reactive where Base: UIViewController {
    var viewWillAppear: ControlEvent<Void> {
        let source = self.methodInvoked(#selector(Base.viewWillAppear(_:))).map { _ in }
        return ControlEvent(events: source)
    }
}
