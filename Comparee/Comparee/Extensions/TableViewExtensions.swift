import UIKit

extension UITableViewCell: NibLoadable {}
extension UITableViewHeaderFooterView: NibLoadable {}
extension UICollectionReusableView: NibLoadable {}

protocol NibLoadable {
    static var nib: UINib { get }
    static var identifier: String { get }
}

extension NibLoadable {
    static var nib: UINib {
        return UINib(nibName: identifier, bundle: Bundle.main)
    }

    static var identifier: String {
        return String(describing: self)
    }
}

extension UINib {
    convenience init<T>(_: T.Type) {
        self.init(nibName: String(describing: T.self), bundle: Bundle.main)
    }
}

extension UITableView {

    func registerWithoutNib<T: UITableViewCell>(_: T.Type) {
        register(T.self, forCellReuseIdentifier: T.identifier)
    }

    func register<T: UITableViewCell>(_: T.Type) {
        register(T.nib, forCellReuseIdentifier: T.identifier)
    }

    func register<T: UITableViewHeaderFooterView>(_: T.Type) {
        register(T.nib, forHeaderFooterViewReuseIdentifier: T.identifier)
    }

    func dequeue<T: UITableViewCell>(_: T.Type) -> T? {
        return dequeueReusableCell(withIdentifier: T.identifier) as? T
    }

    func dequeue<T: UITableViewCell>(_: T.Type, for indexPath: IndexPath) -> T? {
        return dequeueReusableCell(withIdentifier: T.identifier, for: indexPath) as? T
    }

    func dequeueHeaderFooterView<T: UITableViewHeaderFooterView>(_: T.Type) -> T? {
        return dequeueReusableHeaderFooterView(withIdentifier: T.identifier) as? T
    }
}

extension UICollectionView {

    func registerWithoutNib<T: UICollectionViewCell>(_ type: T.Type) {
        register(type, forCellWithReuseIdentifier: type.identifier)
    }

    func register<T: UICollectionViewCell>(_: T.Type) {
        register(T.nib, forCellWithReuseIdentifier: T.identifier)
    }

    func dequeue<T: UICollectionViewCell>(_ type: T.Type, for indexPath: IndexPath) -> T? {
        return dequeueReusableCell(withReuseIdentifier: type.identifier, for: indexPath) as? T
    }

    func register<T: UICollectionReusableView>(_: T.Type, for supplementaryViewOfKind: String) {
        register(T.nib, forSupplementaryViewOfKind: supplementaryViewOfKind, withReuseIdentifier: T.identifier)
    }

    func dequeueReusableCell<T: UICollectionViewCell>(_: T.Type, for indexPath: IndexPath) -> T? {
        return dequeueReusableCell(withReuseIdentifier: T.identifier, for: indexPath) as? T
    }
}

extension UICollectionReusableView {
    static var reuseIdentifier: String {
        return String(describing: Self.self)
    }
}
