# spec/support/svg_helper.rb
require 'nokogiri'

module SvgHelper
  def normalize_svg(svg)
    doc = Nokogiri::XML(svg)
    doc.remove_namespaces!
    doc.to_xml(indent: 0).gsub(/\s+/, ' ').strip.sub(/\A<\?xml.*?\?>\s*/, '') # Remove o cabeçalho
  end
end

RSpec.configure do |config|
  config.include SvgHelper
end
