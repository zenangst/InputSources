import Carbon

public enum InputSource_TISInputSourceError: Error {
  case failedToCastToType(type: Any)
}

extension TISInputSource {
  func value<T>(_ propertyKey: PropertyKey, type: T.Type) throws -> T {
    guard let value = optionalValue(propertyKey, type: type) else {
      throw InputSource_TISInputSourceError.failedToCastToType(type: T.self)
    }
    return value
  }

  func optionalValue<T>(_ propertyKey: PropertyKey, type: T.Type) -> T? {
    guard let source = TISGetInputSourceProperty(self, propertyKey.rawValue) else {
      return nil
    }
    return unmanagedObject(from: source) as? T
  }

  func valueWithDefault<T>(_ propertyKey: PropertyKey, defaultValue: T) -> T {
    optionalValue(propertyKey, type: type(of: defaultValue)) ?? defaultValue
  }

  private func unmanagedObject(from unsafeMutablePointer: UnsafeMutableRawPointer) -> AnyObject? {
    Unmanaged<AnyObject>.fromOpaque(unsafeMutablePointer).takeUnretainedValue()
  }
}
