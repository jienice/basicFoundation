//
//  UITextField+Rx.swift
//  Basic
//
//  Created by jie.xing on 2022/2/24.
//  Copyright © 2022 jie.xing. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Action

extension UITextField: HasDelegate {

    public typealias Delegate = UITextFieldDelegate
}

class RxTextFieldDelegateProxy: DelegateProxy<UITextField, UITextFieldDelegate>, DelegateProxyType, UITextFieldDelegate {

    weak private(set) var textField: UITextField?

    public let shouldReturn: Action<Void, UITextField>

    init(textField: ParentObject) {
        self.textField = textField
        self.shouldReturn = Action<Void, UITextField> { Observable.just(textField)}
        super.init(parentObject: textField, delegateProxy: RxTextFieldDelegateProxy.self)
    }

    public static func registerKnownImplementations() {
        self.register { RxTextFieldDelegateProxy(textField: $0) }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        shouldReturn.execute(())
        return true
    }
}

extension Reactive where Base: UITextField {

    var delegate: DelegateProxy<UITextField, UITextFieldDelegate> {
        return RxTextFieldDelegateProxy.proxy(for: base)
    }

    public var returnKeyClicked: Observable<UITextField> {
        guard let delegate = self.delegate as? RxTextFieldDelegateProxy else {
            fatalError()
        }
        return delegate.shouldReturn.executionObservables.switchLatest()
    }

    public var borderColor: Binder<UIColor?> {
        return Binder(self.base) { view, attr in
            view.borderColor = attr
        }
    }

    public var placeholderColor: Binder<UIColor?> {
        return Binder(self.base) { view, attr in
            if let color = attr {
                view.setPlaceHolderTextColor(color)
            }
        }
    }

}
