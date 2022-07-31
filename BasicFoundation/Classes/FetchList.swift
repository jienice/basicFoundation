//
//  FetchList.swift
//  Basic
//
//  Created by jie.xing on 2022/2/24.
//  Copyright © 2022 jie.xing. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Action
import RxOptional
import RxSwiftExt
import Moya

private var pageKey: UInt8 = 0
private var totalPageKey: UInt8 = 0
private let defaultPage = 1
private let defaultTotalPage = 0
public protocol PageSettable: Object {

    /// 当前页
    var page: BehaviorRelay<Int> {get}
    /// 总页数
    var totalPage: BehaviorRelay<Int> {get}
}

public extension PageSettable {

    var page: BehaviorRelay<Int> {
        if let lookUp = objc_getAssociatedObject(self, &pageKey) as? BehaviorRelay<Int> {
            return lookUp
        }
        let value = BehaviorRelay<Int>(value: defaultPage)
        objc_setAssociatedObject(self, &pageKey, value, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return value
    }

    var totalPage: BehaviorRelay<Int> {
        if let lookUp = objc_getAssociatedObject(self, &totalPageKey) as? BehaviorRelay<Int> {
            return lookUp
        }
        let value = BehaviorRelay<Int>(value: defaultTotalPage)
        objc_setAssociatedObject(self, &totalPageKey, value, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return value
    }

    @discardableResult
    func resetPage() -> Int {
        page.accept(defaultPage)
        totalPage.accept(defaultTotalPage)
        return page.value
    }

    @discardableResult
    func increasePage() -> Int {
        page.accept(page.value + 1)
        return page.value
    }

    @discardableResult
    func decreasePage() -> Int {
        page.accept(page.value > defaultPage ? page.value - 1 : defaultPage)
        return page.value
    }

    func cacheTotalPages(value: Int) {
        totalPage.accept(value)
    }
    
}

private var searchKeyWordKey: UInt8 = 0
public protocol Searchable: Object {
    
    var searchKeyWord: BehaviorRelay<String?>? {get set}
}

public extension Searchable {
    
    var searchKeyWord: BehaviorRelay<String?>? {
        get {
            objc_getAssociatedObject(self, &searchKeyWordKey) as? BehaviorRelay<String?>
        }
        set {
            objc_setAssociatedObject(self, &searchKeyWordKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
}

private var dataSourceKey: UInt8 = 0
public protocol FetchList: PageSettable, Searchable, RefreshStatusCreatable, ErrorEmitable {
    
    associatedtype List: ListType

    var dataSource: BehaviorRelay<[List.Element]> {get}
}

public extension FetchList {

    var dataSource: BehaviorRelay<[List.Element]> {
        if let lookUp = objc_getAssociatedObject(self, &dataSourceKey) as? BehaviorRelay<[List.Element]> {
            return lookUp
        }
        let value = BehaviorRelay<[List.Element]>(value: [])
        objc_setAssociatedObject(self, &dataSourceKey, value, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return value
    }
    
    func append(_ dataSource: [List.Element]) {
        if page.value == defaultPage {
            self.dataSource.accept(dataSource)
        } else {
            self.dataSource.accept(self.dataSource.value + dataSource)
        }
    }
}

// MARK: FetchList
private var firstPageActionKey: UInt8 = 0
private var morePageActionKey: UInt8 = 0
private var searchActionKey: UInt8 = 0
public extension FetchList {
    
    private var firstPageAction: CocoaAction? {
        get {
            objc_getAssociatedObject(self, &firstPageActionKey) as? CocoaAction
        }
        set {
            objc_setAssociatedObject(self, &firstPageActionKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    private var morePageAction: CocoaAction? {
        get {
            objc_getAssociatedObject(self, &morePageActionKey) as? CocoaAction
        }
        set {
            objc_setAssociatedObject(self, &morePageActionKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    private var searchAction: CocoaAction? {
        get {
            objc_getAssociatedObject(self, &searchActionKey) as? CocoaAction
        }
        set {
            objc_setAssociatedObject(self, &searchActionKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    @discardableResult
    func firstPage(_ action: CocoaAction) -> Self {
        self.firstPageAction = action
        return self
    }
    
    @discardableResult
    func morePage(_ action: CocoaAction) -> Self {
        self.morePageAction = action
        return self
    }
    
    @discardableResult
    func search(_ action: CocoaAction, _ searchKeyword: Observable<String?>) -> Self {
        self.searchAction = action
        let search = BehaviorRelay<String?>(value: nil)
        searchKeyword
            .bind(to: search)
            .disposed(by: rx.disposeBag)
        self.searchKeyWord = search
        return self
    }
    
    func buildFetchList(with api: @escaping (Int, String?) -> Single<Response>) {
        guard let first = firstPageAction else { return }
        let request = first.executionObservables.switchLatest()
        var merges = [Observable<Void>]()
        if let more = morePageAction {
            merges.append(more.executionObservables.switchLatest())
        }
        if let search = searchAction {
            merges.append(search.executionObservables.switchLatest())
        }
        
        firstPageAction?
            .executionObservables
            .switchLatest()
            .subscribe(onNext: { [weak self] in
                self?.resetPage()
            }).disposed(by: rx.disposeBag)
        
        morePageAction?
            .executionObservables
            .switchLatest()
            .subscribe(onNext: { [weak self] in
                self?.increasePage()
            }).disposed(by: rx.disposeBag)
        
        searchAction?
            .executionObservables
            .switchLatest()
            .subscribe(onNext: { [weak self] in
                self?.resetPage()
            }).disposed(by: rx.disposeBag)
        
        request.merge(with: merges)
            .flatMapLatest { [unowned self] in api(self.page.value, self.searchKeyWord?.value).asObservable() }
            .debug()
            .subscribe(onNext: { [weak self] in
                do {
                    print($0.data)
                    let list = try JSONDecoder().decode(List.self, from: $0.data)
                    self?.page.accept(list.page)
                    self?.totalPage.accept(list.totalPages)
                    self?.refreshStatus.accept(list.refreshStatus)
                    self?.append(list.list)
                } catch {
                    self?.error.accept(error)
                    self?.refreshStatus.accept(.error(error: error))
                }
            }).disposed(by: rx.disposeBag)
    }
    
}
