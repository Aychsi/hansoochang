# Jekyll plugin to inject tabs script
# Using a converter approach that's more reliable

module Jekyll
  class TabsInjector < Converter
    safe true
    priority :lowest

    def matches(ext)
      false  # Don't convert files, just hook into the process
    end

    def output_ext(ext)
      ext
    end

    def convert(content)
      content
    end
  end
end

# Also register a hook as backup
Jekyll::Hooks.register :site, :post_render do |site|
  site.pages.each do |page|
    next unless page.output
    next unless page.url == '/' || page.url == '/index.html'
    
    # Read the tabs.js file and inject inline
    tabs_js_path = File.join(site.source, 'assets', 'tabs.js')
    if File.exist?(tabs_js_path)
      tabs_script = File.read(tabs_js_path)
      page.output = page.output.gsub(
        /<\/body>/i,
        "<script>#{tabs_script}</script></body>"
      )
    end
  end
end
