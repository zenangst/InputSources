import Carbon

public final class InputSource: Hashable {
  public let id: String
  public let modeID: String?
  public let isASCIICapable: Bool
  public let isEnableCapable: Bool
  public let isEnabled: Bool
  public let isSelectCapable: Bool
  public let isSelected: Bool
  public let localizedName: String?
  public let source: TISInputSource

  init(source: TISInputSource) throws {
    self.id = try source.value(.id, type: String.self)
    self.modeID = source.optionalValue(.modeId, type: String.self)

    self.isASCIICapable = source.valueWithDefault(.isAsciiCapable, defaultValue: false)
    self.isEnableCapable = source.valueWithDefault(.isEnableCapable, defaultValue: false)
    self.isEnabled = source.valueWithDefault(.isEnabled, defaultValue: false)
    self.isSelectCapable = source.valueWithDefault(.isSelectCapable, defaultValue: false)
    self.isSelected = source.valueWithDefault(.isSelected, defaultValue: false)

    self.localizedName = try source.value(.localizedName, type: String.self)
    self.source = source
  }

  public func hash(into hasher: inout Hasher) {
    hasher.combine(id)
    hasher.combine(modeID)
  }

  public static func == (lhs: InputSource, rhs: InputSource) -> Bool {
    return lhs.id == rhs.id && lhs.modeID == rhs.modeID
  }
}
