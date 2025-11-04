// Display current year
document.getElementById("year").textContent = new Date().getFullYear();

// Simple alert button function
function showAlert() {
  alert("Welcome to MySite!");
}

// Form submission simulation
const form = document.getElementById("contactForm");
const status = document.getElementById("formStatus");

form.addEventListener("submit", function (e) {
  e.preventDefault();
  status.textContent = "Sending message...";
  setTimeout(() => {
    status.textContent = "Message sent successfully!";
    form.reset();
  }, 1000);
});
