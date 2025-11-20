// BrainSAIT Custom JavaScript

document.addEventListener('DOMContentLoaded', function() {
  // Add any custom JavaScript functionality here
  
  // Example: Add smooth scrolling for anchor links
  document.querySelectorAll('a[href^="#"]').forEach(anchor => {
    anchor.addEventListener('click', function (e) {
      e.preventDefault();
      const target = document.querySelector(this.getAttribute('href'));
      if (target) {
        target.scrollIntoView({
          behavior: 'smooth',
          block: 'start'
        });
      }
    });
  });
  
  // Example: Add copy feedback for code blocks
  const codeBlocks = document.querySelectorAll('pre code');
  codeBlocks.forEach(block => {
    block.addEventListener('copy', function() {
      console.log('Code copied to clipboard');
    });
  });
});
