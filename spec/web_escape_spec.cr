require "./spec_helper"

describe WebEscape do
  describe ".escape_json" do
    it "escapes </script> breakout" do
      WebEscape.escape_json("</script>").should eq("\\u003c/script\\u003e")
    end

    it "escapes <!-- injection" do
      result = WebEscape.escape_json("<!--<script>")
      result.should_not contain("<!--<script>")
      result.should eq("\\u003c!--\\u003cscript\\u003e")
    end

    it "escapes & ampersand" do
      WebEscape.escape_json("a & b").should eq("a \\u0026 b")
    end

    it "escapes U+2028 LINE SEPARATOR" do
      WebEscape.escape_json(" ").should eq("\\u2028")
    end

    it "escapes U+2029 PARAGRAPH SEPARATOR" do
      WebEscape.escape_json(" ").should eq("\\u2029")
    end

    it "leaves a safe JSON string unchanged" do
      json = %({"key":"value","n":42})
      WebEscape.escape_json(json).should eq(json)
    end
  end

  describe ".escape_html" do
    it "escapes <" do
      WebEscape.escape_html("<").should eq("&lt;")
    end

    it "escapes >" do
      WebEscape.escape_html(">").should eq("&gt;")
    end

    it "escapes &" do
      WebEscape.escape_html("&").should eq("&amp;")
    end

    it "escapes double quote" do
      WebEscape.escape_html("\"").should eq("&quot;")
    end

    it "leaves plain text unchanged" do
      WebEscape.escape_html("hello world").should eq("hello world")
    end
  end

  describe ".escape_uri" do
    it "percent-encodes special chars in a path component" do
      WebEscape.escape_uri("ada+test@example.com").should eq("ada%2Btest%40example.com")
    end
  end
end
