# Jekyll hook to inject tabs functionality directly into index.html
# This runs after pages are rendered, so it's guaranteed to work

Jekyll::Hooks.register :pages, :post_render do |page|
  # Only process the index page
  next unless page.url == '/' || page.url == '/index.html'
  next unless page.output
  
  # Tabs script to inject
  tabs_script = <<~SCRIPT
    <script>
    (function() {
      'use strict';
      if (window.__tabsInitialized) return;
      window.__tabsInitialized = true;

      const sectionMap = {
        'education': 'Education',
        'work-experience': 'Experience',
        'selected-projects-and-research': 'Research',
        'personal-projects': 'Projects',
        'finance-projects': 'Finance',
        'publications': 'Publications',
        'presentations': 'Presentations',
        'sample-research-poster': 'Posters',
        'sample-industry-poster': 'Posters'
      };

      function initTabs() {
        const sections = {};
        const tabLabels = new Set();
        
        // Find sections by ID
        Object.keys(sectionMap).forEach(sectionId => {
          const section = document.getElementById(sectionId);
          if (section) {
            const tabLabel = sectionMap[sectionId];
            tabLabels.add(tabLabel);
            
            // Find the container
            let container = section.closest('.container');
            if (!container) {
              container = section.parentElement;
            }
            
            if (container) {
              if (!sections[tabLabel]) {
                sections[tabLabel] = [];
              }
              sections[tabLabel].push(container);
            }
          }
        });

        if (Object.keys(sections).length === 0) {
          return;
        }

        // Handle poster sections
        if (sections['Posters'] && sections['Posters'].length > 1) {
          const posters = sections['Posters'];
          const firstPoster = posters[0];
          const parent = firstPoster.parentElement;
          
          const wrapper = document.createElement('div');
          wrapper.className = 'container section-in-tabs';
          wrapper.setAttribute('data-tab-section', 'Posters');
          wrapper.style.display = 'none';
          
          parent.insertBefore(wrapper, firstPoster);
          posters.forEach(post => wrapper.appendChild(post));
          sections['Posters'] = [wrapper];
        }

        // Mark all sections
        Object.keys(sections).forEach(tabLabel => {
          sections[tabLabel].forEach(container => {
            container.classList.add('section-in-tabs');
            container.setAttribute('data-tab-section', tabLabel);
            container.style.display = 'none';
          });
        });

        // Find insertion point
        const aboutMe = document.getElementById('about-me');
        const mainContent = document.querySelector('main');
        
        if (!mainContent) return;

        // Create navigation
        const navContainer = document.createElement('div');
        navContainer.className = 'main-nav-tabs';
        
        const navList = document.createElement('div');
        navList.className = 'tabs-nav';
        
        const tabLabelsArray = Array.from(tabLabels).sort();
        tabLabelsArray.forEach((tabLabel, index) => {
          const button = document.createElement('button');
          button.className = 'tab-button' + (index === 0 ? ' active' : '');
          button.textContent = tabLabel;
          button.setAttribute('data-tab', tabLabel);
          button.setAttribute('type', 'button');
          button.addEventListener('click', function() { switchTab(tabLabel); });
          navList.appendChild(button);
        });
        
        navContainer.appendChild(navList);
        
        // Insert navigation after About Me
        const aboutMeContainer = aboutMe ? aboutMe.closest('.container') : null;
        if (aboutMeContainer && aboutMeContainer.nextSibling) {
          aboutMeContainer.parentElement.insertBefore(navContainer, aboutMeContainer.nextSibling);
        } else if (mainContent.firstChild) {
          mainContent.insertBefore(navContainer, mainContent.firstChild);
        } else {
          mainContent.appendChild(navContainer);
        }

        // Show first tab
        if (tabLabelsArray.length > 0) {
          switchTab(tabLabelsArray[0], false);
        }
      }

      function switchTab(tabLabel, animate) {
        animate = animate !== false;
        document.querySelectorAll('.tab-button').forEach(function(btn) {
          btn.classList.remove('active');
          if (btn.getAttribute('data-tab') === tabLabel) {
            btn.classList.add('active');
          }
        });

        document.querySelectorAll('.section-in-tabs').forEach(function(section) {
          section.classList.remove('active');
          section.style.display = 'none';
        });
        
        document.querySelectorAll('.section-in-tabs[data-tab-section="' + tabLabel + '"]').forEach(function(section) {
          section.classList.add('active');
          section.style.display = 'block';
        });
        
        if (animate) {
          const navContainer = document.querySelector('.main-nav-tabs');
          if (navContainer) {
            navContainer.scrollIntoView({ behavior: 'smooth', block: 'start' });
          }
        }
      }

      // Initialize
      function tryInit() {
        const main = document.querySelector('main');
        const education = document.getElementById('education');
        
        if (main && education) {
          setTimeout(initTabs, 100);
        } else {
          if (typeof tryInit.retries === 'undefined') {
            tryInit.retries = 0;
          }
          tryInit.retries++;
          if (tryInit.retries < 50) {
            setTimeout(tryInit, 100);
          }
        }
      }

      if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', tryInit);
      } else {
        tryInit();
      }
    })();
    </script>
  SCRIPT

  # Inject before </body>
  page.output = page.output.gsub('</body>', tabs_script + '</body>')
end
