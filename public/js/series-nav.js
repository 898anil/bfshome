document.addEventListener('DOMContentLoaded', function() {
    const toggle = document.querySelector('.series-nav-toggle');
    const nav = document.querySelector('.series-navigation');

    if (toggle && nav) {
        toggle.addEventListener('click', function() {
            nav.classList.toggle('show');
        });

        // Close when clicking outside
        document.addEventListener('click', function(e) {
            if (!nav.contains(e.target) && !toggle.contains(e.target)) {
                nav.classList.remove('show');
            }
        });
    }
}); 