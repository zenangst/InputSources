import Carbon

public enum InputSourceControllerError: Error {
  case failedToInstall(id: String)
  case failedToUninstall(id: String)
  case failedToFindInputSource(id: String)
  case failedToSelect(id: String)
}

@MainActor
final public class InputSourceController {
  public init() { }

  public func currentInputSource() throws -> InputSource {
    try InputSource(source: TISCopyCurrentKeyboardInputSource().takeUnretainedValue())
  }

  public func fetchInputSources(includeAllInstalled: Bool) -> [InputSource] {
    let sourceList = TISCreateInputSourceList([:] as CFDictionary, includeAllInstalled)
    guard let sources = sourceList?.takeUnretainedValue() as? [TISInputSource] else { return [] }
    return sources.compactMap { try? InputSource(source: $0) }
  }

  public func isInstalled(_ inputSource: InputSource) -> Bool {
    isInstalled(id: inputSource.id)
  }

  public func isInstalled(id: String) -> Bool {
    fetchInputSources(includeAllInstalled: false)
      .contains(where: { $0.id == id })
  }

  public func install(_ inputSource: InputSource) throws {
    try install(inputSource.id)
  }

  public func install(_ id: String) throws {
    let inputSource = try findInput(id, includeAllInstalled: true)

    if TISEnableInputSource(inputSource.source) != noErr {
      throw InputSourceControllerError.failedToInstall(id: id)
    }
  }

  public func uninstall(_ inputSource: InputSource) throws {
    try uninstall(inputSource.id)
  }

  public func uninstall(_ id: String) throws {
    let inputSource = try findInput(id, includeAllInstalled: false)

    if TISDisableInputSource(inputSource.source) != noErr {
      throw InputSourceControllerError.failedToUninstall(id: id)
    }
  }

  @discardableResult
  public func select(_ inputSource: InputSource) throws -> InputSource {
    try select(inputSource.id)
  }

  @discardableResult
  public func select(_ id: String) throws -> InputSource {
    let inputSource = try findInput(id, includeAllInstalled: false)

    if TISSelectInputSource(inputSource.source) != noErr {
      throw InputSourceControllerError.failedToSelect(id: id)
    }

    return inputSource
  }

  public func findInput(_ id: String, includeAllInstalled: Bool) throws -> InputSource {
    guard let matchingInputSource = fetchInputSources(includeAllInstalled: includeAllInstalled)
      .first(where: { $0.id == id }) else {
      throw InputSourceControllerError.failedToFindInputSource(id: id)
    }

    return matchingInputSource
  }
}
