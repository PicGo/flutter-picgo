/// Returns true if s is either null, empty or is solely made of whitespace characters (as defined by String.trim).

bool isBlank(String s) => s == null || s.trim().isEmpty;