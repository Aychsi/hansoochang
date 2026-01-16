# Jekyll hook to inject tabs navigation HTML directly into the page
# This adds the navigation bar as actual HTML, not just a script

Jekyll::Hooks.register :pages, :post_render do |page|
  next unless page.url == '/' || page.url == '/index.html'
  next unless page.output
  
  # Navigation HTML to inject after About Me section
  nav_html = <<~HTML
    <div class="main-nav-tabs">
      <div class="tabs-nav">
        <button class="tab-button active" data-tab="Education" type="button">Education</button>
        <button class="tab-button" data-tab="Experience" type="button">Experience</button>
        <button class="tab-button" data-tab="Research" type="button">Research</button>
        <button class="tab-button" data-tab="Projects" type="button">Projects</button>
        <button class="tab-button" data-tab="Finance" type="button">Finance</button>
        <button class="tab-button" data-tab="Publications" type="button">Publications</button>
        <button class="tab-button" data-tab="Presentations" type="button">Presentations</button>
        <button class="tab-button" data-tab="Posters" type="button">Posters</button>
      </div>
    </div>
  HTML

  # Inject navigation after About Me section
  if page.output.include?('id="about-me"')
    # Find the closing div of the about-me container and insert nav after it
    page.output = page.output.gsub(
      /(<\/div>\s*<\/div>\s*<\/div>\s*<\/div>\s*<\/main>)/,
      nav_html + '\1'
    )
  end
end
