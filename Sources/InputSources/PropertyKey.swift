import Carbon

enum PropertyKey {
  case id, modeId
  case isAsciiCapable
  case isEnableCapable
  case isSelectCapable
  case isEnabled
  case isSelected
  case localizedName

  var rawValue: CFString {
    switch self {
    case .id:
      return kTISPropertyInputSourceID
    case .modeId:
      return kTISPropertyInputModeID
    case .isAsciiCapable:
      return kTISPropertyInputSourceIsASCIICapable
    case .isEnableCapable:
      return kTISPropertyInputSourceIsEnableCapable
    case .isSelectCapable:
      return kTISPropertyInputSourceIsSelectCapable
    case .isEnabled:
      return kTISPropertyInputSourceIsEnabled
    case .isSelected:
      return kTISPropertyInputSourceIsSelected
    case .localizedName:
      return kTISPropertyLocalizedName
    }
  }
}
