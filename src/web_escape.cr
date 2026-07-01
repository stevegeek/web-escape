require "html"
require "uri"

module WebEscape
  extend self

  # Characters safe in JSON but unsafe in an HTML <script> context: prevents
  # </script> breakout, <!-- injection, and mXSS via U+2028/U+2029.
  # Replacements are \uXXXX sequences (valid JSON string escapes).
  # Implements Ruby's ERB::Util.json_escape escaping semantics.
  HTML_UNSAFE_IN_SCRIPT = {
    '<'      => "\\u003c",
    '>'      => "\\u003e",
    '&'      => "\\u0026",
    ' ' => "\\u2028",
    ' ' => "\\u2029",
  }

  # Escape an already-serialized JSON string for safe embedding inside a <script>.
  def escape_json(json : String) : String
    json.gsub(HTML_UNSAFE_IN_SCRIPT)
  end

  # Escape plain text for HTML attribute values / text content (stdlib CGI.escapeHTML equiv).
  def escape_html(text : String) : String
    HTML.escape(text)
  end

  # Percent-encode a string as a URI path component (RFC 3986) -- e.g. for mailto: / CALADDRESS.
  def escape_uri(value : String) : String
    URI.encode_path(value)
  end
end
