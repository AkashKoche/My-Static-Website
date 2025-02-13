// Simple alert when the button is clicked
document.getElementById('clickMeButton').addEventListener('click', function() {
    alert('Button was clicked!');
});

// Handle form submission
document.getElementById('contactForm').addEventListener('submit', function(event) {
    event.preventDefault();
    const name = document.getElementById('name').value;
    const email = document.getElementById('email').value;
    const message = document.getElementById('message').value;

    // Basic validation
    if (name && email && message) {
        alert(`Thank you, ${name}! Your message has been sent.`);
        // Clear the form
        document.getElementById('contactForm').reset();
    } else {
        alert('Please fill out all fields.');
    }
});
